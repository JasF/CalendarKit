//
//  JMSServiceViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 21.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSSAddCell : UITableViewCell {
    @IBOutlet var add: UILabel?
}
class JMSSCell : UITableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var subtitle: UILabel?
}
class JMSSDelCell : UITableViewCell {
    @IBOutlet var button: UIButton?
    
    var buttonTappedBlock: (()->Void)?
    @IBAction func buttonTapped() {
        buttonTappedBlock?()
    }
}
class JMSSSumCell: UITableViewCell {
    @IBOutlet var sum: UILabel?
}

class JMSServiceViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var services = [JMSService]()
    var serviceSelectedBlock: ((JMSService?) -> Void)?
    enum CellType:Int {
        case service, add, sumType, delete
    }
    class Cell {
        init(service: JMSService) {
            self.service = service
        }
        init(type: CellType) {
            self.type = type
        }
        init(sumValue: Double) {
            
            self.sumValue = sumValue
            type = .sumType
        }
        var service: JMSService?
        var type = CellType.service
        var sumValue = 0.0
    }
    var cells = [Cell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Услуги"
        services = JMSService.mr_findAll() as! [JMSService]
        updateCells()
    }
    
    func updateCells() {
        cells.removeAll()
        cells.append(contentsOf: services.map({ it in
            Cell(service: it)
        }))
        cells.append(Cell(type: .add))
        cells.append(Cell(type: .delete))
        var result = 0.0
        for service in services {
            result += service.price?.doubleValue ?? 0.0
        }
        cells.append(Cell(sumValue: result))
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
        case .service:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSCell") as! JMSSCell
            let service = info.service!
            cell.title?.text = service.name
            cell.subtitle?.text = "Цена: \(service.price.asPrice())"
            return cell
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSAddCell") as! JMSSAddCell
            cell.add?.text = "+ Добавить услугу"
            return cell
        case .delete:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSDelCell") as! JMSSDelCell
            cell.button?.setTitle("Удалить первую услугу", for: .normal)
            cell.buttonTappedBlock = { [weak self] in
                if (self?.services.isEmpty ?? true) == false {
                    self?.services.remove(at: 0)
                    
                }
                self?.updateCells()
                
                self?.tableView.reloadData()
            }
            return cell
        case .sumType:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSSumCell") as! JMSSSumCell
            cell.sum?.text = "Сумма цен: \(NSNumber(value:info.sumValue).asPrice())"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


extension NSNumber {
    func asPrice() -> String {
        let currencyId = JMSOwnerUser.owner().currencyId ?? ""
        var currency: JMSCurrency?
        if currencyId.isEmpty == false {
            currency = JMSCurrency.jms_findSingle(with: NSPredicate(format: "uid == %@", currencyId as NSString)) as? JMSCurrency
            
        }
        let currencySym = currency?.symbol ?? ""
        return "\(self.intValue) \(currencySym)"
    }
}
