//
//  ContentBar.swift
//  ScrollableTabs
//
//  Created by kumapo on 2015/08/17.
//

import UIKit

class ContentBar: UIToolbar {
    let TrailingMarginToToolBar: CGFloat = 16.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private func _init() {
        self.clipsToBounds = true
    }
    
    // http://stackoverflow.com/questions/2135407/is-there-a-way-to-change-the-height-of-a-uitoolbar
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric,
            height: self.superview!.bounds.size.height)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let baseSize = super.sizeThatFits(size)
        let trailingView = self.subviews.last!
        return CGSize(width: trailingView.frame.origin.x + trailingView.frame.size.width + TrailingMarginToToolBar,
            height: baseSize.height)
    }
}
