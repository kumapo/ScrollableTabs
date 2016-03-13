//
//  ScrollableTabBar.swift
//  ScrollableTabs
//
//  Created by kumapo on 2015/08/11.
//

import UIKit
import RxSwift
import RxCocoa

public protocol ScrollableTabBarDelegate: class {
    func scrollBar(scrollbar:ScrollableTabBar, willSelectItem item:UIBarButtonItem!)
}

public class ScrollableTabBar: UIScrollView {
    lazy var toolbar: UIToolbar = {
        let contentBar = ContentBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        contentBar.barTintColor = UIColor(red:0.11, green:0.102, blue:0.161, alpha:1)
        return contentBar
    }()

    weak public var barDelegate: ScrollableTabBarDelegate?
    
    private var selectedIndex: Int?
    public var selectedItem: UIBarButtonItem {
        set(willSelectItem) {
            let index = indexWithItem(willSelectItem)
            if !shouldSelectIndex(index) {
                return
            }
            
            //Deselect previous selected
            if selectedIndex != nil {
                let button = selectedItem.customView as! UIButton
                button.selected = false
            }
            
            //Select current selected
            selectedIndex = index
            if let button = willSelectItem.customView as? UIButton {
                button.selected = true
            }
        }
        get {
            return itemWithIndex(selectedIndex!)
        }
    }
    
    private var fixedSpaceOf: (CGFloat) -> UIBarButtonItem =  { width in
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = width
        return spacer
    }
    
    private let disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
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
        toolbar.setItems(itemsWithFixedSpace(items), animated: animated)
        addActionToItems()
        
        let toolbarSize = toolbar.sizeThatFits(toolbar.frame.size)
        if frame.size.width < toolbarSize.width {
            toolbar.sizeToFit()    //sizeToFit calls sizeThatFits and layoutSubviews
        }
        //toolbar に items が収まるときはリサイズしない
        self.contentSize = toolbarSize
    }
    private func itemsWithFixedSpace(items: [UIBarButtonItem]?) -> [UIBarButtonItem] {
        var withSpace = [self.fixedSpaceOf(-19.0)]
        items?.forEach { [unowned self] item in
            withSpace.appendContentsOf([item, self.fixedSpaceOf(-9.0)])
        }
        return withSpace
    }
    
    private func addActionToItems() {
        if let items = self.toolbar.items {
            for var i = 0; i < items.count; i++ {
                if let button = items[i].customView as? UIButton {
                    let index = i                   //クロージャを宣言したときの値を退避しておく
                    button.rx_tap.subscribeNext { [unowned self] _ in
                        self.willSelectIndex(index) //宣言時の値をつかう
                    } .addDisposableTo(disposeBag)
                }
            }
        }
    }
    
    private func willSelectIndex(index: Int) {
        if self.barDelegate == nil {
            return
        }
        if !shouldSelectIndex(index) {
            return
        }
        let willSelectItem = itemWithIndex(index)
        self.barDelegate!.scrollBar(self, willSelectItem: willSelectItem)
    }
    
    private func shouldSelectIndex(index: Int) -> Bool {
        if index != selectedIndex {
            return true
        }
        return false
    }
    
    private func indexWithItem(item: UIBarButtonItem) -> Int {
        var index = -1
        let items = self.toolbar.items!
        for var i = 0; i < items.count; i++ {
            if item == items[i] {
                index = i
                break
            }
        }
        return index
    }
    
    private func itemWithIndex(index: Int) -> UIBarButtonItem {
        return toolbar.items![index]
    }
}
