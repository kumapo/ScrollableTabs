//
//  ScrollBarController.swift
//  ScrollableTabBar
//
//  Created by kumapo on 2015/08/23.
//

import UIKit

public protocol ScrollBarControllerDelegate : class {
    func scrollBarController(scrollBarController: ScrollBarController,
        didSelectViewController viewController: UIViewController)
}

public protocol ScrollBarController : ScrollBarDelegate {
    var scrollBar: ScrollBar! { get }
    weak var delegate: ScrollBarControllerDelegate? { get set }
    var isTransitioningFromViewController: Bool { get set }
    
    //Override by extension
    func setViewControllers(viewControllers: [ScrollBarContentableController], animated: Bool)

    //From UIViewController
    var childViewControllers: [UIViewController] { get }
    func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?)
    func didMoveToParentViewController(parent: UIViewController?)
    func addChildViewController(childController: UIViewController)
    
    //Overloads
    func didMoveToParentViewController(parent: ScrollBarContentableController?)
    func addChildViewController(childController: ScrollBarContentableController)
}

public extension ScrollBarController {
    var selectedViewController: UIViewController {
        get {
            return viewControllerWithItem(scrollBar.selectedItem)!
        }
        set {
            let contentController = newValue as! ScrollBarContentableController
            scrollBar.selectedItem = contentController.item
        }
    }

    func setViewControllers(viewControllers:[ScrollBarContentableController], animated: Bool) {
        if scrollBar.barDelegate == nil {
            scrollBar.barDelegate = self    //Set once
        }
        
        for viewController in viewControllers {
            self.addChildViewController(viewController)
            self.didMoveToParentViewController(viewController)
        }
        
        var items: [UIBarButtonItem] = []
        for childController in childViewControllers {
            //childViewController が ScrollBarContentableController でないときは例外にする
            let contentController = childController as! ScrollBarContentableController
            items.append(contentController.item)
        }
        scrollBar.setItems(items, animated: false)
    }
    
    func scrollBar(scrollbar: ScrollBar, willSelectItem item: UIBarButtonItem!) {
        let didSelectController = viewControllerWithItem(item)
        
        if let toViewController = didSelectController {
            if selectedViewController != toViewController {
                
                if isTransitioningFromViewController {
                    return
                } else {
                    isTransitioningFromViewController = true
                }
                
                self.transitionFromViewController(selectedViewController, toViewController: didSelectController!,
                    duration: NSTimeInterval(0), options: UIViewAnimationOptions(rawValue: 0),
                    animations: { [unowned self] (finished) -> Void in
                        //toViewController の viewWillAppear の実行が終わったあとに実行する
                        self.selectedViewController = didSelectController!
                        
                        if self.delegate != nil {
                            self.delegate!.scrollBarController(self, didSelectViewController: self.selectedViewController)
                        }
                    },
                    completion: { [unowned self] (finished) -> Void in
                        //toViewController の viewDidAppear の実行が終わったあとに実行する
                        self.isTransitioningFromViewController = false
                    })
            }
        }
        
    }
    
    private func viewControllerWithItem(item: UIBarButtonItem) -> UIViewController? {
        var viewController: UIViewController?
        for childController in self.childViewControllers {
            //childViewController が ScrollBarContentableController でないときは例外にする
            let contentController = childController as! ScrollBarContentableController
            if contentController.item == item {
                viewController = childController
                break
            }
        }
        return viewController
    }
    
    func addChildViewController(childController: ScrollBarContentableController) {
        self.addChildViewController(childController as! UIViewController)
    }
    
    func didMoveToParentViewController(parent: ScrollBarContentableController?) {
        self.didMoveToParentViewController(parent as! UIViewController?)
    }

}