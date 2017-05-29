//
//  AppConfig.swift
//  SettingsExample
//
//  Created by Miwand Najafe on 2017-05-28.
//  Copyright © 2017 Miwand Najafe. All rights reserved.
//

import Foundation

class AppConfig {
    
    static let shared = AppConfig()
    
    private init() {
        registerSettingsBundle()
        setMainBundle()
    }
    
    fileprivate let defaults = UserDefaults.standard
    fileprivate(set) var mainBundleDict: [String: Any]?
    
    
    /**
     Registers Bundle defaults from the Settings Bundle
     
     * Do not rename the Settings Bundle
     * If you delete all userDefaults then you will need to re-register the settings Bundle
     * Make sure that each Settings Bundle is targeting the correct Targets
     * Make sure that before putting custom settings that the top level contains a group
    */
    
    fileprivate func registerSettingsBundle() {
        guard let settingsBundle = Bundle.main.url(forResource: "Settings", withExtension:"bundle") else {
            NSLog("Could not find Settings.bundle")
            return;
        }
        
        guard let settings = NSDictionary(contentsOf: settingsBundle.appendingPathComponent("Root.plist")) else {
            NSLog("Could not find Root.plist in settings bundle")
            return
        }
        
        guard let preferences = settings.object(forKey: "PreferenceSpecifiers") as? [[String: AnyObject]] else {
            NSLog("Root.plist has invalid format")
            return
        }
        
        var defaultsToRegister = [String: AnyObject]()
        for var p in preferences {
            if let k = p["Key"] as? String, let v = p["DefaultValue"] {
                NSLog("%@", "registering \(v) for key \(k)")
                defaultsToRegister[k] = v
            }
        }
        
        defaults.register(defaults: defaultsToRegister)
    }
    
    /**
     Setting the App info from the infoPlist into the settings app
     * Double check the names for the keys in the settings Bundle
     * Make sure to synchronize defaults if the app exits suddenly in the app delegate
    */
    func setAppInfo() {
        guard let appVersion = mainBundleDict?[String(kCFBundleVersionKey)] as? String else { return }
        guard let appBuildNumber = mainBundleDict?["CFBundleShortVersionString"] as? String else { return }
        defaults.set(appVersion, forKey: "versionInfo")
        defaults.set(appBuildNumber, forKey: "buildNumber")
    }
    
    fileprivate func setMainBundle() {
        if mainBundleDict == nil {
            if let dict = Bundle.main.infoDictionary {
                mainBundleDict = dict
            }
        }
    }
    
    func getConfigType() -> ConfigType? {
        guard let appName = mainBundleDict?[String(kCFBundleNameKey)] as? String else { return  nil }
        switch appName {
        case "SettingsExample-QA":
            return .qa
        case "SettingsExample-Dev":
            return .dev
        default:
           return .prod
        }
    }
    
    enum ConfigType{ case prod, dev, qa}
}
