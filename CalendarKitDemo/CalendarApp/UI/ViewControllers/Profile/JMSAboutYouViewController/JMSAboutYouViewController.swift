//
//  JMSAboutYouViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 16.08.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation

class JMSAYNoticeCell : UITableViewCell {
    @IBOutlet var title: UILabel?
}

class JMSAboutYouViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneItem: UIBarButtonItem?
    enum Cells:Int {
        case notice, aboutyou
    }
    let cells = [Cells.notice, .aboutyou]
    override func viewDidLoad() {
        title = "Подробнее о вас"
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
        case .aboutyou:
            return aboutyouCell()
        
        }
    }
    var _aboutyouCell: JMSNSInputCell?
    func aboutyouCell() -> JMSNSInputCell {
        if _aboutyouCell == nil {
            _aboutyouCell = Bundle.main.loadNibNamed("JMSNSInputCell", owner: nil)?.first as? JMSNSInputCell
            _aboutyouCell?.textView?.text = JMSOwnerUser.owner().about_you ?? ""
            _aboutyouCell?.textView?.placeholder = "Укажите ваши увлечения"
            _aboutyouCell?.textChangedBlock = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                self?.updateDoneButton()
            }
        }
        
        return _aboutyouCell!
    }
    
    func noticeCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSAYNoticeCell") as! JMSAYNoticeCell
        cell.title?.text = "Более подробная информация о вас"
        return cell
    }
    @IBAction func doneTapped() {
        JMSOwnerUser.owner().about_you = aboutyouCell().textView?.text ?? ""
        DSCoreData.shared().saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func updateDoneButton() {
        doneItem?.isEnabled = true
    }
    
    
}

