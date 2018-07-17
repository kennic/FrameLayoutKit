# FrameLayoutKit

[![CI Status](http://img.shields.io/travis/kennic/FrameLayoutKit.svg?style=flat)](https://travis-ci.org/kennic/FrameLayoutKit)
[![Version](https://img.shields.io/cocoapods/v/FrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/FrameLayoutKit)
[![License](https://img.shields.io/cocoapods/l/FrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/FrameLayoutKit)
[![Platform](https://img.shields.io/cocoapods/p/FrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/FrameLayoutKit)

FrameLayout is a super fast and easy to use layout library for iOS and tvOS.

Note: This is the Swift version of [NKFrameLayoutKit](http://github.com/kennic/NKFrameLayoutKit) and it's still in development progress

## Example

![Grid Example](/../master/example_grid.png?raw=true "GridFrameLayout example")

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FrameLayoutKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FrameLayoutKit"
```

## Hello world

```swift
let image = UIImage(named: "earth.jpg")

let label = UILabel()
label.text = "Hello World"

let layout = DoubleFrameLayout(direction: .horizontal, andViews: [image, label])
layout.spacing = 5
layout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
layout.frame = self.bounds
```
![Hello World](/helloWorld.png "Hello World")

## Benchmark
FrameLayoutKit is one of the fastest layout libraries.
![Benchmark Results](/bechmark.png "Benchmark results")

See: [Layout libraries benchmark's project](https://github.com/layoutBox/LayoutFrameworkBenchmark)

## Author

Nam Kennic, namkennic@me.com

## License

FrameLayoutKit is available under the MIT license. See the LICENSE file for more info.
