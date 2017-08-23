//
//  ViewController.swift
//  ScrollableTabs
//
//  Created by kumapo on 08/30/2015.
//  Copyright (c) 2015 kumapo. All rights reserved.
//

import UIKit
import ScrollableTabs

class ViewController: UIViewController, ScrollableTabBarController, ScrollableTabBarControllerDelegate {
    
    //Protocol Methods
    @IBOutlet weak var scrollBar: ScrollableTabBar!
    weak var delegate: ScrollableTabBarControllerDelegate?
    var isTransitioningFromViewController: Bool = false
    
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.        
        configureChildViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureChildViewControllers() {
        let firstChildViewController = ChildViewController()
        
        setViewControllers([firstChildViewController, AnotherChildViewController(), ChildViewController(),
//            AnotherChildViewController(), ChildViewController(), AnotherChildViewController(),
//            ChildViewController(), AnotherChildViewController(), ChildViewController(),
            AnotherChildViewController()], animated: false)
        selectedViewController = firstChildViewController
        delegate = self
        
        containerView.addSubview(selectedViewController.view)
        updateSelectedViewConstraints()
    }

    func updateSelectedViewConstraints() {
        guard let selectedView = selectedViewController.view else { return }
        
        let viewDictionary = [ "contentView": selectedView ]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        self.containerView.addConstraints(horizontalConstraints)
        self.containerView.addConstraints(verticalConstraints)
    }
    
    //MARK: ScrollableTabBarController Delegate
    func scrollBarController(_ scrollBarController: ScrollableTabBarController, didSelectViewController viewController: UIViewController) {
        updateSelectedViewConstraints()
    }
}

