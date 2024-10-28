//
//  JMSTransportViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 15.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSTAddCell : UITableViewCell {
    @IBOutlet var add: UILabel?
}
class JMSTCell : UITableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var speed: UILabel?
}

class JMSTransportViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    //var transports = [JMSTransport]()
    enum CellType:Int {
        case info, add, delete, itogo
    }
    class Cell {
        init(transport: JMSTransport) {
            self.transport = transport
        }
        init(type: CellType) {
            self.type = type
        }
        init(count: Int) {
            self.count = count
            type = .itogo
        }
        var type = CellType.info
        var transport: JMSTransport?
        var count = 0
    }
    var cells = [Cell]()
    var transportSelectedBlock: ((JMSTransport?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Транспорт"
        let transports = JMSTransport.mr_findAll() as! [JMSTransport]
        cells.append(contentsOf: transports.map({ it in
            Cell(transport: it)
        }))
        cells.append(Cell(type: .add))
        cells.append(Cell(type: .delete))
        cells.append(Cell(count: transports.count))
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = cells[indexPath.row]
        switch info.type {
        case .info:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "JMSTCell") as! JMSTCell
            cell.title?.text = info.transport?.name ?? ""
            cell.speed?.text = "Скорость: \(info.transport?.speed?.intValue ?? 0) км/ч"
            
            return cell
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JMSTAddCell") as! JMSTAddCell
            cell.add?.text = "+ Добавить транспорт"
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = cells[indexPath.row]
        transportSelectedBlock?(info.transport)
        navigationController?.popViewController(animated: true)
    }
    
}

