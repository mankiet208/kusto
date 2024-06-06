//
//  UIColor+Extension.swift
//  Kusto
//
//  Created by Kiet Truong on 3/5/21.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    //MARK: - CUSTOM COLOR
    
    static var primary: UIColor {
        return UIColor(hexString: "#DEC584")
    }
    
    static var gray50: UIColor {
        return UIColor(hexString: "#FAFAFA")
    }
    
    static var gray100: UIColor {
        return UIColor(hexString: "#F5F5F5")
    }
    
    static var gray200: UIColor {
        return UIColor(hexString: "#EEEEEE")
    }
    
    static var gray300: UIColor {
        return UIColor(hexString: "#E0E0E0")
    }
    
    static var gray400: UIColor {
        return UIColor(hexString: "#BDBDBD")
    }
    
    static var gray500: UIColor {
        return UIColor(hexString: "#9E9E9E")
    }
    
    static var gray600: UIColor {
        return UIColor(hexString: "#959595")
    }
    
    static var gray700: UIColor {
        return UIColor(hexString: "#616161")
    }
        
    static var gray800: UIColor {
        return UIColor(hexString: "#5D5D5D")
    }
    
    static var gray900: UIColor {
        return UIColor(hexString: "#333333")
    }
    
    static var gray950: UIColor {
        return UIColor(hexString: "#1e1e1e")
    }
    
    static var gray975: UIColor {
        return UIColor(hexString: "#121212")
    }
}
