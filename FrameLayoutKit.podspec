Pod::Spec.new do |s|
	s.name             = 'FrameLayoutKit'
	s.version          = '6.7.2'
	s.summary          = 'FrameLayoutKit is a super fast and easy to use layout kit'
	s.description      = <<-DESC
	FrameLayoutKit is a powerful Swift library designed to streamline the process of creating user interfaces. With its intuitive operator syntax and support for nested functions, developers can effortlessly construct complex UI layouts with minimal code. By leveraging the flexibility of operators, developers can easily position and arrange views within a container view, enabling precise control over the visual hierarchy. Additionally, the library offers a range of convenient functions for configuring view properties, such as setting dimensions, margins, and alignment. Whether you're building a simple screen or a complex interface, FrameLayoutKit simplifies the UI creation process, resulting in cleaner, more maintainable code.
	DESC
	
	s.homepage          = 'https://github.com/kennic/FrameLayoutKit'
	s.license           = { :type => 'MIT', :file => 'LICENSE' }
	s.author            = { 'Nam Kennic' => 'namkennic@me.com' }
	s.source            = { :git => 'https://github.com/kennic/FrameLayoutKit.git', :tag => s.version.to_s }
	s.social_media_url  = 'https://twitter.com/namkennic'
	s.platform          = :ios, "11.0"
#	s.platform          = :tvos, "11.0"
	s.ios.deployment_target = '11.0'
#	s.tvos.deployment_target = '11.0'
	s.swift_version 	= "5.8"
	s.source_files 		= 'FrameLayoutKit/Classes/**/*.*'
	
end
