//
//  JMSCurrencyViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 29.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSCurrencyCell : UITableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var subtitle: UILabel?
}

class JMSCurrencyViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var currencies = [JMSCurrency]()
    var currencySelectedBlock: ((JMSCurrency?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Валюта"
        currencies = JMSCurrency.mr_findAll() as! [JMSCurrency]
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSCurrencyCell") as! JMSCurrencyCell
        let currency = currencies[indexPath.row]
        cell.title?.text = currency.name
        cell.subtitle?.text = currency.symbol
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currencySelectedBlock?(currencies[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
}
