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


class Logger {
    
    static func log(_ logType: LogType, _ message: String) {
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
    }
}
