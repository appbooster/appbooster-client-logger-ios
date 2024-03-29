#
# Be sure to run `pod lib lint IncentCleaner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AppboosterClientLogger'
  s.version          = '1.0.11'
  s.summary          = 'iOS Client Logger framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/appbooster/appbooster-client-logger-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vladimir Vasilev' => 'fredformout@yandex.ru' }
  s.source           = { :git => 'https://github.com/appbooster/appbooster-client-logger-ios', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AppboosterClientLogger/Classes/*', 'AppboosterClientLogger/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AppboosterClientLogger' => ['AppboosterClientLogger/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'

  s.swift_version = "5.0"
  
end
