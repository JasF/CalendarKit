//
//  JMSSettingsSelectColorViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 13.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation

class JMSSSCCell : UITableViewCell {
    @IBOutlet var title: UILabel?
}

class JMSSettingsSelectColorViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var colors = [JMSColor]()
    var colorSelectedBlock: ((JMSColor?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Цвет шрифта"
        colors = JMSColor.mr_findAll() as! [JMSColor]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSSCCell") as! JMSSSCCell
        let color = colors[indexPath.row]
        cell.title?.text = color.name
        cell.title?.textColor = UIColor(hexString: color.color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        colorSelectedBlock?(colors[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
