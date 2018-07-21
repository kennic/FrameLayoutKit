#
# Be sure to run `pod lib lint FrameLayoutKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name             = 'FrameLayoutKit'
	s.version          = '3.0.4'
	s.summary          = 'FrameLayoutKit is a super fast and easy to use layout kit'
	
	# This description is used to generate tags and improve search results.
	#   * Think: What does it do? Why did you write it? What is the focus?
	#   * Try to keep it short, snappy and to the point.
	#   * Write the description between the DESC delimiters below.
	#   * Finally, don't worry about the indent, CocoaPods strips it!
	
	s.description      = <<-DESC
	An auto layout kit helps you to layout your UI easier and more effective
	DESC
	
	s.homepage          = 'https://github.com/kennic/FrameLayoutKit'
	# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
	s.license           = { :type => 'MIT', :file => 'LICENSE' }
	s.author            = { 'Nam Kennic' => 'namkennic@me.com' }
	s.source            = { :git => 'https://github.com/kennic/FrameLayoutKit.git', :tag => s.version.to_s }
	s.social_media_url  = 'https://twitter.com/namkennic'
	s.platform          = :ios, "8.0"
	s.platform          = :tvos, "9.0"
	s.ios.deployment_target = '8.0'
	s.tvos.deployment_target = '9.0'
	s.swift_version 	= "4.1"
	s.source_files 		= 'FrameLayoutKit/Classes/*.*'
	
	# s.resource_bundles = {
	#   'FrameLayoutKit' => ['FrameLayoutKit/Assets/*.png']
	# }
	
	# s.public_header_files = 'Pod/Classes/**/*.h'
	# s.frameworks = 'UIKit', 'MapKit'
	# s.dependency 'AFNetworking', '~> 2.3'
end
