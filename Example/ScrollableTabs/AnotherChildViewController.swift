//
//  AnotherChildViewController.swift
//  ScrollableTabs
//
//  Created by kumapo on 2015/09/01.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit
import ScrollableTabs

class AnotherChildViewController: UIViewController, ScrollableTabBarContentableController {
    lazy var item: UIBarButtonItem! = {
        let content = UIButton(type: .Custom)
        content.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        content.setImage(UIImage(named: "tabKbPlusD"), forState: .Normal)
        content.setImage(UIImage(named: "tabKbPlusE"), forState: .Selected)
        content.imageView!.contentMode = .ScaleToFill
        return UIBarButtonItem(customView: content)
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.redColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
