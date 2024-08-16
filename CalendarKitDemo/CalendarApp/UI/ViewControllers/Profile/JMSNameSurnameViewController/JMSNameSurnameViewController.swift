//
//  JMSNameSurnameViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 16.08.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
import UITextView_Placeholder

class JMSNSNoticeCell : UITableViewCell {
    @IBOutlet var title: UILabel?
}

class JMSNSInputCell : UITableViewCell, UITextViewDelegate {
    @IBOutlet var textView: UITextView?
    var textChangedBlock: (()->Void)?
    func textViewDidChange(_ textView: UITextView) {
        textChangedBlock?()
    }
}

class JMSNameSurnameViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneItem: UIBarButtonItem?
    enum Cells:Int {
        case notice, name, surname
    }
    let cells = [Cells.notice, .name, .surname]
    
    override func viewDidLoad() {
        title = "Имя и фамилия"
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
        case .name:
            return nameCell()
        case .surname:
            return surnameCell()
        }
    }
    
    var _nameCell: JMSNSInputCell?
    func nameCell() -> JMSNSInputCell {
        if _nameCell == nil {
            _nameCell = Bundle.main.loadNibNamed("JMSNSInputCell", owner: nil)?.first as? JMSNSInputCell
            _nameCell?.textView?.text = JMSOwnerUser.owner().name ?? ""
            _nameCell?.textView?.placeholder = "Имя"
            _nameCell?.textChangedBlock = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                self?.updateDoneButton()
            }
        }
        
        return _nameCell!
    }
    
    var _surnameCell: JMSNSInputCell?
    func surnameCell() -> JMSNSInputCell {
        if _surnameCell == nil {
            _surnameCell = Bundle.main.loadNibNamed("JMSNSInputCell", owner: nil)?.first as? JMSNSInputCell
            _surnameCell?.textView?.text = JMSOwnerUser.owner().surname ?? ""
            _surnameCell?.textView?.placeholder = "Фамилия"
            _surnameCell?.textChangedBlock = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                self?.updateDoneButton()
            }
        }
        
        return _surnameCell!
    }
    
    func noticeCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSNSNoticeCell") as! JMSNSNoticeCell
        cell.title?.text = "Здесь вы можете указать имя и фамилию"
        return cell
    }
    
    @IBAction func doneTapped() {
        JMSOwnerUser.owner().name = nameCell().textView?.text ?? ""
        JMSOwnerUser.owner().surname = surnameCell().textView?.text ?? ""
        DSCoreData.shared().saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func updateDoneButton() {
        doneItem?.isEnabled = true
    }
}
