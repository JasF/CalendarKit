//
//  JMSSettingsViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 13.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation

class JMSSettingsHeaderCell : UITableViewCell {
    @IBOutlet var bigLetters: UILabel?
    @IBOutlet var smallLetter: UILabel?
    @IBOutlet var fontColor: UILabel?
    @IBOutlet var bgColor: UILabel?
    @IBOutlet var transport: UILabel?
    @IBOutlet var service: UILabel?
}

class JMSSettingsSwitcherCell : UITableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var switcher: UISwitch?
}

class JMSSettingsInfoCell : UITableViewCell {
    @IBOutlet var title: UILabel?
}

class JMSSettingsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    enum Cells:Int {
        case header, bigLetters, smallLetters, fontColor, bgColor, transport, services
    }
    
    var cells = [Cells.header, .bigLetters, .smallLetters, .fontColor, .bgColor, .transport, .services]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .header:
            return headerCell()
        case .bigLetters:
            return bigLettersCell()
        case .smallLetters:
            return smallLettersCell()
        case .fontColor:
            return fontColorCell()
        case .bgColor:
            return bgColorCell()
        case .transport:
            return transportCell()
        case .services:
            return servicesCell()
        }
    }
    
    func bigLettersCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsSwitcherCell") as! JMSSettingsSwitcherCell
        cell.title?.text = "Большие буквы"
        cell.switcher?.setOn(JMSOwnerUser.owner().bigLetters?.boolValue ?? false, animated: false)
        return cell
    }
    func smallLettersCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsSwitcherCell") as! JMSSettingsSwitcherCell
        cell.title?.text = "Маленькие буквы"
        cell.switcher?.setOn(JMSOwnerUser.owner().smallLetters?.boolValue ?? false, animated: false)
        return cell
    }
    
    
    
    func headerCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsHeaderCell") as! JMSSettingsHeaderCell
        let isBigLetters = JMSOwnerUser.owner().bigLetters?.boolValue ?? false
        cell.bigLetters?.text = "Большие буквы: \(isBigLetters ? "Вкл" : "Выкл")"
        let isSmallLetters = JMSOwnerUser.owner().smallLetters?.boolValue ?? false
        cell.smallLetter?.text = "Маленькие буквы: \(isSmallLetters ? "Вкл" : "Выкл")"
        let fontColorId = JMSOwnerUser.owner().fontColorId ?? ""
        var color: JMSColor?
        if fontColorId.isEmpty == false {
            color = JMSColor.jms_findSingle(with: NSPredicate(format: "uid == %@", fontColorId as NSString)) as? JMSColor
        }
        let colorName = color?.name ?? ""
        cell.fontColor?.text = "Цвет шрифта: \(colorName.isEmpty ? "Не выбрано" : colorName)"
        
        let bgColorId = JMSOwnerUser.owner().bgColorId ?? ""
        var bgColor: JMSColor?
        if bgColorId.isEmpty == false {
            bgColor = JMSColor.jms_findSingle(with: NSPredicate(format: "uid == %@", bgColorId as NSString)) as? JMSColor
        }
        let bgColorName = bgColor?.name ?? ""
        cell.bgColor?.text = "Цвет фона: \(bgColorName.isEmpty ? "Не выбрано" : bgColorName)"
        let transportId = JMSOwnerUser.owner().transportId ?? ""
        var transport: JMSTransport?
        if transportId.isEmpty == false {
            transport = JMSTransport.jms_findSingle(with: NSPredicate(format: "uid == %@", transportId as NSString)) as? JMSTransport
        }
        let transportName = transport?.name ?? ""
        cell.transport?.text = "Транспорт: \(transportName.isEmpty ? "Не выбрано" : transportName)"
        let serviceId = JMSOwnerUser.owner().serviceId ?? ""
        var service: JMSService?
        if serviceId.isEmpty == false {
            service = JMSService.jms_findSingle(with: NSPredicate(format: "uid == %@", serviceId as NSString)) as? JMSService
        }
        let serviceName = service?.name ?? ""
        cell.service?.text = "Услуги: \(serviceName.isEmpty ? "Не выбрано" : serviceName)"
        
        
        return cell
    }
    
    func fontColorCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsInfoCell") as! JMSSettingsInfoCell
        cell.title?.text = "Цвет шрифта"
        return cell
    }
    func bgColorCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsInfoCell") as! JMSSettingsInfoCell
        cell.title?.text = "Цвет фона"
        return cell
    }
    func transportCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsInfoCell") as! JMSSettingsInfoCell
        cell.title?.text = "Транспорт"
        return cell
    }
    func servicesCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsInfoCell") as! JMSSettingsInfoCell
        cell.title?.text = "Услуги"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch cells[indexPath.row] {
        case .bigLetters:
            handleTappedOnBigLettersSwitch(indexPath)
        case .smallLetters:
            handleTappedOnSmallLettersSwitch(indexPath)
        case .fontColor:
            showSelectFontColorViewController()
        case .bgColor:
            showSelectBgColorViewController()
        case .transport:
            showSelectTransportViewController()
        case .services:
            showSelectServiceViewController()
            
        default:
            break
        }
    }
    
    func handleTappedOnBigLettersSwitch(_ indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! JMSSettingsSwitcherCell
        let isOn = !(cell.switcher?.isOn ?? false)
        cell.switcher?.setOn(isOn, animated: true)
        JMSOwnerUser.owner().bigLetters = isOn as NSNumber
        DSCoreData.shared().saveContext(completion: {})
        updateHeader()
    }
    func handleTappedOnSmallLettersSwitch(_ indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! JMSSettingsSwitcherCell
        let isOn = !(cell.switcher?.isOn ?? false)
        cell.switcher?.setOn(isOn, animated: true)
        JMSOwnerUser.owner().smallLetters = isOn as NSNumber
        DSCoreData.shared().saveContext(completion: {})
        updateHeader()
        
    }
    
    
    func updateHeader() {
        tableView.reloadRows(at: [IndexPath(row: cells.firstIndex(of: .header)!, section: 0)], with: .fade)
    }
    
    func showSelectFontColorViewController() {
        let storyboard = UIStoryboard(name: "JMSSettingsSelectColorViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "JMSSettingsSelectColorViewController") as! JMSSettingsSelectColorViewController
        viewController.isBgColor = false
        viewController.colorSelectedBlock = { [weak self] (color) in
            JMSOwnerUser.owner().fontColorId = color?.uid ?? ""
            DSCoreData.shared().saveContext(completion: {})
            self?.updateHeader()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    func showSelectBgColorViewController() {
        let storyboard = UIStoryboard(name: "JMSSettingsSelectColorViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "JMSSettingsSelectColorViewController") as! JMSSettingsSelectColorViewController
        viewController.colorSelectedBlock = { [weak self] (color) in
            JMSOwnerUser.owner().bgColorId = color?.uid ?? ""
            DSCoreData.shared().saveContext(completion: {})
            self?.updateHeader()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    func showSelectTransportViewController() {
        let storyboard = UIStoryboard(name: "JMSTransportViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "JMSTransportViewController") as! JMSTransportViewController
        viewController.transportSelectedBlock = { [weak self] (transport) in
            JMSOwnerUser.owner().transportId = transport?.uid ?? ""
            DSCoreData.shared().saveContext(completion: {})
            self?.updateHeader()
        }
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    func showSelectServiceViewController() {
        let storyboard = UIStoryboard(name: "JMSServiceViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "JMSServiceViewController") as! JMSServiceViewController
        viewController.serviceSelectedBlock = { [weak self] (service) in
            JMSOwnerUser.owner().serviceId = service?.uid ?? ""
            DSCoreData.shared().saveContext(completion: {})
            self?.updateHeader()
        }
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
