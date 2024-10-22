//
//  JMSServiceViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 21.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation
class JMSSCell : UITableViewCell {
    @IBOutlet var title: UILabel?
}

class JMSServiceViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var services = [JMSService]()
    var serviceSelectedBlock: ((JMSService?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Услуги"
        services = JMSService.mr_findAll() as! [JMSService]
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSSCell") as! JMSSCell
        let service = services[indexPath.row]
        cell.title?.text = service.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        serviceSelectedBlock?(services[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
}


