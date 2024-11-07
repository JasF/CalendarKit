//
//  JMSTransportEditViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 7.11.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSTransportEditViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneItem: UIBarButtonItem?
    enum Cells:Int {
        case name, delete
    }
    var uid = ""
    let cells = [Cells.name, .delete]
    override func viewDidLoad() {
        title = "Редактирование транспорта"
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
        case .name:
            return nameCell()
        case .delete:
            return UITableViewCell()
        
        }
    }
    var _nameCell: JMSNSInputCell?
    func nameCell() -> JMSNSInputCell {
        if _nameCell == nil {
            _nameCell = Bundle.main.loadNibNamed("JMSNSInputCell", owner: nil)?.first as? JMSNSInputCell
            _nameCell?.textView?.text = ""
            _nameCell?.textView?.placeholder = "Название"
            _nameCell?.textChangedBlock = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                self?.updateDoneButton()
            }
        }
        
        return _nameCell!
    }
    
    
    func updateDoneButton() {
        doneItem?.isEnabled = true
    }
    @IBAction func doneTapped() {
        
        DSCoreData.shared().saveContext()
        navigationController?.popViewController(animated: true)
    }
}
