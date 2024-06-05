//
//  ThemeVC.swift
//  Kusto
//
//  Created by Kiet Truong on 04/06/2024.
//

import UIKit

enum ThemeMode: Codable {
    case light, dark, system
}

extension ThemeMode {
    
    var title: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .system:
            return "System"
        }
    }
}

class ThemeVC: BaseVC {
    
    //MARK: - UI
    
    lazy private var stkThemeSelector: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - PROPS
    
    var modeHeight: CGFloat {
        return view.frame.height / 4
    }
    
    var modeWidth: CGFloat {
        return modeHeight * 9 / 16 - 20
    }
    
    var tapGesture: UITapGestureRecognizer {
        get {
            return UITapGestureRecognizer(target: self, action: #selector(self.onTapMode(_:)))
        }
    }
    
    var modeUIs: [UIView] = []
    
    var selectedMode: ThemeMode? = nil
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedMode = UserDefaultsStore.themeMode
        
        view.backgroundColor = theme.background
        
        setupView()
    }
    
    //MARK: - CONFIG
    
    private func setupView() {
        title = "Theme"
        
        // Setup views
        
        let lightMode = createLightDarkMode(theme: .light)
        let darkMode = createLightDarkMode(theme: .dark)
        let systemMode = createSystemMode()
        
        let lightModeWrapper = createMode(content: lightMode, mode: .light)
        let darkModeWrapper = createMode(content: darkMode, mode: .dark)
        let systemModeWrapper = createMode(content: systemMode, mode: .system)
        
        stkThemeSelector.addArrangedSubview(lightModeWrapper)
        stkThemeSelector.addArrangedSubview(darkModeWrapper)
        stkThemeSelector.addArrangedSubview(systemModeWrapper)
        
        modeUIs = [lightMode, darkMode, systemMode]
        
        view.addSubview(stkThemeSelector)
        
        NSLayoutConstraint.activate([
            stkThemeSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stkThemeSelector.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stkThemeSelector.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            stkThemeSelector.heightAnchor.constraint(equalToConstant: modeHeight)
        ])
        
        // Add gestures
        
        lightMode.addGestureRecognizer(tapGesture)
        lightMode.tag = 0
        
        darkMode.addGestureRecognizer(tapGesture)
        darkMode.tag = 1
        
        systemMode.addGestureRecognizer(tapGesture)
        systemMode.tag = 2
    }
    
    //MARK: - FUNCTION
    
    private func createMode(content: UIView, mode: ThemeMode) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = mode.title
        
        stack.addArrangedSubview(content)
        stack.addArrangedSubview(label)
        
        let isSelectedMode =  selectedMode == mode
        content.layer.borderColor = isSelectedMode ? theme.primary.cgColor : theme.onBackground.cgColor
        content.layer.borderWidth = isSelectedMode ? 5 : 1
        
        return stack
    }
    
    private func createLightDarkMode(theme: Theme) -> UIView {
        let container = UIView()
        container.backgroundColor = theme.background
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: theme == .light ? "sun.max.fill" : "moon.fill")
        imageView.tintColor = theme.onBackground
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: modeWidth),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            imageView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        return container
    }
    
    private func createSystemMode() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.layer.cornerRadius = 16
        stack.layer.masksToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let lightView = UIView()
        lightView.backgroundColor = Theme.light.background
        
        let darkView = UIView()
        darkView.backgroundColor = Theme.dark.background
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName:  theme == .light ? "circle.righthalf.filled" : "circle.lefthalf.filled")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = theme.background
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(lightView)
        stack.addArrangedSubview(darkView)
        stack.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant: modeWidth),
            imageView.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        return stack
    }
    
    private func refreshView(selectedMode: UIView) {
        for mode in modeUIs {
            mode.layer.borderColor = theme.onBackground.cgColor
            mode.layer.borderWidth = 1
        }
        
        UIView.animate(withDuration: 0.5) {
            selectedMode.layer.borderColor = self.theme.primary.cgColor
            selectedMode.layer.borderWidth = 5
            self.view.backgroundColor = self.theme.background
        }
        
//        UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        
    }
    
    //MARK: - GESTURE

    @objc func onTapMode(_ sender: UITapGestureRecognizer) {
        let view: UIView = sender.view!
            
        switch (view.tag) {
        case 0:
            selectedMode = .light
        case 1:
            selectedMode = .dark
        case 2:
            selectedMode = .system
        default: ()
        }
                
        UserDefaultsStore.themeMode = selectedMode ?? .system
                
        refreshView(selectedMode: view)
    }
    
}
