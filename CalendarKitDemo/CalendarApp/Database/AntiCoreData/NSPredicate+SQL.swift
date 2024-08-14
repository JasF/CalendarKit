//
//  NSPredicate+SQL.swift
//  Masters
//
//  Created by Jasf on 25.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

import Foundation

extension NSPredicate {
    private struct AssociatedKeys {
        static var descriptiveName = "sql_attribute"
        static var descriptiveNameArray = "sql_attributes"
    }
    @objc var sqlAttribute: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.descriptiveName) as? String
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.descriptiveName,
                    newValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    @objc var sqlAttributes: [AnyHashable:Any]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.descriptiveNameArray) as? [AnyHashable:Any]
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.descriptiveNameArray,
                    newValue as [AnyHashable:Any],
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
            else {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.descriptiveNameArray,
                    nil,
                    .OBJC_ASSOCIATION_ASSIGN
                )
            }
        }
    }
}
