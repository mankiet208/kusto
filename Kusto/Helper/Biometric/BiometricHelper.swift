//
//  BiometricHelper.swift
//  Kusto
//
//  Created by Kiet Truong on 21/03/2024.
//

import Foundation
import LocalAuthentication

class BiometricHelper {
        
    static var biometryType: LABiometryType {
        var error: NSError?
        let context = LAContext()

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        return context.biometryType
    }
    
    static var isEnrolled: Bool {
        return biometryType == .faceID || biometryType == .touchID
    }
}
