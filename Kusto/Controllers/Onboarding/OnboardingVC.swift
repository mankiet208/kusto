//
//  OnboardingVC.swift
//  Kusto
//
//  Created by Kiet Truong on 11/06/2024.
//

import UIKit

class OnboardingVC: BaseVC {
    
    private let NUMBER_OF_PAGES = 3
    
    //MARK: UI
    
    lazy private var pageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var bottomContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = NUMBER_OF_PAGES
        control.currentPage = 0
        control.pageIndicatorTintColor = .gray300
        control.currentPageIndicatorTintColor = theme.primary
        control.addTarget(self, action: #selector(pageControltapped(_:)), for: .touchUpInside)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
        
    lazy private var nextButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.background.backgroundColor = theme.primary
        config.image = UIImage(systemName: "chevron.right")

        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(onTapNext), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var starrtButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.title = "Get Started"
        config.baseForegroundColor = .white
        config.background.backgroundColor = theme.primary
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(onTapStart), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var pageControlVC: UIPageViewController!
    
    //MARK: PROPERTIES
    
    private let screenHeight = UIScreen.main.bounds.size.height
    
    private var pageControllers: [UIViewController] = []
    
    private var currentPage: Int = 0 {
        didSet {
            let isLastPage = currentPage == NUMBER_OF_PAGES - 1
            
            UIView.animate(withDuration: 0.4) {
                self.starrtButton.alpha = isLastPage ? 1 : 0
                self.nextButton.alpha = isLastPage ? 0 : 1
                self.pageControl.alpha = isLastPage ? 0 : 1
            } completion: { _ in
                self.nextButton.isUserInteractionEnabled = !isLastPage
                self.pageControl.isUserInteractionEnabled = !isLastPage
                self.starrtButton.isUserInteractionEnabled = isLastPage
            }
        }
    }
    
    //MARK: INIT

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        addPageControl()
        setupPages()
    }
    
    //MARK: PRIVATE
    
    private func setupView() {
        view.addSubview(pageViewContainer)
        view.addSubview(bottomContainer)
                
        NSLayoutConstraint.activate([
            pageViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewContainer.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor),
            //
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            bottomContainer.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        bottomContainer.addSubview(pageControl)
        bottomContainer.addSubview(nextButton)
        bottomContainer.addSubview(starrtButton)
                
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            //
            nextButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant:  -16),
            nextButton.widthAnchor.constraint(equalToConstant: 60),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            //
            starrtButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            starrtButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
            starrtButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -16),
        ])
        
        starrtButton.isUserInteractionEnabled = false
        starrtButton.alpha = 0
    }
    
    private func addPageControl() {
        pageControlVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageControlVC.view.translatesAutoresizingMaskIntoConstraints = false
        pageControlVC.dataSource = self
        pageControlVC.delegate = self
        
        addChild(pageControlVC)
        
        pageViewContainer.addSubview(pageControlVC.view)
        
        pageControlVC.view.pinEdgesToSuperView()
    }
    
    private func setupPages() {
        let page1 = PageVC()
        let page2 = PageVC()
        let page3 = PageVC()
        
        page1.setup(model: OnboardingModel(imageName: "img_placeholder", title: "Title 1", description: "Description 1"))
        page2.setup(model: OnboardingModel(imageName: "img_placeholder", title: "Title 2", description: "Description 2"))
        page3.setup(model: OnboardingModel(imageName: "img_placeholder", title: "Title 3", description: "Description 3"))
        
        pageControllers = [page1, page2, page3]
        
        if let firstVC = pageControllers.first {
            pageControlVC.setViewControllers([firstVC], direction: .forward, animated: false)
        }
    }

    //MARK: - ACTIONS
    
    @objc private func onTapStart() {
        let vc = AuthVC()
        vc.modalPresentationStyle = .fullScreen
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = TabVC()

            let authVC = AuthVC()
            authVC.modalPresentationStyle = .fullScreen
            
            window.rootViewController?.present(authVC, animated: false)
        }
        
        //        UserDefaultsStore.hasLaunchBefore = true
    }
    
    @objc private func onTapNext() {
        if (currentPage < NUMBER_OF_PAGES - 1) {
            let nextPage = currentPage + 1
            
            pageControlVC.setViewControllers(
                [pageControllers[nextPage]],
                direction: .forward,
                animated: true
            )
            
            pageControl.currentPage = nextPage
            currentPage = nextPage
        }
    }
    
    @objc func pageControltapped(_ sender: Any) {
        guard let pageControl = sender as? UIPageControl else {
            return
        }
        let selectedPage = pageControl.currentPage
        
        let direction: UIPageViewController.NavigationDirection = selectedPage > currentPage ? .forward : .reverse
        
        pageControlVC.setViewControllers(
            [pageControllers[selectedPage]],
            direction: direction,
            animated: true
        )
        
        currentPage = selectedPage
    }
}

extension OnboardingVC: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard let viewControllerIndex = pageControllers.firstIndex(of: viewController) else {
            return nil
        }
                       
        let previousIndex = viewControllerIndex - 1
       
        guard previousIndex >= 0 else {
            return nil
        }
       
        guard pageControllers.count > previousIndex else {
            return nil
        }
       
        return pageControllers[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        
        guard let viewControllerIndex = pageControllers.firstIndex(of: viewController) else {
            return nil
        }
       
        let nextIndex = viewControllerIndex + 1
        let pagesCount = pageControllers.count

        guard pagesCount != nextIndex else {
            return nil
        }
       
        guard pagesCount > nextIndex else {
            return nil
        }
       
        return pageControllers[nextIndex]
    }
}

extension OnboardingVC: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        let pageVC = pageViewController.viewControllers![0]
        
        if let index = pageControllers.firstIndex(of: pageVC) {
            pageControl.currentPage = index
            currentPage = index
        }
    }
}
