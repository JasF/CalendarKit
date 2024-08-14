//
//  OwnerUserDAO.swift
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

@objcMembers open class JMSOwnerUserDAO : JMSBaseDAO {
    override open func tableName() -> String {
        return "owner_user"
    }
    override open func modelClass() -> AnyClass {
        return JMSOwnerUser.self
    }
    override open func modelClasses() -> [AnyClass] {
        return [JMSAbstractUser.self, JMSOwnerUser.self]
    }
    override open func primaryKeyName() -> String {
        return "uid"
    }
    override open func primaryKeyType() -> String {
        return "TEXT"
    }
}

