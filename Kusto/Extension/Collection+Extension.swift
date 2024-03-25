//
//  Collection+Extension.swift
//  Kusto
//
//  Created by Kiet Truong on 25/03/2024.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    /// - Parameters:
    ///   - Parameter index: The index of the item to get safely the element
    /// - Returns: The element if available or nil otherwise
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
