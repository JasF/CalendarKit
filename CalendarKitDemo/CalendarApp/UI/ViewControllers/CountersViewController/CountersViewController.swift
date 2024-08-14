//
//  CountersViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 13.08.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import UIKit

class CountersViewController : UIViewController {
    @IBOutlet var firstCounterLabel: UILabel?
    @IBOutlet var secondCounterLabel: UILabel?
    @IBOutlet var thirdCounterLabel: UILabel?
    @IBOutlet var increaseFirstButton: UIButton?
    @IBOutlet var decreaseFirstButton: UIButton?
    @IBOutlet var increaseSecondButton: UIButton?
    @IBOutlet var decreaseSecondButton: UIButton?
    @IBOutlet var increaseThirdButton: UIButton?
    @IBOutlet var decreaseThirdButton: UIButton?
    
    var firstCounter = 0
    var secondCounter = 0
    var thirdCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Счетчики"
        firstCounter = JMSOwnerUser.owner().first_counter?.intValue ?? 0
        increaseFirstButton?.layer.cornerRadius = 17.0
        updateFirstCounterText()
        updateSecondCounterText()
        updateThirdCounterText()
        decreaseFirstButton?.layer.cornerRadius = 17.0
        increaseSecondButton?.layer.cornerRadius = 17.0
        decreaseSecondButton?.layer.cornerRadius = 17.0
        increaseThirdButton?.layer.cornerRadius = 17.0
        decreaseThirdButton?.layer.cornerRadius = 17.0
        
    }
    
    @IBAction func increaseFirstButtonTapped() {
        firstCounter = firstCounter + 1
        JMSOwnerUser.owner().first_counter = firstCounter as NSNumber
        DSCoreData.shared().saveContext()
        updateFirstCounterText()
    }
    @IBAction func decreaseFirstCounterTapped() {
        firstCounter = firstCounter - 1
        JMSOwnerUser.owner().first_counter = firstCounter as NSNumber
        DSCoreData.shared().saveContext()
        updateFirstCounterText()
        
    }
    @IBAction func increaseSecondButtonTapped() {
        secondCounter = secondCounter + 1
        updateSecondCounterText()
        
    }
    @IBAction func decreaseSecondButtonTapped() {
        secondCounter = secondCounter - 1
        updateSecondCounterText()
    }
    @IBAction func increaseThirdButtonTapped() {
        thirdCounter = thirdCounter + 1
        updateThirdCounterText()
    }
    
    func updateFirstCounterText() {
        firstCounterLabel?.text = "Первый счетчик: \(firstCounter)"
    }
    func updateSecondCounterText() {
        secondCounterLabel?.text = "Второй счетчик: \(secondCounter)"
    }
    func updateThirdCounterText() {
        thirdCounterLabel?.text = "Третий счетчик: \(thirdCounter)"
    }
    
    
}
