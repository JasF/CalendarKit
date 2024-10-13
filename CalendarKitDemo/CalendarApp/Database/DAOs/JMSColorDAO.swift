//
//  JMSColorDAO.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 13.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation

@objcMembers open class JMSColorDAO : JMSBaseDAO {
    override open func tableName() -> String {
        return "color"
    }
    override open func modelClass() -> AnyClass {
        return JMSColor.self
    }
    override open func modelClasses() -> [AnyClass] {
        return [JMSColor.self]
    }
    override open func primaryKeyName() -> String {
        return "uid"
    }
    override open func primaryKeyType() -> String {
        return "TEXT"
    }
}
