//
//  Notification+Utils.swift
//  SettingsExample
//
//  Created by Miwand Najafe on 2017-05-28.
//  Copyright © 2017 Miwand Najafe. All rights reserved.
//

import Foundation

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

enum Notifications: String, NotificationName {
    case viewActive
}
