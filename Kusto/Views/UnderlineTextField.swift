//
//  UnderlineTextField.swift
//  Kusto
//
//  Created by Kiet Truong on 20/03/2024.
//

import UIKit

class UnderlinedTextField: UITextField {

    let underlineLayer = CALayer()
    
    var underlineColor: CGColor?

    // In `init?(coder:)` Add our underlineLayer as a sublayer of the view's main layer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.addSublayer(underlineLayer)
    }

    // in `init(frame:)` Add our underlineLayer as a sublayer of the view's main layer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(underlineLayer)
    }

    // Any time we are asked to update our subviews,
    // adjust the size and placement of the underline layer too
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUnderlineLayer()
    }
    
    /// Size the underline layer and position it as a one point line under the text field.
    func setupUnderlineLayer() {
        var frame = self.bounds
        frame.origin.y = frame.size.height - 1
        frame.size.height = 1

        underlineLayer.frame = frame
        underlineLayer.backgroundColor = underlineColor
    }
}
