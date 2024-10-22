//
//  JMSClientDAO.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 22.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
@objcMembers open class JMSClientDAO : JMSBaseDAO {
    override open func tableName() -> String {
        return "client"
    }
    override open func modelClass() -> AnyClass {
        return JMSClient.self
    }
    override open func modelClasses() -> [AnyClass] {
        return [JMSClient.self]
    }
    override open func primaryKeyName() -> String {
        return "id"
    }
    override open func primaryKeyType() -> String {
        return "TEXT"
    }
}
