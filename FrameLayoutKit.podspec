Pod::Spec.new do |s|
	s.name             = 'FrameLayoutKit'
	s.version          = '4.2.1'
	s.summary          = 'FrameLayoutKit is a super fast and easy to use layout kit'
	s.description      = <<-DESC
	An auto layout kit helps you to layout your UI easier and more effective
	DESC
	
	s.homepage          = 'https://github.com/kennic/FrameLayoutKit'
	s.license           = { :type => 'MIT', :file => 'LICENSE' }
	s.author            = { 'Nam Kennic' => 'namkennic@me.com' }
	s.source            = { :git => 'https://github.com/kennic/FrameLayoutKit.git', :tag => s.version.to_s }
	s.social_media_url  = 'https://twitter.com/namkennic'
	s.platform          = :ios, "8.0"
	s.platform          = :tvos, "9.0"
	s.ios.deployment_target = '8.0'
	s.tvos.deployment_target = '9.0'
	s.swift_version 	= "4.2"
	s.source_files 		= 'FrameLayoutKit/Classes/*.*'
	
end
