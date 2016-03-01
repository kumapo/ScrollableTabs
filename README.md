# ScrollableTabs

[![CI Status](http://img.shields.io/travis/kumapo/ScrollableTabs.svg?style=flat)](https://travis-ci.org/kumapo/ScrollableTabs)
[![Version](https://img.shields.io/cocoapods/v/ScrollableTabs.svg?style=flat)](http://cocoapods.org/pods/ScrollableTabs)
[![License](https://img.shields.io/cocoapods/l/ScrollableTabs.svg?style=flat)](http://cocoapods.org/pods/ScrollableTabs)
[![Platform](https://img.shields.io/cocoapods/p/ScrollableTabs.svg?style=flat)](http://cocoapods.org/pods/ScrollableTabs)

## Screenshots

![Screenshots_1](https://github.com/kumapo/ScrollableTabs/raw/screenshots/screenshots_1.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ScrollableTabs is available through both [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage). 

### CocoaPods 

To integrate it into your project using CocoaPods, specify it in your Podfile:

```ruby
pod "ScrollableTabs"
```
### Carthage

Specify it in your Cartfile: 

```
github "kumapo/ScrollableTabs"
```

## Usage

### Container ViewController

```Swift
import ScrollableTabs

class ViewController: UIViewController, ScrollableTabBarController {
    
    //Protocol Methods
    @IBOutlet weak var scrollBar: ScrollableTabBar!
    weak var delegate: ScrollableTabBarControllerDelegate?
    var isTransitioningFromViewController: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize childViewController1 and childViewController2
        // .. 
        setViewControllers([childViewController1, childViewController2], animated: false)
        selectedViewController = childViewController1
```

### Content ViewController

```Swift
class ChildViewController: UIViewController, ScrollableTabBarContentableController {
    lazy var item: UIBarButtonItem = {
    // Initialize UIBarButtonItem
    // .. 
    }()
```

## Author

kumapo, kumapo@users.noreply.github.com

## License

ScrollableTabs is available under the MIT license. See the LICENSE file for more info.
