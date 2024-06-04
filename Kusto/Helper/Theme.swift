//
//  Theme.swift
//  Kusto
//
//  Created by Kiet Truong on 18/03/2024.
//

import UIKit

enum Theme: String {
    case light, dark
    
    var primary: UIColor {
        switch self {
        case .light:
            return UIColor.primary
        case .dark:
            return UIColor.primary
        }
    }
    
    var background: UIColor {
        switch self {
        case .light:
            return UIColor.gray100
        case .dark:
            return UIColor.gray950
        }
    }
    
    var onBackground: UIColor {
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    var text: UIColor {
        switch self {
        case .light:
            return UIColor.gray900
        case .dark:
            return UIColor.white
        }
    }
    
    var surface: UIColor {
        switch self {
        case .light:
            return UIColor.gray200
        case .dark:
            return UIColor.gray900
        }
    }
    
    var barTint: UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.gray975
        }
    }
}
