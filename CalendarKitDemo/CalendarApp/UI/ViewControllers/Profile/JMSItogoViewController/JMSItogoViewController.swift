//
//  JMSItogoViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 11.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSItogoViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneItem: UIBarButtonItem?
    enum Cells:Int {
        case notice, food, age
    }
    let cells = [Cells.notice, .food, .age]
    override func viewDidLoad() {
        title = "Итоговая ячейка"
        doneItem?.isEnabled = false
        doneItem?.title = "Готово"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        updateDoneButton()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .notice:
            return noticeCell()
        case .food:
            return foodCell()
        case .age:
            return ageCell()
        
        }
    }
    var _foodCell: JMSNSInputCell?
    func foodCell() -> JMSNSInputCell {
        if _foodCell == nil {
            _foodCell = Bundle.main.loadNibNamed("JMSNSInputCell", owner: nil)?.first as? JMSNSInputCell
            _foodCell?.textView?.text = JMSOwnerUser.owner().name ?? ""
            _foodCell?.textView?.placeholder = "Любимое блюдо"
            _foodCell?.textChangedBlock = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                self?.updateDoneButton()
            }
        }
        
        return _foodCell!
    }
    var _ageCell: JMSNSInputCell?
    func ageCell() -> JMSNSInputCell {
        if _ageCell == nil {
            _ageCell = Bundle.main.loadNibNamed("JMSNSInputCell", owner: nil)?.first as? JMSNSInputCell
            _ageCell?.textView?.text = JMSOwnerUser.owner().name ?? ""
            _ageCell?.textView?.placeholder = "Ваш возраст"
            _ageCell?.textChangedBlock = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                self?.updateDoneButton()
            }
        }
        
        return _ageCell!
    }
    
    func noticeCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSNSNoticeCell") as! JMSNSNoticeCell
        cell.title?.text = "Здесь в нескольких полях ввода вводятся дополнительные сведения о вас"
        return cell
    }
    
    func updateDoneButton() {
        doneItem?.isEnabled = true
    }
    @IBAction func doneTapped() {
        JMSOwnerUser.owner().food = foodCell().textView?.text ?? ""
        let ageString = ageCell().textView?.text ?? ""
        
        if let ageNumber = Int(ageString) {
            JMSOwnerUser.owner().age = NSNumber(value:ageNumber)
            
        }
            
        
    
        DSCoreData.shared().saveContext()
        navigationController?.popViewController(animated: true)
    }
    
}
