//
//  JMSReligionViewController.swift
//  CalendarApp
//
//  Created by Юлия Лейбгам on 17.08.24.
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
    func updateDoneButton() {
        doneItem?.isEnabled = true
    }

}

