//
//  ContainerController.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    private var tripsViewController: TripsViewController!
    private var sideMenuController: SideMenuController!
    private var mainNavigationController: UINavigationController!
    private let darkTintView = UIView()
    private var menuIsExpanded = false
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .slide }
    override var prefersStatusBarHidden: Bool { !menuIsExpanded }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainNavigationController()
        configureMenuController()
    }
    
    // MARK: - Helpers
    
    private func configureMainNavigationController() {
        tripsViewController = TripsViewController()
        tripsViewController.sideMenuDelegate = self
        mainNavigationController = UINavigationController(rootViewController: tripsViewController)
        view.addSubview(mainNavigationController.view)
        addChild(mainNavigationController)
        mainNavigationController.didMove(toParent: self)
        
        // Configure Dark Tint View
        darkTintView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        darkTintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        darkTintView.alpha = 0
        mainNavigationController.view.addSubview(darkTintView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        darkTintView.addGestureRecognizer(tap)
    }
    
    private func configureMenuController() {
        if sideMenuController == nil {
            sideMenuController = SideMenuController()
            sideMenuController.delegate = self
            view.insertSubview(sideMenuController.view, at: 0)
            addChild(sideMenuController)
            sideMenuController.didMove(toParent: self)
            sideMenuController.view.frame.origin.x = -view.frame.width
        }
    }
    
    // MARK: - Selectors
    
    @objc private func dismissMenu() {
        animateSideMenu()
    }
    
    @objc private func profileImageTapped() {
        animateSideMenu()
    }
}
    
// MARK: - Animation

extension ContainerController {
    
    private func animateSideMenu() {
        
        if menuIsExpanded {
            // Hide side menu
            self.darkTintView.alpha = 0
            UIView.animate(withDuration: 0.15, delay: 0, animations: {
                self.sideMenuController.view.frame.origin.x = -self.view.frame.width
                self.mainNavigationController.view.frame.origin.x = 0
                self.tripsViewController.profileButton.customView?.alpha = 1
            })
        } else {
            // Show side menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 5.0,
                           options: .curveEaseOut,
                           animations: {
                            self.sideMenuController.view.frame.origin.x = 0
                            self.mainNavigationController.view.frame.origin.x = self.view.frame.width - 80
                            self.darkTintView.alpha = 1
                            self.tripsViewController.profileButton.customView?.alpha = 0
                           }, completion: nil)
        }
        
        animateStatusBar()
        menuIsExpanded.toggle()
    }
    
    private func animateStatusBar() {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.setNeedsStatusBarAppearanceUpdate()
                       }, completion: nil)
    }
}

// MARK: - MainControllerDelegate

extension ContainerController: SideMenuDelegate {
    func toggleSideMenu() {
        animateSideMenu()
    }
}
