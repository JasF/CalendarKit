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
    @IBOutlet var fourthCounterLabel: UILabel?
    
    @IBOutlet var increaseFirstButton: UIButton?
    @IBOutlet var decreaseFirstButton: UIButton?
    @IBOutlet var increaseSecondButton: UIButton?
    @IBOutlet var decreaseSecondButton: UIButton?
    @IBOutlet var increaseThirdButton: UIButton?
    @IBOutlet var decreaseThirdButton: UIButton?
    @IBOutlet var increaseFourthButton: UIButton?
    @IBOutlet var decreaseFourthButton: UIButton?
    
    
    var firstCounter = 0
    var secondCounter = 0
    var thirdCounter = 0
    var fourthCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Счетчики"
        firstCounter = JMSOwnerUser.owner().first_counter?.intValue ?? 0
        secondCounter = JMSOwnerUser.owner().second_counter?.intValue ?? 0
        thirdCounter = JMSOwnerUser.owner().third_counter?.intValue ?? 0
        fourthCounter = JMSOwnerUser.owner().fourth_counter?.intValue ?? 0
        increaseFirstButton?.layer.cornerRadius = 17.0
        updateFirstCounterText()
        updateSecondCounterText()
        updateThirdCounterText()
        updateFourthCounterText()
        decreaseFirstButton?.layer.cornerRadius = 17.0
        increaseSecondButton?.layer.cornerRadius = 17.0
        decreaseSecondButton?.layer.cornerRadius = 17.0
        increaseThirdButton?.layer.cornerRadius = 17.0
        decreaseThirdButton?.layer.cornerRadius = 17.0
        increaseFourthButton?.layer.cornerRadius = 17.0
        decreaseFourthButton?.layer.cornerRadius = 17.0
        
        
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
        JMSOwnerUser.owner().second_counter = secondCounter as NSNumber
        DSCoreData.shared().saveContext()
        updateSecondCounterText()
        
    }
    @IBAction func decreaseSecondButtonTapped() {
        secondCounter = secondCounter - 1
        JMSOwnerUser.owner().second_counter = secondCounter as NSNumber
        DSCoreData.shared().saveContext()
        updateSecondCounterText()
    }
    @IBAction func increaseThirdButtonTapped() {
        thirdCounter = thirdCounter + 1
        JMSOwnerUser.owner().third_counter = thirdCounter as NSNumber
        DSCoreData.shared().saveContext()
        updateThirdCounterText()
    }
    @IBAction func decreaseThirdButtonTapped() {
        thirdCounter = thirdCounter - 1
        JMSOwnerUser.owner().third_counter = thirdCounter as NSNumber
        DSCoreData.shared().saveContext()
        updateThirdCounterText()
    }
    @IBAction func increaseFourthButtonTapped() {
        fourthCounter = fourthCounter + 1
        JMSOwnerUser.owner().fourth_counter = fourthCounter as NSNumber
        DSCoreData.shared().saveContext()
        updateFourthCounterText()
    }
    @IBAction func decreaseFourthButtonTapped() {
        fourthCounter = fourthCounter - 1
        JMSOwnerUser.owner().fourth_counter = fourthCounter as NSNumber
        DSCoreData.shared().saveContext()
        updateFourthCounterText()
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
    func updateFourthCounterText() {
        fourthCounterLabel?.text = "Четвертый счетчик: \(fourthCounter)"
    }
    
    
}
