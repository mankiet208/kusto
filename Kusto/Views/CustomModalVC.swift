//
//  CustomModal.swift
//  Kusto
//
//  Created by Kiet Truong on 26/03/2024.
//

import UIKit

class CustomModalVC: UIViewController {
    
    //MARK: - UI
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Info"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = theme.text
        return label
    }()

    lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = theme.text
        return label
    }()
    
    lazy var formatLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = theme.text
        return label
    }()

    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, sizeLabel, formatLabel, spacer]
        )
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
    
    lazy private var dragButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "line.3.horizontal", withConfiguration: imageConfig), for: .normal)
        button.imageView?.tintColor = theme.onBackground
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = false
        return button
    }()
    
    //MARK: - PROPS
    
    private let defaultHeight: CGFloat = 300
    private let maxDimmedAlpha: CGFloat = 0.6
    private let dismissibleHeight: CGFloat = 200
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = 300
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    private var info: Info!
    
    public var dismissOnTapOutside: Bool = true
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupPanGesture()
        setupTapOutsideGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    //MARK: - SETUP
    
    private func setupView() {
        view.backgroundColor = .clear
        containerView.backgroundColor = isDarkMode ? UIColor.gray900 : theme.background
    }
    
    private func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(dragButton)
        
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        dragButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //
            dragButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dragButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20)
        ])
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
           
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        // Setup content
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    private func setupTapOutsideGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOutsideGesture(gesture:)))
        tapGesture.delaysTouchesBegan = false
        tapGesture.delaysTouchesEnded = false
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    func setupData(photo: Photo) {
        self.info = Info(photo: photo)
        
        sizeLabel.text = "Size: \(info.size) KB"
        formatLabel.text = "Format: \(info.format)"
    }
    
    //MARK: - FUNCTION

    func animatePresentContainer() {
        // Update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    //MARK: - ACTION
    
    @objc func handleTapOutsideGesture(gesture: UITapGestureRecognizer) {
        if dismissOnTapOutside {
            animateDismissView()
        }
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")

        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")

        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y

        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container

            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
}

