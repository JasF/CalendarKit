//
//  JMSDatabase.swift
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

import Foundation
import FMDB

@objcMembers open class JMSDatabase : NSObject {
    override init() {
        super.init()
    }
    
    public func database(_ filename: String) -> FMDatabase? {
        let db = FMDatabase(path: self.filePath(filename))
        if db.open() == true {
            return db
        }
        return nil
    }
    public func databaseQueue(_ filename: String) -> FMDatabaseQueue? {
        let db = FMDatabaseQueue(path: self.filePath(filename))
        if db == nil {
            JMSAssert(false)
        }
        return db
    }
    public func deleteDatabaseFile(_ filename: String) {
        let filepath = filePath(filename)
        do {
            try FileManager.default.removeItem(atPath: filepath)
        }
        catch {
            print("unexpected error: \(error)")
        }
    }
    
    private func filePath(_ aFilename: String) -> String {
        let filename = aFilename + ".db"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var dir = paths[0] as NSString
        dir = dir.appendingPathComponent("db") as NSString
        if !FileManager.default.fileExists(atPath: dir as String, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(atPath: dir as String, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                
            }
        }
        return dir.appendingPathComponent(filename)
    }
}
