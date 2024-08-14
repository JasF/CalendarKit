//
//  EasyMappingHelper.swift
//  Masters
//
//  Created by Jasf on 22.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

import Foundation

import EasyMapping

extension EKObjectMapping {
    @objc public func map(_ keyPath: String, with mapper: EKObjectMapping?) {
        mapKeyPath(keyPath, toProperty: keyPath, withValueBlock: { (key, value) -> Any? in
            if let value = value as? String? {
                guard let dict = try? JSONSerialization.jsonObject(with: value!.data(using: .utf8)!, options: JSONSerialization.ReadingOptions(rawValue: JSONSerialization.ReadingOptions.RawValue(0))) else {
                    return nil
                }
                let result = EKMapper.object(fromExternalRepresentation: dict as! [AnyHashable : Any], with: mapper!)
                return result
            }
            if let value = value as? [AnyHashable : Any]? {
                let result = EKMapper.object(fromExternalRepresentation: value!, with: mapper!)
                return result
            }
            return nil
        },
            reverse: { (value) -> Any? in
            let result = EKSerializer.serializeObject(value ?? [:], with: mapper!)
            return result
        })
    }
}

