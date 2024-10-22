//
//  JMSServiceDAO.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 21.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
@objcMembers open class JMSServiceDAO : JMSBaseDAO {
    override open func tableName() -> String {
        return "service"
    }
    override open func modelClass() -> AnyClass {
        return JMSService.self
    }
    override open func modelClasses() -> [AnyClass] {
        return [JMSService.self]
    }
    override open func primaryKeyName() -> String {
        return "uid"
    }
    override open func primaryKeyType() -> String {
        return "TEXT"
    }
}
