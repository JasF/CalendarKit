//
//  JMSTransportViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 15.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSTCell : UITableViewCell {
    @IBOutlet var title: UILabel?
}

class JMSTransportViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var transports = [JMSTransport]()
    var transportSelectedBlock: ((JMSTransport?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Транспорт"
        transports = JMSTransport.mr_findAll() as! [JMSTransport]
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSTCell") as! JMSTCell
        let transport = transports[indexPath.row]
        cell.title?.text = transport.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transportSelectedBlock?(transports[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
}

