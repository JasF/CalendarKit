//
//  JMSClientsViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 22.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSCCell : UITableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var phone: UILabel?
}
class JMSCAddCell : UITableViewCell {
    @IBOutlet var addClient: UILabel?
}

class JMSClientsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    enum CellType {
        case info, add
    }
    class Cell {
        init(_ type: CellType) {
            self.type = type
        }
        var type = CellType.info
        var client: JMSClient?
    }
    var cells = [Cell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Клиенты"
        let clients = JMSClient.mr_findAll() as! [JMSClient]
        for client in clients {
            let clientCell = Cell(.info)
            clientCell.client = client
            cells.append(clientCell)
            
        }
        let cell = Cell(.add)
        cells.append(cell)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = cells[indexPath.row]
        switch cellInfo.type {
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JMSCCell") as! JMSCCell
            cell.title?.text = "\(cellInfo.client?.name ?? "") \(cellInfo.client?.surname ?? "")"
            cell.phone?.text = cellInfo.client?.phone
            
            return cell
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JMSCAddCell") as! JMSCAddCell
            cell.addClient?.text = "+ Добавить клиента"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
