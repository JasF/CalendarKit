//
//  JMSEntityDescription.swift
//  Masters
//
//  Created by Jasf on 22.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

@objcMembers class JMSEntityDescription : NSObject {
    var context: JMSManagedObjectContext?
    var name: String?
    public static func entityForName(_ name: String, inManagedObjectContext context: JMSManagedObjectContext?) -> JMSEntityDescription {
        let entity = JMSEntityDescription()
        entity.name = name
        entity.context = context
        return entity;
    }
}

