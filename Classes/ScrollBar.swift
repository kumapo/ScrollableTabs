//
//  ScrollBar.swift
//  ScrollableTabBar
//
//  Created by kumapo on 2015/08/11.
//

import UIKit
import BlocksKit

public protocol ScrollBarDelegate: class {
    func scrollBar(scrollbar:ScrollBar, didSelectItem item:UIBarButtonItem!)
}



public class ScrollBar: UIScrollView {
    lazy var toolbar: UIToolbar = {
        return ContentBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
    }()

    weak public var barDelegate: ScrollBarDelegate?
    
    private var _selectedItem: UIBarButtonItem?
    public var selectedItem: UIBarButtonItem {
        set(selecting) {
            if !shouldSetSelectItem(selecting) {
                return
            }
            
            //Deselect previous selected
            if _selectedItem != nil {
                let button = _selectedItem!.customView as! UIButton
                button.selected = false
            }
            
            //Select current selected
            _selectedItem = selecting
            if let button = selecting.customView as? UIButton {
                button.selected = true
            }
        }
        get {
            return _selectedItem!
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private func _init() {
        self.autoresizesSubviews = true     //Layout subviews with autoresize
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        
        self.bounds = CGRect(x: CGFloat(0), y: CGFloat(0),
            width: self.frame.size.width, height: self.frame.size.height)
        
        self.addSubview(self.toolbar)
    }
    
    override public func intrinsicContentSize() -> CGSize {
        let width = self.bounds.size.width
        let hight = self.bounds.size.height
        return CGSize(width: width, height: hight)
    }

    func setItems(items: [UIBarButtonItem]?, animated: Bool) {
        self.toolbar.setItems(items, animated: animated)
        addActionToItems()
        
        let toolbarSize = self.toolbar.sizeThatFits(self.toolbar.frame.size)
        if self.frame.size.width < toolbarSize.width {
            self.toolbar.sizeToFit()    //sizeToFit calls sizeThatFits and layoutSubviews
        }
        //toolbar に items が収まるときはリサイズしない
        self.contentSize = toolbarSize
    }
    
    private func addActionToItems() {
        if let items = self.toolbar.items {
            for item in items {
                if let button = item.customView as? UIButton {
                    button.bk_addEventHandler({ [unowned self] (_) -> Void in
                        self.didSelectItem(item)
                    }, forControlEvents: .TouchUpInside)
                }
            }
        }
    }
    
    private func didSelectItem(item: UIBarButtonItem) {
        if self.barDelegate == nil {
            return
        }
        if !shouldSetSelectItem(item) {
            return
        }
        
        self.barDelegate!.scrollBar(self, didSelectItem: item)
    }
    
    private func shouldSetSelectItem(item: UIBarButtonItem?) -> Bool {
        if item != nil && item != _selectedItem {
            return true
        }
        return false
    }
    
    
}
