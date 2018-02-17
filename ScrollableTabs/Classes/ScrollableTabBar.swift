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
    func scrollBar(_ scrollbar:ScrollableTabBar, willSelectItem item:UIBarButtonItem!)
}

open class ScrollableTabBar: UIScrollView {
    lazy var toolbar: UIToolbar = {
        let contentBar = ContentBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        contentBar.barTintColor = UIColor(red:0.11, green:0.102, blue:0.161, alpha:1)   //TODO: Configurable
        return contentBar
    }()

    weak open var barDelegate: ScrollableTabBarDelegate?
    
    fileprivate var selectedIndex: Int?
    open var selectedItem: UIBarButtonItem {
        set(willSelectItem) {
            let index = indexWithItem(willSelectItem)
            if !shouldSelectIndex(index) {
                return
            }
            
            //Deselect previous selected
            if selectedIndex != nil {
                let button = selectedItem.customView as! UIButton
                button.isSelected = false
            }
            
            //Select current selected
            selectedIndex = index
            if let button = willSelectItem.customView as? UIButton {
                button.isSelected = true
            }
        }
        get {
            return itemWithIndex(selectedIndex!)
        }
    }
    
    fileprivate var fixedSpaceOf: (CGFloat) -> UIBarButtonItem =  { width in
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = width
        return spacer
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    fileprivate func _init() {
        self.autoresizesSubviews = true     //Layout subviews with autoresize
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        
        self.bounds = CGRect(x: CGFloat(0), y: CGFloat(0),
            width: self.frame.size.width, height: self.frame.size.height)
        
        self.addSubview(self.toolbar)
    }
    
    override open var intrinsicContentSize : CGSize {
        let width = self.bounds.size.width
        let hight = self.bounds.size.height
        return CGSize(width: width, height: hight)
    }

    func setItems(_ items: [UIBarButtonItem]?, animated: Bool) {
        toolbar.setItems(itemsWithFixedSpace(items), animated: animated)
        addActionToItems()
        
        let toolbarSize = toolbar.sizeThatFits(toolbar.frame.size)
        if frame.size.width < toolbarSize.width {
            toolbar.sizeToFit()    //sizeToFit calls sizeThatFits and layoutSubviews
        }
        //toolbar に items が収まるときはリサイズしない
        self.contentSize = toolbarSize
    }
    fileprivate func itemsWithFixedSpace(_ items: [UIBarButtonItem]?) -> [UIBarButtonItem] {
        var withSpace = [self.fixedSpaceOf(-19.0)]                      //TODO: Configurable
        items?.forEach { [unowned self] item in
            withSpace.append(contentsOf: [item, self.fixedSpaceOf(-9.0)]) //TODO: Configurable
        }
        return withSpace
    }
    
    fileprivate func addActionToItems() {
        if let items = self.toolbar.items {
            for i in 0 ..< items.count {
                if let button = items[i].customView as? UIButton {
                    let index = i                   // Capture the value which it declares
                    button.rx.tap.subscribe(onNext: { [unowned self] _ in
                        self.willSelectIndex(index) // Use captured value
                    }).disposed(by:disposeBag)
                }
            }
        }
    }
    
    fileprivate func willSelectIndex(_ index: Int) {
        if self.barDelegate == nil {
            return
        }
        if !shouldSelectIndex(index) {
            return
        }
        let willSelectItem = itemWithIndex(index)
        self.barDelegate!.scrollBar(self, willSelectItem: willSelectItem)
    }
    
    fileprivate func shouldSelectIndex(_ index: Int) -> Bool {
        if index != selectedIndex {
            return true
        }
        return false
    }
    
    fileprivate func indexWithItem(_ item: UIBarButtonItem) -> Int {
        var index = -1
        let items = self.toolbar.items!
        for i in 0 ..< items.count {
            if item == items[i] {
                index = i
                break
            }
        }
        return index
    }
    
    fileprivate func itemWithIndex(_ index: Int) -> UIBarButtonItem {
        return toolbar.items![index]
    }
}
