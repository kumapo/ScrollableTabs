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
    
    private var selectedIndex: Int?
    public var selectedItem: UIBarButtonItem {
        set(willSelectItem) {
            if let index = indexWithItem(willSelectItem) {
                if !shouldSelectIndex(index) {
                    return
                }
                
                //Deselect previous selected
                if selectedIndex != nil {    //TODO: -1 as Not selected
                    let button = selectedItem.customView as! UIButton
                    button.selected = false
                }
                
                //Select current selected
                selectedIndex = index
                if let button = willSelectItem.customView as? UIButton {
                    button.selected = true
                }
            }
        }
        get {
            return toolbar.items![selectedIndex!]
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
            for var i = 0; i < items.count; i++ {
                if let button = items[i].customView as? UIButton {
                    let index = i                                       //クロージャを宣言したときの値を退避しておく
                    button.bk_addEventHandler({ [unowned self] (_) -> Void in
                        self.didSelectItem(items[index], index: index)  //宣言時の値をつかう
                    }, forControlEvents: .TouchUpInside)
                }
            }
        }
    }
    
    //TODO: To be single argument
    private func didSelectItem(item: UIBarButtonItem, index: Int) {
        if self.barDelegate == nil {
            return
        }
        if !shouldSelectIndex(index) {
            return
        }
        
        self.barDelegate!.scrollBar(self, didSelectItem: item)
    }
    
    private func shouldSelectIndex(index: Int) -> Bool {
        if index != selectedIndex {
            return true
        }
        return false
    }
    
    private func indexWithItem(item: UIBarButtonItem) -> Int? {
        if let items = self.toolbar.items {
            for var i = 0; i < items.count; i++ {
                if item == items[i] {
                    return i
                }
            }
        }
        return nil
    }
}
