#
# Be sure to run `pod lib lint QSKitLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QSKitLibrary'
  s.version          = '0.1.1'
  s.summary          = 'QSKitLibrary提供基础UI组件，帮你快速通过纯代码搭建一个ios app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
提供一套基于UIKit的自定义风格组件，扩展自定义widget
                       DESC

  s.homepage         = 'https://github.com/quasi-library/ui-sdk-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Quasi Soul' => 'soulstayreal@gmail.com' }
  s.source           = { :git => 'https://github.com/quasi-library/ui-sdk-swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_versions = '5.0'

  s.source_files = 'QSKitLibrary/Classes/**/*'
  
  # s.resource_bundles = {
  #   'QSKitLibrary' => ['QSKitLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # 刷新组件
  s.dependency 'MJRefresh', '~> 3.7.5'
  # 方便UI控件使用函数式编程
  s.dependency 'RxCocoa', '~> 6.5.0'
  s.dependency 'RxSwift', '~> 6.5.0'
  s.dependency 'SnapKit', '~> 5.6.0'
  s.dependency 'SnapKitExtend', '~> 1.1.0'
  # 一个牛逼的popup容器组件，可以用来展示toast和alert
  s.dependency 'SwiftEntryKit', '~> 2.0.0'
end
