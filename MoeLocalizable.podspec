#
# Be sure to run `pod lib lint MoeLocalizable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MoeLocalizable'
  s.version          = '0.1.3'
  s.summary          = '本地化处理，支持应用内多语言切换'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  An iOS Localizable solution. using shell script to generate MoeLocalConst instance, which has all variable that transform from Localizable.strings.
                       DESC

  s.homepage         = 'https://github.com/linyanzuo/MoeLocalizable.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'linyanzuo1222@gmail.com' => 'zed@moemone.com' }
  s.source           = { :git => 'https://github.com/linyanzuo/MoeLocalizable.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_versions = '5.0'

  s.source_files = 'MoeLocalizable/Classes/*'
  
  # s.resource_bundles = {
  #   'MoeLocalizable' => ['MoeLocalizable/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MoeCommon'
end
