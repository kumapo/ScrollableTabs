#
# Be sure to run `pod lib lint ScrollableTabs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ScrollableTabs"
  s.version          = "0.2.3"
  s.summary          = "Protocol-oriented Scrollable TabBar written in Swift 4"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
Protocol-oriented Scrollable TabBar written in Swift 4.
                       DESC

  s.homepage         = "https://github.com/kumapo/ScrollableTabs"
  s.screenshots     = "https://github.com/kumapo/ScrollableTabs/raw/screenshots/screenshots_1.gif"
  s.license          = 'MIT'
  s.author           = { "kumapo" => "kumapo@users.noreply.github.com" }
  s.source           = { :git => "https://github.com/kumapo/ScrollableTabs.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'ScrollableTabs/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift', '4.1.2'
  s.dependency 'RxCocoa', '4.1.2'
end
