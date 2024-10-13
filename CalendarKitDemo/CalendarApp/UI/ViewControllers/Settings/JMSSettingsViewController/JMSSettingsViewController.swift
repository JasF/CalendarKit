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
    @IBOutlet var fontColor: UILabel?
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
        case header, bigLetters, fontColor
    }
    
    var cells = [Cells.header, .bigLetters, .fontColor]
    
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
        case .fontColor:
            return fontColorCell()
        }
    }
    
    func bigLettersCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsSwitcherCell") as! JMSSettingsSwitcherCell
        cell.title?.text = "Большие буквы"
        cell.switcher?.setOn(JMSOwnerUser.owner().bigLetters?.boolValue ?? false, animated: false)
        return cell
    }
    
    func headerCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsHeaderCell") as! JMSSettingsHeaderCell
        let isBigLetters = JMSOwnerUser.owner().bigLetters?.boolValue ?? false
        cell.bigLetters?.text = "Большие буквы: \(isBigLetters ? "Вкл" : "Выкл")"
        let fontColorId = JMSOwnerUser.owner().fontColorId ?? ""
        var color: JMSColor?
        if fontColorId.isEmpty == false {
            color = JMSColor.jms_findSingle(with: NSPredicate(format: "uid == %@", fontColorId as NSString)) as? JMSColor
        }
        let colorName = color?.name ?? ""
        cell.fontColor?.text = "Цвет шрифта: \(colorName.isEmpty ? "Не выбрано" : colorName)"
        return cell
    }
    
    func fontColorCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSettingsInfoCell") as! JMSSettingsInfoCell
        cell.title?.text = "Цвет шрифта"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch cells[indexPath.row] {
        case .bigLetters:
            handleTappedOnBigLettersSwitch(indexPath)
        case .fontColor:
            return showSelectFontColorViewController()
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
    
    func updateHeader() {
        tableView.reloadRows(at: [IndexPath(row: cells.firstIndex(of: .header)!, section: 0)], with: .fade)
    }
    
    func showSelectFontColorViewController() {
        let storyboard = UIStoryboard(name: "JMSSettingsSelectColorViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "JMSSettingsSelectColorViewController") as! JMSSettingsSelectColorViewController
        viewController.colorSelectedBlock = { [weak self] (color) in
            JMSOwnerUser.owner().fontColorId = color?.uid ?? ""
            DSCoreData.shared().saveContext(completion: {})
            self?.updateHeader()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
