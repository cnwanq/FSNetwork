#
# Be sure to run `pod lib lint FSNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FSNetwork'
  s.version          = '0.3.0'
  s.summary          = 'Network tools for small team development.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A network tool for small team development. Lightweight, easy to expand, easy to develop
                       DESC

  s.homepage         = 'https://github.com/cnwanq/FSNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wanqijian' => 'wanqijian@icloud.com' }
  s.source           = { :git => 'https://github.com/cnwanq/FSNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FSNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FSNetwork' => ['FSNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'PromisesObjC', '~> 1.2.7'
end
