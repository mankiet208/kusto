//
//  Logger.swift
//  Kusto
//
//  Created by kiettruong on 12/04/2021.
//

import Foundation

enum LogType: String{
    case error
    case warning
    case success
    case debug
}


struct Logger {
    
    static func log(_ logType: LogType, message: String) {
        #if DEBUG
        switch logType {
        case .error:
            print("\n🔥 Error: \(message)\n")
        case .warning:
            print("\n⚠️ Warning: \(message)\n")
        case .success:
            print("\n✅ Success: \(message)\n")
        case .debug:
            print("\nℹ️ Debug: \(message)\n")
        }
        #endif
    }
    
    static func error(_ message: String) {
        log(.error, message: message)
    }
    
    static func warning(_ message: String) {
        log(.warning, message: message)
    }
    
    static func success(_ message: String) {
        log(.success, message: message)
    }
    
    static func debug(_ message: String) {
        log(.debug, message: message)
    }
}
