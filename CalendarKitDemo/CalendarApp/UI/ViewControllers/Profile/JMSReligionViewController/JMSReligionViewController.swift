//
//  JMSReligionViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 30.09.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSReligionViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneItem: UIBarButtonItem?
    enum Cells:Int {
        case notice, religion
    }
    let cells = [Cells.notice, .religion]
    override func viewDidLoad() {
        title = "Религиозные предпочтения"
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
        case .religion:
            return religionCell()
        
        }
    }
    var _religionCell: JMSNSInputCell?
    func religionCell() -> JMSNSInputCell {
        if _religionCell == nil {
            _religionCell = Bundle.main.loadNibNamed("JMSNSInputCell", owner: nil)?.first as? JMSNSInputCell
            _religionCell?.textView?.text = JMSOwnerUser.owner().name ?? ""
            _religionCell?.textView?.placeholder = "Ваша религия"
            _religionCell?.textChangedBlock = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                self?.updateDoneButton()
            }
        }
        
        return _religionCell!
    }
    func noticeCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSNSNoticeCell") as! JMSNSNoticeCell
        cell.title?.text = "Ваши религиозные предпочтения"
        return cell
    }
    
    func updateDoneButton() {
        doneItem?.isEnabled = true
    }
    @IBAction func doneTapped() {
        JMSOwnerUser.owner().religion = religionCell().textView?.text ?? ""
        DSCoreData.shared().saveContext()
        navigationController?.popViewController(animated: true)
    }
}
