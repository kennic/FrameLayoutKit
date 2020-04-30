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

Or you can use operand syntax:

```swift
frameLayout += VStackLayout {
	($0 += earthImageView).alignment = (.top, .center)
	($0 --- 0).flexible()
	($0 += rocketImageView).alignment = (.center, .center)
}
frameLayout += VStackLayout {
	$0 ++ [nameLabel, dateLabel]
	$0 --- 10
	$0 += messageLabel
	$0.spacing = 5.0
}

frameLayout.spacing = 15.0
frameLayout.padding(top: 15, left: 15, bottom: 15, right: 15)
frameLayout.debug = true
```

## Code syntax migration

Version 4.x.x introduces new operand syntax as well as VStackLayout and HStackLayout for shorter code.

Old syntax:

```swift
let imageLayout = StackFrameLayout(axis: .vertical)
imageLayout.append(view: earthImageView).contentAlignment = (.top, .center)
imageLayout.appendEmptySpace().isFlexible = true
imageLayout.append(view: rocketImageView).contentAlignment = (.center, .center)

let labelLayout = StackFrameLayout(axis: .vertical, distribution: .top)
labelLayout.append(view: nameLabel)
labelLayout.append(view: dateLabel)
labelLayout.appendEmptySpace(10.0)
labelLayout.append(view: messageLabel)
labelLayout.spacing = 5.0

let frameLayout = StackFrameLayout(axis: .horizontal)
frameLayout.append(frameLayout: imageLayout)
frameLayout.append(frameLayout: contentLayout)

frameLayout.spacing = 15.0
frameLayout.edgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
frameLayout.showFrameDebug = true
```

Nested syntax (v3.9.0):

```swift
frameLayout.append(frameLayout: StackFrameLayout(axis: .vertical).with {
	$0.append(view: earthImageView).contentAlignment = (.top, .center)
	$0.appendEmptySpace().isFlexible = true
	$0.append(view: rocketImageView).contentAlignment = (.center, .center)
})
frameLayout.append(frameLayout: StackFrameLayout(axis: .vertical, distribution: .top).with {
	$0.append(view: nameLabel)
	$0.append(view: dateLabel)
	$0.appendEmptySpace(size: 10.0)
	$0.append(view: messageLabel)
	$0.spacing = 5.0
})

frameLayout.spacing = 15.0
frameLayout.edgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
frameLayout.showFrameDebug = true
```

New standard syntax (since v4.x.x):

```swift
frameLayout.add(VStackLayout {
	$0.add(earthImageView).alignment = (.top, .center)
	$0.addSpace().flexible()
	$0.add(rocketImageView).alignment = (.center, .center)
})
		
frameLayout.add(VStackLayout {
	$0.add([nameLabel, dateLabel])
	$0.addSpace(10)
	$0.add(messageLabel)
	$0.spacing = 5.0
})

frameLayout.spacing = 15.0
frameLayout.padding(top: 15, left: 15, bottom: 15, right: 15)
frameLayout.debug = true
```

Operand syntax (since v4.x.x):

```swift
frameLayout += VStackLayout {
	($0 += earthImageView).alignment = (.top, .center)
	($0 --- 0).flexible()
	($0 += rocketImageView).alignment = (.center, .center)
}
frameLayout += VStackLayout {
	$0 ++ [nameLabel, dateLabel]
	$0 --- 10
	$0 += messageLabel
	$0.spacing = 5.0
}

frameLayout.spacing = 15.0
frameLayout.padding(top: 15, left: 15, bottom: 15, right: 15)
frameLayout.debug = true
```


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
