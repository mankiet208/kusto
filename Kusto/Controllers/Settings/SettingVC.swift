//
//  SettingVC.swift
//  Kusto
//
//  Created by Kiet Truong on 02/04/2024.
//

import UIKit

enum SettingItem {
    case theme
    case biometric
    case changePin
    case share
}

extension SettingItem {
    
    var text: String {
        switch self {
        case .theme:
            return "Theme"
        case .biometric:
            return "Biometric"
        case .changePin:
            return "Change Pin code"
        case .share:
            return "Share app"
            
        }
    }
    
    var icon: String {
        switch self {
        case .theme:
            return "moon.stars.fill"
        case .biometric:
            return "faceid"
        case .changePin:
            return "lock.fill"
        case .share:
            return "square.and.arrow.up.fill"
            
        }
    }
}

class SettingVC: BaseVC {
    
    //MARK: - UI
    
    lazy private var tbvSettings: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.separatorColor = theme.surface
        table.backgroundColor = theme.background
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    lazy private var lblFooter: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 40, height: 20)
        label.text = "Kusto version 1.0.0(1)"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    //MARK: - PROPS
    
    let settingItems: [SettingItem] = [
        .theme, .biometric, .changePin, .share
    ]
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - CONFIG
    
    private func setupView() {
        title = "Settings"
        
        view.addSubview(tbvSettings)
        tbvSettings.pinEdgesToSuperView(useSafeLayoutGuide: true)
        
        tbvSettings.tableFooterView = lblFooter
        tbvSettings.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tbvSettings.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.identifider)
        
        view.backgroundColor = theme.background
        tbvSettings.backgroundColor = theme.background
        
        setThemeColor()
    }
    
    public func setThemeColor() {
        view.backgroundColor = theme.background
        tbvSettings.backgroundColor = theme.background
        tbvSettings.separatorColor = .clear
        tbvSettings.reloadData()
    }
}

extension SettingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settingItems[indexPath.row]
        
        switch item {
        case .biometric:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifider,
                                                           for: indexPath) as? SwitchCell
            else {
                return UITableViewCell()
            }
            setupContent(cell, item: item)
            cell.selectedBackgroundView = UIView()
            cell.setup(isOn: UserDefaultsStore.isBiometricEnabled,
                       isSwitchEnabled: BiometricHelper.isEnrolled,
                       tag: indexPath.row)
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            setupContent(cell, item: item)
            cell.selectedBackgroundView = UIView()
            return cell
        }
    }
    
    private func setupContent(_ cell: UITableViewCell, item: SettingItem) {
        var content = cell.defaultContentConfiguration()
        
        // Configure content.
        content.prefersSideBySideTextAndSecondaryText = true
        content.image = UIImage(systemName: item.icon)
        content.imageProperties.tintColor = theme.onBackground
        content.text = item.text
        content.textProperties.color = theme.text
        
        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 17)
        content.secondaryTextProperties.color = .gray
        content.secondaryText = nil
        
        // Customize appearance.
        content.imageProperties.tintColor = theme.onBackground
        
        cell.contentConfiguration = content
        cell.backgroundColor = theme.background
        cell.accessoryType = .disclosureIndicator
    }
}

extension SettingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 20))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settingItems[indexPath.row]
        
        switch item {
        case .biometric:
            guard BiometricHelper.isEnrolled else {
                AlertView.showAlert(self,
                                    title: "Biometric is not enrolled",
                                    message: "Please enable your Face/Touch Id",
                                    actions: [])
                return
            }
        case .theme:
            let themeVC = ThemeVC()
            push(themeVC, hideBottomBar: true)
        default: ()
        }
    }
}

extension SettingVC: SwitchCellDelegate {
    
    func toggle(for cell: SwitchCell, tag: Int, value: Bool) {
        let item = settingItems[tag]
        
        switch item {
        case .biometric:
            guard BiometricHelper.isEnrolled else {
                return
            }
            UserDefaultsStore.isBiometricEnabled = value
        default: ()
        }
    }
}
