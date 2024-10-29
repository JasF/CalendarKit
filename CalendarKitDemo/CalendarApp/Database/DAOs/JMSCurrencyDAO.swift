//
//  JMSCurrencyDAO.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 29.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
@objcMembers open class JMSCurrencyDAO : JMSBaseDAO {
    override open func tableName() -> String {
        return "currency"
    }
    override open func modelClass() -> AnyClass {
        return JMSCurrency.self
    }
    override open func modelClasses() -> [AnyClass] {
        return [JMSCurrency.self]
    }
    override open func primaryKeyName() -> String {
        return "uid"
    }
    override open func primaryKeyType() -> String {
        return "TEXT"
    }
}
