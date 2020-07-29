# FrameLayoutKit

[![Platform](https://img.shields.io/cocoapods/p/FrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/FrameLayoutKit)
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/FrameLayoutKit.svg?style=flat-square)](http://cocoapods.org/pods/FrameLayoutKit)
[![SwiftPM Compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/cocoapods/l/FrameLayoutKit.svg?style=flat-square)](http://cocoapods.org/pods/FrameLayoutKit)

![image](https://github.com/kennic/FrameLayoutKit/blob/master/banner.jpg)

FrameLayout is a super fast and easy to use layout library for iOS and tvOS.

For Objective-C version: [NKFrameLayoutKit](http://github.com/kennic/NKFrameLayoutKit) (Deprecated, not recommended)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

FrameLayoutKit is available through `Swift Package Manager` (Recommended) and [CocoaPods](http://cocoapods.org):

```ruby
pod "FrameLayoutKit"
```

## Example
This is how FrameLayoutKit layout the card view below:

```swift
let frameLayout = HStackLayout {
  $0.add(VStackLayout {
    $0.add(earthImageView).alignment = (.top, .center)
    $0.addSpace().flexible()
    $0.add(rocketImageView).alignment = (.center, .center)
  })
		
  $0.add(VStackLayout {
    $0.add([nameLabel, dateLabel])
    $0.addSpace(10)
    $0.add(messageLabel)
    $0.spacing = 5.0
  })

  $0.spacing = 15.0
  $0.padding(top: 15, left: 15, bottom: 15, right: 15)
  $0.debug = true
}
```
![Hello World](/helloWorld.png "Hello World")

Or you can use operand syntax for shorter/cleaner code:

```swift
let frameLayout = StackFrameLayout(axis: .horizontal)
frameLayout + VStackLayout {
	($0 + earthImageView).alignment = (.top, .center)
	($0 + 0).flexible() // add a flexible space
	($0 + rocketImageView).alignment = (.center, .center)
}
frameLayout + VStackLayout {
	$0 + [nameLabel, dateLabel] // add an array of views
	$0 + 10 // add space with 10 px fixed
	$0 + messageLabel // add a single view
	$0.spacing = 5.0 // spacing between views
}

frameLayout.spacing = 15.0
frameLayout.padding(top: 15, left: 15, bottom: 15, right: 15)
frameLayout.debug = true // show debug frame
}
```

## Benchmark
FrameLayoutKit is one of the fastest layout libraries.
![Benchmark Results](/bechmark.png "Benchmark results")

See: [Layout libraries benchmark's project](https://github.com/layoutBox/LayoutFrameworkBenchmark)

## Todo

- [x] Swift Package Manager
- [x] CocoaPods support
- [x] Objective-C version (Deprecated - Not recommended)
- [x] Swift version
- [x] Examples
- [ ] Documents

## Author

Nam Kennic, namkennic@me.com

## License

FrameLayoutKit is available under the MIT license. See the LICENSE file for more info.
