//
//  DAOFactory.swift
//  Masters
//
//  Created by Jasf on 17.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

import Foundation

@objcMembers class JMSDAOFactory : NSObject {
    let daoAssembly: JMSDAOAssembly
    @objc init(_ daoAssembly: JMSDAOAssembly) {
        self.daoAssembly = daoAssembly
        super.init()
    }
    
    public func daoForObject(_ aObject: NSBeforeManagedObject?) -> JMSBaseDAO? {
        guard let object = aObject else { return nil }
        return daoForClass(type(of: object))
    }
    
    let accessors:Dictionary<String,String> = {
        var data = ["JMSOwnerUser":"ownerUserDAO"]
        
        return data
    }()
    
    
    public func allKeys() -> [String] {
        return Array<String>(accessors.keys)
    }
    
    public func allDaos() -> [JMSBaseDAO] {
        var result = [JMSBaseDAO]()
        for key in allKeys() {
            if let dao = daoForKey(key) {
                result.append(dao)
            }
        }
        return result
    }
    
    public func daoForClass(_ aClass: AnyClass?) -> JMSBaseDAO? {
        guard let cls = aClass else { return nil }
        let key = String(describing: cls)
        return daoForKey(key)
    }
    
    public func daoForKey(_ key: String) -> JMSBaseDAO? {
        switch key {
        case "JMSOwnerUser":
            return daoAssembly.ownerUserDAO()
        default:
            return nil
        }
        /*
        let selectorName = accessors[key]
        if selectorName == nil {
            JMSAssert(false)
            return nil
        }
        let selector = NSSelectorFromString(selectorName!)
        if let dao = daoAssembly.perform(selector) {
            return dao.retain().takeRetainedValue() as? JMSBaseDAO
        }
        JMSAssert(false, "missing implementation for \(String(describing: selectorName))")
         */
    }
}
