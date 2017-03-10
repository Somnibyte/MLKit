#
# Be sure to run `pod lib lint MLKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MachineLearningKit'
  s.version          = '0.1.6'
  s.summary          = 'A simple machine learning framework written in Swift 🤖'

  s.description      = <<-DESC
    MLKit is a simple machine learning framework written in Swift. Currently MLKit features machine learning algorithms that deal with the topic of regression, but the framework will expand over time with topics such as classification, clustering, recommender systems, and deep learning. The vision and goal of this framework is to provide developers with a toolkit to create products that can learn from data. MLKit is a side project of mine in order to make it easier for developers to implement machine learning algorithms on the go, and to familiarlize myself with machine learning concepts.


                       DESC


  s.homepage         = 'https://github.com/Somnibyte/MLKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Guled Ahmed' => 'guledahmed777@gmail.com' }
  s.source           = { :git => 'https://github.com/Somnibyte/MLKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/_Guled_'

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '10.1'

  s.source_files = 'MLKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MLKit' => ['MLKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Upsurge'
end
