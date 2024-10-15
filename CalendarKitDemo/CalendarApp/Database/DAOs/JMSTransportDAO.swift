//
//  JMSTransportDAO.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 15.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
@objcMembers open class JMSTransportDAO : JMSBaseDAO {
    override open func tableName() -> String {
        return "transport"
    }
    override open func modelClass() -> AnyClass {
        return JMSTransport.self
    }
    override open func modelClasses() -> [AnyClass] {
        return [JMSTransport.self]
    }
    override open func primaryKeyName() -> String {
        return "uid"
    }
    override open func primaryKeyType() -> String {
        return "TEXT"
    }
}

