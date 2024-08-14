//
//  BaseDAO.swift
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

import FMDB

import Foundation
import SwiftReflection
import CocoaLumberjack

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}

@objcMembers open class JMSBaseDAO : NSObject {
    var db: FMDatabaseQueue!
    var rowid: String?
    
    let jsonTypes = ["NSDictionary", "NSMutableDictionary", "NSOrderedSet", "NSSet", "NSArray", "NSMutableArray"]
    func sqlTypeForType(_ type: String) -> String? {
        let textTypes = ["NSString", "NSData"]
        let integerTypes = ["NSNumber", "NSInteger", "Bool", "NSDate"]
        if textTypes.contains(type) {
            return "TEXT"
        }
        else if integerTypes.contains(type) {
            return "INTEGER"
        }
        else if jsonTypes.contains(type) {
            return "TEXT"
        }
        else {
            if type == "Any" {
                
            }
            else if type.range(of: "JMS") != nil {
                return "TEXT"
            }
            else {
                JMSAssert(false)
            }
        }
        
        return nil
    }
    var _paramsDictionary: Dictionary<String, String>?
    var _typesDictionary = [String: String]()
    func paramsDictionary() -> Dictionary<String, String> {
        if _paramsDictionary != nil {
            return _paramsDictionary!
        }
        let mapping = objectMapping()
        var dict = Dictionary<String, Any>()
        for cls in modelClasses() {
            let props = getTypesOfProperties(in: cls as! NSObject.Type)
            if let props = props {
                dict += props
            }
        }
        var resultDict = Dictionary<String, String>()
        for v in dict {
            if let cls = v.value as? AnyClass {
                if let strValue = NSStringFromClass(cls) as String? {
                    _typesDictionary[v.key] = strValue
                }
            }
        }
        for prop in mapping!.propertyMappings {
            if let pm = prop.value as? EKPropertyMapping {
                if let type = dict[pm.property] {
                    let typeString = String(describing: type)
                    if let sqltype = sqlTypeForType(typeString) {
                        resultDict[pm.property] = sqltype
                    }
                    else {
                        print("ignore property with type: \(type)")
                    }
                }
                else {
                    JMSAssert(false, "type not found for property: \(pm.property)")
                }
            }
        }
        _paramsDictionary = resultDict
        return _paramsDictionary!
    }
    
    func params() -> [String] {
        return Array(paramsDictionary().keys)
    }
    
    func getKeyValues() -> String {
        let resultString = paramsDictionary().filter({ (key,value) -> Bool in
            return key != rowid!
        }).map{ "\($0) \($1)" }.joined(separator: ", ")
        return resultString
    }
    
    func createTableScript() -> String {
        let keyvalues = getKeyValues()
        let autoincrementStroke = isAutoincrement() ? " AUTOINCREMENT" : ""
        let script = "CREATE TABLE IF NOT EXISTS \(tableName()) (\(rowid!) \(primaryKeyType()) PRIMARY KEY\(autoincrementStroke), \(keyvalues));"
        return script
    }
    
    let factory:JMSDatabase
    init?(_ factory: JMSDatabase?) {
        if factory == nil {
            return nil
        }
        self.factory = factory!
        super.init()
        open()
    }
    
    @objc public func close() {
        self.db.close()
        self.db = nil
    }
    
    public func deleteDatabaseFile() {
        factory.deleteDatabaseFile(tableName())
    }
    
    //+ (void)createIndexIfNotExists:(NSString *)name columns:(NSArray *)columns
    public func createIndexIfNotExists(_ name: String, columns: [String]) {
        let script = "CREATE INDEX IF NOT EXISTS \(name) ON \(tableName()) (\(columns.joined(separator: ",")))"
        self.db.inTransaction { (db, rollback) in
            let result = db.executeUpdate(script, withArgumentsIn: [])
            if result == false {
                print("create index for \(tableName()) error: \(db.lastError())\n\n CREATE INDEX script:\(script)")
            }
        }
    }
    public func open() {
        let db = factory.databaseQueue(tableName())
        if db == nil {
            return
        }
        self.db = db!
        rowid = primaryKeyName()
        let script = createTableScript()
        
        self.db.inTransaction { (db, rollback) in
            let result = db.executeUpdate(script, withArgumentsIn: [])
            if result == false {
                print("create table for \(tableName()) error: \(db.lastError())\n\n CREATE TABLE script:\(script)")
            }
        }
    }
    
    private func dbResultsToArray(_ dbResults: FMResultSet?) -> [NSBeforeManagedObject] {
        var results = [NSBeforeManagedObject]()
        let mapping = objectMapping()
        if let dbResults = dbResults {
            while dbResults.next() == true
            {
                let dict = dbResults.resultDictionary
                let object = EKMapper.object(fromExternalRepresentation: dict!, with: mapping!) as! NSBeforeManagedObject
                object.cached = true
                results.append(object)
            }
        }
        return results
    }
    
    public func allObjects() -> [NSBeforeManagedObject] {
        if db == nil {
            return []
        }
        return doAllObjects()
    }
    
    private func doAllObjects() -> [NSBeforeManagedObject] {
        let script = "SELECT * FROM \(tableName())";
        var results:[NSBeforeManagedObject]? = nil
        self.db.inTransaction { (db, rollback) in
            do {
                var dbResults: FMResultSet? = nil
                try dbResults = db.executeQuery(script, values: [])
                results = dbResultsToArray(dbResults)
            }
            catch {
                
            }
        }
        
        if results == nil {
            return []
        }
        return results!
    }
    
    public func update(_ aObjects: [NSBeforeManagedObject]?) {
        if db == nil {
            return
        }
        self.doUpdate(aObjects)
    }
    
    private func processDictForUpdate(_ dict: Dictionary<String, Any>?) -> Dictionary<String, Any> {
        guard var dict = dict else { return [:] }
        for v in dict {
            if let type = _typesDictionary[v.key] {
                if type.range(of: "JMS") != nil {
                    let cls :EKMappingProtocol.Type? = NSClassFromString(type) as! EKMappingProtocol.Type?
                    JMSAssert(cls != nil, "must be exists")
                    if cls == nil {
                        continue;
                    }
                    
                    
                    
                    var representation = EKSerializer.serializeObject(v.value, with: (cls?.objectMapping())!, options:EKSerializerOptions.EKSOJsonCompatible)
                    representation = processDictForUpdate(representation)
                    //DDLogInfo("representation is \(representation)")
                    // let string = NSBeforeManagedObject.json(from: representation) // FOR DEBUGGING PURPOSES
                    
                    if let data = try? JSONSerialization.data(withJSONObject: representation, options: []) {
                        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        dict[v.key] = string
                    }
                    else {
                        JMSAssert(false)
                        dict.remove(at: dict.index(forKey: v.key)!)
                    }
                }
                else if jsonTypes.contains(type) {
                    //DDLogInfo("value type: \(type(of:v.value))")
                    if let data = try? JSONSerialization.data(withJSONObject: v.value, options: []) {
                        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        dict[v.key] = string
                    }
                    else {
                        JMSAssert(false)
                        dict.remove(at: dict.index(forKey: v.key)!)
                    }
                }
            }
        }
        return dict
    }
    
    private func generateUpdateScript(_ dict: Dictionary<String, Any>, strings: [String]) -> String? {
        let rowidValue = dict[rowid!]
        if rowidValue == nil {
            if isAutoincrement() {
                return nil
            }
            JMSAssert(false, "rowid for \(String(describing: type(of: modelClass()))) not defined")
            return nil
        }
        let updatesString = strings.filter{$0 != rowid!}.map{"\($0)=:\($0)"}.joined(separator: ",")
        if updatesString.count == 0 {
            return nil
        }
        let updateScript = "UPDATE \(tableName()) SET \(updatesString) WHERE \(rowid!) = :\(rowid!)"
        return updateScript
    }
    
    @objc public func injectSqlScripts(_ scripts: [String], parameters: [[String:Any]]) {
        var index = 0
        
        self.db.inTransaction { (db, rollback) in
            for script in scripts {
                let dict = parameters[index]
                index = index + 1
                let result = db.executeUpdate(script, withParameterDictionary: dict)
                if result == false {
                    let errorCode = db.lastErrorCode()
                    self.checkError(code:Int(errorCode))
                    if errorCode == 0 {
                        continue // all right
                    }
                    else if errorCode != 19 {
                        // CODES AND DESCRIPTIONS INSIDE MessageError.handleDatabaseError !
                        
                        JMSAssert(false)
                    }
                    print("error insert data on database \(tableName()) with error: \(db.lastError())\n\nindex: \(index). \n\nMaybe use update for this dictionary?")
                }
            }
        }
        index = 0
    }
    
    @objc private func doUpdate(_ aObjects: [NSBeforeManagedObject]?) {
        guard let objects = aObjects else { return }
        let paramsList = params()
        func dict2Strings(_ dict: Dictionary<AnyHashable, Any>?) -> [String] {
            let filtered = (dict?.keys)!.filter { paramsList.contains($0 as! String)}
            let strings = Array(filtered) as! [String]
            return strings
        }
        
        var insertScripts = [String]()
        var insertDicts = [[String:Any]]()
        //var updateScripts = [String]()
        //var updateDicts = [[String:Any]]()
        let autoincremented = isAutoincrement()
        for object in objects {
            var dict = object.toJsonDictionary()
            dict = processDictForUpdate(dict as? [String:Any])
            if dict == nil {
                continue
            }
            var strings = dict2Strings(dict)
            if strings.count == 0 {
                if primaryKeyType() == "INTEGER" {
                    dict![rowid!] = 0
                }
                else if primaryKeyType() == "TEXT" {
                    dict![rowid!] = ""
                }
                else {
                    JMSAssert(false, "unknown primary key type")
                }
                strings = dict2Strings(dict)
            }
            /*
            if object.cached {
                let updateScript = generateUpdateScript(dict as! Dictionary<String, Any>, strings:strings)
                if updateScript == nil {
                    continue
                }
                updateScripts.append(updateScript!)
                updateDicts.append(dict as! [String : Any])
            }
            else {
                */
                let paramsString = strings.joined(separator: ",")
                let valuesString = strings.map{":\($0)"}.joined(separator: ",")
                /*
                #if DEBUG
                #else
                let insertScript = "INSERT OR IGNORE INTO \(tableName()) (\(paramsString)) VALUES(\(valuesString))"
                #endif
                */
                let insertScript = "INSERT OR REPLACE INTO \(tableName()) (\(paramsString)) VALUES(\(valuesString))"
                insertScripts.append(insertScript)
                insertDicts.append(dict as! [String : Any])
           // }
            if autoincremented == true {
                object.cached = true
            }
        }
        
        //DDLogInfo("constructing scripts: \(-date.timeIntervalSinceNow)")
        //date = Date()
        var index = 0
        
        self.db.inTransaction { (db, rollback) in
            for script in insertScripts {
                let dict = insertDicts[index]
                index = index + 1
                let result = db.executeUpdate(script, withParameterDictionary: dict)
                if result == false {
                    let errorCode = db.lastErrorCode()
                    self.checkError(code:Int(errorCode))
                    if errorCode == 0 {
                        continue // all right
                    }
                    else if errorCode != 19 {
                        JMSAssert(false)
                    }
                    print("error insert data on database \(tableName()) with error: \(db.lastError())\n\nindex: \(index). \n\nMaybe use update for this dictionary?")
                }
            }
        }
        index = 0
    }
    
    open func delete(_ object: NSBeforeManagedObject) {
        if db == nil {
            return
        }
        doDelete(object)
    }
    
    open func deleteObjects(_ objects: [NSBeforeManagedObject]) {
        if db == nil {
            return
        }
        doDeleteObjects(objects)
    }
    
    open func deleteAll() {
        if db == nil {
            return
        }
        self.db.inTransaction { (db, rollback) in
            if db.executeUpdate("DELETE FROM \(tableName())", withParameterDictionary: [:]) == false {
                JMSAssert(false)
                print("error delete ALL data on database \(tableName()) with error: \(db.lastError())")
            }
        }
    }
    
    private func doDelete(_ object: NSBeforeManagedObject) {
        let dict = object.toJsonDictionary()
        let rowidValue = dict![rowid!]
        if rowidValue == nil {
            if isAutoincrement() {
                return
            }
            JMSAssert(false, "cannot obtain key for object with description: \(String(describing: dict))")
        }
        else {
            if isAutoincrement() {
                if let num = rowidValue as! Int? {
                    JMSAssert(num > 0, "rowid missing")
                }
                else {
                    JMSAssert(false, "unknown rowid type")
                }
            }
            let script = "DELETE FROM \(tableName()) WHERE \(rowid!)=:\(rowid!)"
            self.db.inTransaction { (db, rollback) in
                if db.executeUpdate(script, withParameterDictionary: dict!) == false {
                    print("error delete data on database \(tableName()) with error: \(db.lastError())")
                }
            }
        }
    }
    
    
    private func doDeleteObjects(_ objects: [NSBeforeManagedObject]) {
        let script = "DELETE FROM \(tableName()) WHERE \(rowid!)=:\(rowid!)"
        
        self.db.inTransaction { (db, rollback) in
            for object in objects {
                let dict = object.toJsonDictionary()
                let rowidValue = dict![rowid!]
                if rowidValue == nil {
                    if isAutoincrement() {
                        return
                    }
                    JMSAssert(false, "cannot obtain key for object with description: \(String(describing: dict))")
                }
                else {
                    if isAutoincrement() {
                        if let num = rowidValue as! Int? {
                            JMSAssert(num > 0, "rowid missing")
                        }
                        else {
                            JMSAssert(false, "unknown rowid type")
                        }
                    }
                    if db.executeUpdate(script, withParameterDictionary: dict!) == false {
                        print("error delete data on database \(tableName()) with error: \(db.lastError())")
                    }
                }
                
            }
        }
    }
    
    open func objectsWithWhereClause(_ clause: String, attribute: String, attributes: NSDictionary?) -> [NSBeforeManagedObject] {
        if db == nil {
            return []
        }
        return doObjectsWithWhereClause(clause, attribute: attribute, attributes: attributes)
    }
    
    private func doObjectsWithWhereClause(_ clause: String, attribute aAttribute: String, attributes attrs: NSDictionary?) -> [NSBeforeManagedObject] {
        var attribute = aAttribute
        var script:String? = nil
        var functionString = "*"
        var dictResult = true
        var limitCount = 0
        var offset = 0
        var orderBy = ""
        var explain = 0
        if let attrs = attrs {
            for key in attrs.allKeys {
                let akey = key as! String
                if akey == "LIMIT" {
                    limitCount = attrs[key] as! Int
                }
                else if akey == "OFFSET" {
                    offset = attrs[key] as! Int
                }
                else if akey == "ORDER BY" {
                    orderBy = attrs[key] as! String
                }
                else if akey == "EXPLAIN" {
                    explain = attrs[key] as! Int
                }
            }
        }
        if attribute.count > 0 {
            if attribute.lowercased().contains("limit") == true {
                let ar = attribute.split(separator: " ")
                if ar.count == 2 {
                    limitCount = Int(ar[1])!
                    attribute = ""
                }
            }
        }
        if attribute == "count" {
            functionString = "count(\(rowid!))"
            dictResult = false
        }
        if explain == 1 {
            script = "EXPLAIN QUERY PLAN SELECT \(functionString) FROM \(tableName())"
        }
        else {
            script = "SELECT \(functionString) FROM \(tableName())"
        }
        
        if clause.count > 0 {
            script = script! + " WHERE \(clause)"
        }
        if orderBy.count > 0 {
            script = script! + " ORDER BY \(orderBy)"
        }
        if limitCount > 0 {
            script = script! + " LIMIT \(limitCount)"
        }
        if offset > 0 {
            script = script! + " OFFSET \(offset)"
        }
        var results:[NSBeforeManagedObject]? = nil
        
        self.db.inTransaction { (db, rollback) in
            let dbResults = db.executeQuery(script!, withParameterDictionary: [:])
            self.checkError(db)
            if db.lastErrorCode() != 0 {
                print("clause error: \(db.lastErrorMessage())")
                JMSAssert(false)
            }
            else {
                #if DEBUG
                if explain == 1 {
                    if dbResults?.next() == true
                    {
                        let dict = dbResults!.resultDictionary!
                        print("dict is: \(dict)")
                    }
                }
                #endif
                if dictResult == false {
                    if dbResults?.next() == true {
                        let dict = dbResults?.resultDictionary
                        if let value = dict![functionString] as? NSNumber {
                            let number = NSSQLNumber.init(value)
                            results = [number] as? [NSBeforeManagedObject]
                        }
                    }
                }
                else {
                    results = dbResultsToArray(dbResults)
                }
            }
        }
        
        if (results?.count ?? 0) > 0 {
            print("something fetched! \(String(describing: results))")
        }
        if results == nil {
            return []
        }
        return results!
    }
    
    public func objectsWithClause(_ clause: String, parameters: [AnyHashable:Any]) -> [NSBeforeManagedObject] {
        var script:String? = nil
        let functionString = "*"
        script = "SELECT \(functionString) FROM \(tableName())"
        if clause.count > 0 {
            script = script! + " WHERE \(clause)"
        }
        var results:[NSBeforeManagedObject]? = nil
        self.db.inTransaction { (db, rollback) in
            let dbResults = db.executeQuery(script!, withParameterDictionary: parameters)
            self.checkError(db)
            if db.lastErrorCode() != 0 {
                print("clause error: \(db.lastErrorMessage())")
                JMSAssert(false)
            }
            else {
                results = dbResultsToArray(dbResults)
            }
        }
        if (results?.count)! > 0 {
            print("something fetched! \(String(describing: results))")
        }
        if results == nil {
            return []
        }
        return results!
    }
    
    // abstract methods
    open func tableName() -> String {
        JMSAssert(false, "absract implementation")
        return ""
    }
    
    open func modelClass() -> AnyClass {
        JMSAssert(false, "absract implementation")
        return type(of:self)
    }
    
    open func modelClasses() -> [AnyClass] {
        return [modelClass()]
    }
    
    func objectMapping() -> EKObjectMapping? {
        guard let cls = modelClass() as? EKMappingProtocol.Type else {
            JMSAssert(false, "class \(modelClass()) does not conform protocol")
            return nil
        }
        return cls.objectMapping()
    }
    open func primaryKeyName() -> String {
        return "iid"
    }
    open func primaryKeyType() -> String {
        return "INTEGER"
    }
    open func isAutoincrement() -> Bool {
        return false
    }
    func checkError(_ db: FMDatabase) {
        checkError(code: Int(db.lastErrorCode()))
    }
    
    func checkError(code: Int) {
        if code == 5 || code == 13 || code == 14 {
            // Database is locked. Delete database on startup
            //JMSUserSettings.sharedInstance().needsCleanDatabaseOnStartup = true
        }
    }
}
