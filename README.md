![](https://github.com/kennic/FrameLayoutKit/blob/master/banner.jpg)

[![Version](https://img.shields.io/cocoapods/v/FrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/FrameLayoutKit)
[![License](https://img.shields.io/cocoapods/l/FrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/FrameLayoutKit)
[![Platform](https://img.shields.io/cocoapods/p/FrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/FrameLayoutKit)
![Swift](https://img.shields.io/badge/%20in-swift%204.2-orange.svg)

FrameLayout is a super fast and easy to use layout library for iOS and tvOS.

For Objective-C version: [NKFrameLayoutKit](http://github.com/kennic/NKFrameLayoutKit) (Deprecated, not recommended)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

FrameLayoutKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FrameLayoutKit"
```

## Example
This is how FrameLayoutKit layout the card view below:

```swift
let imageLayout = StackFrameLayout(axis: .vertical)
imageLayout.append(view: earthImageView).contentAlignment = (.top, .center)
imageLayout.appendSpace().isFlexible = true
imageLayout.append(view: rocketImageView).contentAlignment = (.center, .center)

let labelLayout = StackFrameLayout(axis: .vertical, distribution: .top)
labelLayout.append(view: nameLabel)
labelLayout.append(view: dateLabel)
labelLayout.appendSpace(size: 10.0)
labelLayout.append(view: messageLabel)
labelLayout.spacing = 5.0

let frameLayout = StackFrameLayout(axis: .horizontal)
frameLayout.append(frameLayout: imageLayout)
frameLayout.append(frameLayout: contentLayout)
frameLayout.spacing = 15.0
frameLayout.edgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
frameLayout.showFrameDebug = true


// New nested way (since v4.9.0):

frameLayout.append(frameLayout: StackFrameLayout(axis: .vertical).with {
	$0.append(view: earthImageView).contentAlignment = (.top, .center)
	$0.appendSpace(size: 10).isFlexible = true
	$0.append(view: rocketImageView).contentAlignment = (.center, .center)
})
frameLayout.append(frameLayout: StackFrameLayout(axis: .vertical, distribution: .top).with {
	$0.append(view: nameLabel)
	$0.append(view: dateLabel)
	$0.appendSpace(size: 10.0)
	$0.append(view: messageLabel)
	$0.spacing = 5.0
})
```
![Hello World](/helloWorld.png "Hello World")

## Benchmark
FrameLayoutKit is one of the fastest layout libraries.
![Benchmark Results](/bechmark.png "Benchmark results")

See: [Layout libraries benchmark's project](https://github.com/layoutBox/LayoutFrameworkBenchmark)

## Todo

- [x] CocoaPods support
- [x] Objective-C version
- [x] Swift version
- [x] Examples
- [ ] Documents

## Author

Nam Kennic, namkennic@me.com

## License

FrameLayoutKit is available under the MIT license. See the LICENSE file for more info.
