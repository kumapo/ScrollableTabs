//
//  ContentBar.swift
//  ScrollableTabs
//
//  Created by kumapo on 2015/08/17.
//

import UIKit

class ContentBar: UIToolbar {
    var TrailingMarginToToolBar: CGFloat { return 0.0 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    fileprivate func _init() {
        clipsToBounds = true
    }
    
    // http://stackoverflow.com/questions/2135407/is-there-a-way-to-change-the-height-of-a-uitoolbar
    override var intrinsicContentSize : CGSize {
        return CGSize(width: UIView.noIntrinsicMetric,
            height: self.superview!.bounds.size.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        let baseSize = super.sizeThatFits(size)   //Not to change height to super calcurates
        let trailingView = self.subviews.last!
        return CGSize(width: trailingView.frame.origin.x + trailingView.frame.size.width + TrailingMarginToToolBar,
            height: bounds.height)                  //Keep height when initialized
    }
}
