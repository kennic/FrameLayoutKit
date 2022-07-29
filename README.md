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

## Why?

Say NO to autolayout constraint nightmare:

![NO](https://github.com/kennic/FrameLayoutKit/blob/master/no_constraint.png)
![YES](https://github.com/kennic/FrameLayoutKit/blob/master/frameLayoutSyntax.png)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

FrameLayoutKit is available through `Swift Package Manager` (Recommended) and [CocoaPods](http://cocoapods.org):

Regardless, make sure to import the project wherever you may use it:

```swift
import FrameLayoutKit
```

### Cocoapods:
FrameLayoutKit can be installed as a [CocoaPod](https://cocoapods.org/). To install, include this in your Podfile.

```ruby
pod "FrameLayoutKit"
```


### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into Xcode and the Swift compiler. **This is the recommended installation method.** Updates to FrameLayoutKit will always be available immediately to projects with SPM. SPM is also integrated directly with Xcode.

If you are using Xcode 11 or later:
 1. Click `File`
 2. `Add Packages...`
 3. Specify the git URL for FrameLayoutKit.

```swift
https://github.com/kennic/FrameLayoutKit.git
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
