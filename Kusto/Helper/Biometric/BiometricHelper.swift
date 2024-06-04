//
//  BiometricHelper.swift
//  Kusto
//
//  Created by Kiet Truong on 21/03/2024.
//

import Foundation
import LocalAuthentication

class BiometricHelper {
    
    static func show(onSuccess: (() -> Void)?, onError: ((String?) -> Void)?) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                success, authError in
                
                DispatchQueue.main.async {
                    if success {
                        onSuccess?()
                    } else {
                        onError?(authError?.localizedDescription)
                    }
                }
            }
        } else {
            // no biometry
            if let error = error {
                onError?(error.localizedDescription)
            }
        }
    }
        
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
