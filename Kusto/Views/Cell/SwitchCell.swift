//
//  SwitchCell.swift
//  Kusto
//
//  Created by Kiet Truong on 19/04/2024.
//

import UIKit

protocol SwitchCellDelegate: AnyObject {
    func toggle(for cell: SwitchCell, tag: Int, value: Bool)
}

class SwitchCell: UITableViewCell {
    
    static var identifider = "SwitchCell";
        
    lazy private var switchView: UISwitch = {
        let switchView = UISwitch(frame: .zero)
        switchView.addTarget(self,
                             action: #selector(switchChanged),
                             for: .valueChanged)
        switchView.onTintColor = .primary
        return switchView
    }()
    
    weak var delegate: SwitchCellDelegate?
    
    var value: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryView = switchView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(isOn: Bool, isSwitchEnabled: Bool = false, tag: Int?) {
        value = isOn
        
        switchView.setOn(value, animated: false)
        switchView.isUserInteractionEnabled = isSwitchEnabled
        
        if (tag != nil) {
            switchView.tag = tag!
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        delegate?.toggle(for: self, tag: mySwitch.tag, value: mySwitch.isOn)
    }
}
