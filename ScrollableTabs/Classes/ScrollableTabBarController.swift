//
//  ScrollableTabBarController.swift
//  ScrollableTabs
//
//  Created by kumapo on 2015/08/23.
//

import UIKit

public protocol ScrollableTabBarControllerDelegate : class {
    func scrollBarController(_ scrollBarController: ScrollableTabBarController,
        didSelectViewController viewController: UIViewController)
}

public protocol ScrollableTabBarController : ScrollableTabBarDelegate {
    var scrollBar: ScrollableTabBar! { get }
    var isTransitioningFromViewController: Bool { get set }
    weak var delegate: ScrollableTabBarControllerDelegate? { get set }

    //Override by extension
    func setViewControllers(_ viewControllers: [ScrollableTabBarContentableController], animated: Bool)

    //From UIViewController
    var children: [UIViewController] { get }
    func transition(from fromViewController: UIViewController, to toViewController: UIViewController, duration: TimeInterval, options: UIView.AnimationOptions, animations: (() -> Swift.Void)?, completion: ((Bool) -> Swift.Void)?)
    func didMove(toParent parent: UIViewController?)
    func addChild(_ childController: UIViewController)
    
    //Overloads
    func didMove(toParent parent: ScrollableTabBarContentableController?)
    func addChild(_ childController: ScrollableTabBarContentableController)
}

public extension ScrollableTabBarController {
    var selectedViewController: UIViewController {
        get {
            return viewControllerWithItem(scrollBar.selectedItem)!
        }
        set {
            let contentController = newValue as! ScrollableTabBarContentableController
            scrollBar.selectedItem = contentController.item
        }
    }

    func setViewControllers(_ viewControllers:[ScrollableTabBarContentableController], animated: Bool) {
        if scrollBar.barDelegate == nil {
            scrollBar.barDelegate = self    //Set once
        }
        
        for viewController in viewControllers {
            addChild(viewController)
            didMove(toParent: viewController)
        }
        
        var items: [UIBarButtonItem] = []
        for childController in children {
            //childViewController が ScrollBarContentableController でないときは例外にする
            let contentController = childController as! ScrollableTabBarContentableController
            items.append(contentController.item)
        }
        scrollBar.setItems(items, animated: false)
    }
    
    func scrollBar(_ scrollbar: ScrollableTabBar, willSelectItem item: UIBarButtonItem!) {
        guard
            let toViewController = viewControllerWithItem(item),
            selectedViewController != toViewController,
            !isTransitioningFromViewController
        else {
            return
        }
        
        isTransitioningFromViewController = true
        self.transition(from: selectedViewController, to: toViewController,
                        duration: TimeInterval(0),
                        options:UIView.AnimationOptions(rawValue:0),
                        animations: { [unowned self] in
                            //toViewController の viewWillAppear の実行が終わったあとに実行する
                            self.selectedViewController = toViewController
                        
                            if let delegate = self.delegate {
                                delegate.scrollBarController(self, didSelectViewController: self.selectedViewController)
                            }
                        },
                        completion: { [unowned self] _ in
                            //toViewController の viewDidAppear の実行が終わったあとに実行する
                            self.isTransitioningFromViewController = false
                        })
    }
    
    fileprivate func viewControllerWithItem(_ item: UIBarButtonItem) -> UIViewController? {
        var viewController: UIViewController?
        for childController in children {
            //childViewController が ScrollBarContentableController でないときは例外にする
            let contentController = childController as! ScrollableTabBarContentableController
            if contentController.item == item {
                viewController = childController
                break
            }
        }
        return viewController
    }
    
    func addChild(_ childController: ScrollableTabBarContentableController) {
        guard  let childController = childController as? UIViewController else { return }
        
        addChild(childController)
    }
    
    func didMove(toParent parent: ScrollableTabBarContentableController?) {
        didMove(toParent: parent as? UIViewController)
    }

}
