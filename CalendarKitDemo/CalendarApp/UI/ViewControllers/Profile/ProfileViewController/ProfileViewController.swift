//
//  ProfileViewController.swift
//  CalendarApp
//
//  Created by Андрей Воевода on 16.08.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

import Foundation

class JMSPHeaderCell : UITableViewCell {
    @IBOutlet var container: UIView?
}

class JMSPTitleSubtitleCell : UITableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var subtitle: UILabel?
}


class JMSPSubCell : UITableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var subtitle: UILabel?
    @IBOutlet var subtitle2: UILabel?
    
}
class ProfileViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum Cells:Int {
        case header, namesurname, aboutyou, religion, itogo
    }
    let cells = [Cells.header, .namesurname,.aboutyou, .religion, .itogo]
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .header:
            return tableView.dequeueReusableCell(withIdentifier: "JMSPHeaderCell")!
        case .namesurname:
            return nameSurnameCell()
        case .aboutyou:
            return aboutYouCell()
        case .religion:
            return religionCell()
        case .itogo:
            return itogoCell()
            
            
            
        
            
        }
    }
    
    func nameSurnameCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSPTitleSubtitleCell") as! JMSPTitleSubtitleCell
        cell.title?.text = "Имя и фамилия"
        let owner = JMSOwnerUser.owner()!
        let name = owner.name ?? ""
        let surname = owner.surname ?? ""
        var myName = ""
        if name.isEmpty == false && surname.isEmpty == false {
            myName = "\(name) \(surname)"
        }
        else if name.isEmpty == false {
            myName = name
        }
        else if surname.isEmpty == false {
            myName = surname
        }
        var subtitle = "Укажите имя и фамилию"
        if myName.isEmpty == false {
            subtitle = "Ваше имя: \(myName)"
        }
        cell.subtitle?.text = subtitle
        return cell
    }
    func aboutYouCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSPTitleSubtitleCell") as! JMSPTitleSubtitleCell
        cell.title?.text = "Подробнее о вас"
        let owner = JMSOwnerUser.owner()!
        var subtitle = "Увлечения"
        let aboutYou = owner.about_you ?? ""
        if aboutYou.isEmpty == false {
            subtitle = "Ваши увлечения: \(aboutYou)"
        }
        cell.subtitle?.text = subtitle
        
        return cell
        
        
    }
    func religionCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSPTitleSubtitleCell") as! JMSPTitleSubtitleCell
        cell.title?.text = "Религиозные предпочтения"
        let owner = JMSOwnerUser.owner()!
        var subtitle = "Укажите вашу религию"
        let religion = owner.religion ?? ""
        if religion.isEmpty == false {
            subtitle = "Ваша религия: \(religion)"
        }
        cell.subtitle?.text = subtitle
        
        return cell
        
        
    }
    func itogoCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JMSPSubCell") as! JMSPSubCell
        cell.title?.text = "Итоговая ячейка"
        let owner = JMSOwnerUser.owner()!
        var subtitle = "Укажите любимое блюдо"
        let bliudo = owner.bliudo ?? ""
        if bliudo.isEmpty == false {
            subtitle = "Любимое блюдо: \(bliudo)"
        }
        cell.subtitle?.text = subtitle
        var subtitle2 = "Укажите ваш возраст"
        let age = owner.age ?? NSNumber(0)
        subtitle2 = "Вам лет: \(age.stringValue)"
        cell.subtitle2?.text = subtitle2
        return cell
        
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch cells[indexPath.row] {
        case .namesurname:
            showNameSurnameViewController()
            break
        case .aboutyou:
            showAboutYouViewController()
        case .religion:
            showReligionViewController()
        case .itogo:
            showItogoViewController()
            
        default:
            break
        }
    }
    
    
    func showNameSurnameViewController() {
        let storyboard = UIStoryboard(name: "JMSNameSurnameViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! JMSNameSurnameViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    func showAboutYouViewController() {
        let storyboard = UIStoryboard(name: "JMSAboutYouViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! JMSAboutYouViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    func showReligionViewController() {
        let storyboard = UIStoryboard(name: "JMSReligionViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! JMSReligionViewController
        navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    func showItogoViewController() {
        let storyboard = UIStoryboard(name: "JMSItogoViewController", bundle: nil)
        //let viewController = storyboard.instantiateInitialViewController()! as! JMSItogoViewController
        //navigationController?.pushViewController(viewController, animated: true)
        
    }
}
