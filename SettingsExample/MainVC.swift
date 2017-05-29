//
//  MainVC.swift
//  SettingsExample
//
//  Created by Miwand Najafe on 2017-05-28.
//  Copyright © 2017 Miwand Najafe. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var boxViewOne: UIView!
    @IBOutlet weak var boxViewTwo: UIView!
    @IBOutlet weak var boxViewThree: UIView!
    @IBOutlet weak var boxViewFour: UIView!
    
    @IBOutlet var customLabels: [UILabel]!
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    fileprivate let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setUpView), name: Notifications.viewActive.name, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       NotificationCenter.default.removeObserver(self)
    }
    
    func setupLabels() {
        if let font = defaults.value(forKey: "fontChooser") as? String,
            let size = defaults.value(forKey: "fontSize") as? CGFloat {
            customLabels.forEach({
                $0.font = UIFont(name: font, size: size)
                $0.text = randomString(length: 1)
            })
        }
    }
    
    func changeNavTitle() {
        if let serverInfo = defaults.value(forKey: "serverConfig") as? String {
            self.navigationController?.navigationBar.topItem?.title = "Server: \(serverInfo)"
        }
    }
    
    func setUpView() {
        if let configType = AppConfig.shared.getConfigType() {
            switch configType {
            case .prod:
                setColourForBoxes()
            case .dev:
                changeNavTitle()
            case .qa:
                setupLabels()
            }
        }
    }
    
    fileprivate func setColourForBoxes() {
        let toggleForColours = defaults.bool(forKey: "themeSwitch")
        switch toggleForColours {
            case true:
                setDarkTheme()
            default:
                setLightTheme()
        }
    }
    
    fileprivate func setLightTheme() {
        boxViewOne.backgroundColor = UIColor.customOrange
        boxViewTwo.backgroundColor = UIColor.customTeal
        boxViewTwo.backgroundColor = UIColor.customYellow
        boxViewFour.backgroundColor = UIColor.customGreen
    }
    
    fileprivate func setDarkTheme() {
        boxViewOne.backgroundColor = UIColor.customBlack
        boxViewTwo.backgroundColor = UIColor.customBrown
        boxViewTwo.backgroundColor = UIColor.customPurple
        boxViewFour.backgroundColor = UIColor.customDGreen
    }
}
