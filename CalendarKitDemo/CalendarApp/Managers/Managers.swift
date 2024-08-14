//
//  Managers.swift
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

import Foundation
import CocoaLumberjack

extension Date {
    func dateYearString() -> String {
        /*
        let dateFormatter = DateFormatter.init()
        var withYear = false
        if (self as NSDate).year != (Date() as NSDate).year {
            withYear = true
        }
        dateFormatter.dateFormat = JMSOwnerUser.owner()?.date_style4() ?? ""
        dateFormatter.calendar = JMSCalendarHelper.sharedInstance().calendar
        dateFormatter.timeZone = JMSCalendarHelper.sharedInstance().timeZone
        var string = dateFormatter.styledString(from: self)
        string = string.byRemoveCurrentYearFromDate().capitalizeIfNeeded()
        if withYear {
            return "\(string)"
        }
        else {
            return string
        }*/
        return ""
    }
}

extension String {
    func localized() -> String {
        return ""//JMSUIHelper.localize(self)//NSLocalizedString(self, tableName: nil, value: self, comment: "")
    }
    func loc() -> String {
        return localized()
    }
}

func JMSAssert(_ isTrue: Bool) {
#if DEBUG
    if isTrue == false {
        print("IS DEBUG ASSERT isTrue: \(isTrue)")
        assert(isTrue)
    }
#else
    //DDLogInfo("IS NOT DEBUG ASSERT")
#endif
}

func JMSAssert(_ isTrue: Bool, _ message: String) {
    #if DEBUG
    assert(isTrue, message)
    #else
    
    #endif
}


@objcMembers class Managers : NSObject {
   // let phoneNumberKit = PhoneNumberKit()
    static fileprivate var _shared: Managers? = nil
    public var daoAssembly: JMSDAOAssembly
    public var applicationAssembly: JMSApplicationAssembly
    var retainArray = [Any]()
    @objc init(_ daoAssembly: JMSDAOAssembly, applicationAssembly: JMSApplicationAssembly) {
        self.daoAssembly = daoAssembly
        self.applicationAssembly = applicationAssembly
        super.init()
        Managers._shared = self
    }
    static public func shared() -> Managers {
        return self._shared!
    }
    @objc public func addToRetainArray(_ object: Any) {
        retainArray.append(object)
    }
    /*
    @objc public func formatPhoneNumber(_ phoneNumber: String) -> String {
        var result = ""
        do {
            let phoneNumber = try phoneNumberKit.parse(phoneNumber)
            result = phoneNumberKit.format(phoneNumber, toType: .international)
        }
        catch {
            return phoneNumber
        }
        return result
    }*/
    public func daoFactory() -> JMSDAOFactory {
        return daoAssembly.daoFactory()
    }
    public func databaseFactory() -> JMSDatabase {
        return daoAssembly.databaseFactory()
    }
    public func initializeIndexes() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                return
            }
            self.doCreateIndexes()
        }
    }
    func doCreateIndexes() {
        /*
        JMSEvent.createIndexIfNotExists("_start_index", columns: ["start"])
        JMSEvent.createIndexIfNotExists("_clientid_index", columns: ["clientID"])
        JMSExpense.createIndexIfNotExists("_date_index", columns: ["date"])
        JMSUser.createIndexIfNotExists("_userid_index", columns: ["userID"])
        JMSContact.createIndexIfNotExists("_profileid_index", columns: ["profileID"])
    */
    }
    @objc var dashboardVisible = false
    @objc func setDashboardVisible() {
        if dashboardVisible == true {
            return
        }
        dashboardVisible = true
       // JMSCacheCleaner.shared().executeCleaning()
       // DumpLogging.shared().sendLogsOrClear()
       // JMSNLogs.shared().clean()
    }
    func urlEncode(_ param: String) -> String {
        return param.urlEncode() as String
    }
}

extension String {

    func urlEncode() -> CFString {
        return CFURLCreateStringByAddingPercentEscapes(
            nil,
            self as CFString,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString,
            CFStringBuiltInEncodings.UTF8.rawValue
        )
    }

}
