//
//  ScrollBarContentableController.swift
//  ScrollableTabBar
//
//  Created by kumapo on 2015/08/25.
//

import UIKit

//http://stackoverflow.com/questions/25214484
protocol UIViewControllerInject {}
extension UIViewController : UIViewControllerInject {}

protocol ScrollBarContentableController : UIViewControllerInject {
    var item: UIBarButtonItem! { get set }
    
}