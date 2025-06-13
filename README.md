# FrameLayoutKit

[![Platform](https://img.shields.io/cocoapods/p/FrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/FrameLayoutKit)
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/FrameLayoutKit.svg?style=flat-square)](http://cocoapods.org/pods/FrameLayoutKit)
[![SwiftPM Compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/cocoapods/l/FrameLayoutKit.svg?style=flat-square)](http://cocoapods.org/pods/FrameLayoutKit)

![image](images/banner.jpg)

A super fast and easy-to-use layout library for iOS. FrameLayoutKit supports complex layouts, including chaining and nesting layout with simple and intuitive operand syntax.

It simplifies the UI creation process, resulting in cleaner and more maintainable code.

## Why Use FrameLayoutKit?

Say NO to autolayout constraint nightmare:

<table>
<tr><td> Autolayout </td> <td> FrameLayoutKit </td></tr>
<tr>
<td>
<img alt="No" src="images/no_constraint.png">
</td>
<td>
<img alt="Yes!!!" src="images/frameLayoutSyntax.png">
</td>
</tr>
</table>

## Table of Contents

-   [Installation](#installation)
-   [Core Components](#core-components)
-   [Basic Usage](#basic-usage)
-   [DSL Syntax](#dsl-syntax)
-   [Examples](#examples)
-   [Performance](#performance)
-   [Requirements](#requirements)
-   [Author](#author)
-   [License](#license)

## Installation

FrameLayoutKit is available through `Swift Package Manager` (Recommended) and [CocoaPods](http://cocoapods.org):

Regardless of the method, make sure to import the framework into your project:

```swift
import FrameLayoutKit
```

### Swift Package Manager (Recommended)

[Swift Package Manager](https://swift.org/package-manager/) is recommended to install FrameLayoutKit.

1.  Click `File`
2.  `Add Packages...`
3.  Enter the git URL for FrameLayoutKit:

```swift
https://github.com/kennic/FrameLayoutKit.git
```

### CocoaPods

FrameLayoutKit can also be installed as a [CocoaPod](https://cocoapods.org/). To install, add the following line to your Podfile:

```ruby
pod "FrameLayoutKit"
```

## Core Components

![image](images/FrameLayoutKit.png)

FrameLayoutKit includes the following core components:

### FrameLayout

The most basic class, manages a single view and adjusts its size and position based on configured properties.

### StackFrameLayout

Manages multiple views in rows (horizontal) or columns (vertical), similar to `UIStackView` but with higher performance and more options.

-   **HStackLayout**: Horizontal layout
-   **VStackLayout**: Vertical layout
-   **ZStackLayout**: Stacked layout (z-index)

### GridFrameLayout

Arranges views in a grid, with customizable number of columns and rows.

### FlowFrameLayout

Arranges views in a flow, automatically wrapping to the next line when there's not enough space.

### DoubleFrameLayout

Manages two views with various layout options.

### ScrollStackView

Combines `UIScrollView` with `StackFrameLayout` to create a scrollview that can automatically layout its child views.

## Tutorial and Documentation:
[See Tutorial by Codebase2Tutorial (Recommended)](https://code2tutorial.com/tutorial/9a53c8b4-8655-4b7f-a43a-121377744541/index.md)

[Read full document by DeepWiki](https://deepwiki.com/kennic/FrameLayoutKit)

## Basic Usage

### Creating and Configuring Layouts

```swift
// Create a vertical layout
let vStackLayout = VStackLayout()
vStackLayout.spacing = 10
vStackLayout.distribution = .center
vStackLayout.padding(top: 20, left: 20, bottom: 20, right: 20)

// Add views to the layout
vStackLayout.add(view1)
vStackLayout.add(view2)
vStackLayout.add(view3)

// Add the layout to a parent view
parentView.addSubview(vStackLayout)

// Update the layout's frame
vStackLayout.frame = parentView.bounds
```

### Using Operator Syntax (Recommended)

FrameLayoutKit provides the `+` operator syntax to easily add views to layouts:

```swift
// Add a single view
vStackLayout + view1

// Add an array of views
vStackLayout + [view1, view2, view3]

// Add spacing
vStackLayout + 10 // Add 10pt spacing

// Add a child layout
vStackLayout + hStackLayout
```

### Configuring View Properties

```swift
// Configure alignment
(vStackLayout + view1).alignment = (.center, .fill)

// Configure fixed size
(vStackLayout + view2).fixedSize = CGSize(width: 100, height: 50)

// Add a flexible view (can expand)
(vStackLayout + view3).flexible()
```

### Chained Syntax (Recommended)

```swift
vStackLayout
    .distribution(.center)
    .spacing(16)
    .flexible()
    .fixedHeight(50)
    .aligns(.top, .center)
    .padding(top: 20, left: 20, bottom: 20, right: 20)
```

## DSL Syntax (Experimental)

FrameLayoutKit provides a DSL (Domain Specific Language) syntax similar to SwiftUI, making layout creation more intuitive and readable:

```swift
// Create VStackLayout with DSL syntax
let vStackLayout = VStackView {
    titleLabel
    descriptionLabel
    SpaceItem(20) // Add a 20pt space
    Item(actionButton).minWidth(120) // Customize the button's minimum width
}

// Create HStackLayout with DSL syntax
let hStackLayout = HStackView {
    StackItem(imageView).fixedSize(width: 50, height: 50)
    VStackView {
        titleLabel
        subtitleLabel
    }.spacing(5)
    FlexibleSpace() // Add flexible space
    StackItem(button).align(vertical: .center, horizontal: .right)
}
```

### Main DSL Components

-   **StackItem**: Wraps a view to add to a stack with additional options
-   **SpaceItem**: Adds fixed spacing
-   **FlexibleSpace**: Adds flexible spacing (can expand)
-   **Item**: Similar to StackItem but with more options

## Examples

Here are some examples of how FrameLayoutKit works:

<table>
<tr><td> Source </td> <td> Result </td></tr>
<tr>
<td>
	
```swift
let frameLayout = HStackLayout()
frameLayout + VStackLayout {
   ($0 + earthImageView).alignment = (.top, .center)
   ($0 + 0).flexible() // add a flexible space
   ($0 + rocketImageView).alignment = (.center, .center)
}
frameLayout + VStackLayout {
   $0 + [nameLabel, dateLabel] // add an array of views
   $0 + 10 // add a space with a minimum of 10 pixels
   $0 + messageLabel // add a single view
}.spacing(5.0)

frameLayout
.spacing(15)
.padding(top: 15, left: 15, bottom: 15, right: 15)
.debug(true) // show dashed lines to visualize the layout

````
</td>
<td>
<img alt="result 1" src="images/helloWorld.png">
</td>
</tr>
</table>

<table>
<tr><td> Source </td> <td> Result </td></tr>
<tr>
<td>

```swift
let frameLayout = VStackLayout {
  ($0 + imageView).flexible()
  $0 + VStackLayout {
     $0 + titleLabel
     $0 + ratingLabel
  }
}.padding(top: 12, left: 12, bottom: 12, right: 12)
 .distribution(.bottom)
 .spacing(5)
````

</td>
<td>
<img alt="result 1" src="images/example_1.png">
</td>
</tr>
</table>

<table>
<tr><td> Source </td> <td> Result </td></tr>
<tr>
<td>

```swift
let posterSize = CGSize(width: 100, height: 150)
let frameLayout = ZStackLayout()
frameLayout + backdropImageView
frameLayout + VStackLayout {
 $0 + HStackLayout {
  ($0 + posterImageView).fixedSize(posterSize)
    $0 + VStackLayout {
      $0 + titleLabel
      $0 + subtitleLabel
    }.padding(bottom: 5).flexible().distribution(.bottom)
  }.spacing(12).padding(top: 0, left: 12, bottom: 12, right: 12)
}.distribution(.bottom)
```

</td>
<td>
<img alt="result 2" src="images/example_2.png">
</td>
</tr>
</table>

<table>
<tr><td> Source </td> <td> Result </td></tr>
<tr>
<td>

```swift
let buttonSize = CGSize(width: 45, height: 45)
let cardView = VStackLayout()
  .spacing(10)
  .padding(top: 24, left: 24, bottom: 24, right: 24)

cardView + titleLabel
(cardView + emailField).minHeight = 50
(cardView + passwordField).minHeight = 50
(cardView + nextButton).fixedHeight = 45
(cardView + separateLine)
  .fixedContentHeight(1)
  .padding(top: 4, left: 0, bottom: 4, right: 40)
cardView + HStackLayout {
 ($0 + [facebookButton, googleButton, appleButton])
  .forEach { $0.fixedContentSize(buttonSize) }
}.distribution(.center).spacing(10)
```

</td>
<td>
<img alt="result 2" src="images/example_3.png">
</td>
</tr>
</table>

## Key Properties

### FrameLayout

-   **targetView**: The view managed by this layout
-   **edgeInsets**: Padding around the view
-   **contentAlignment**: Content alignment (top, center, bottom, left, right, fill, fit)
-   **Size & Content Size**:
    -   `minSize/maxSize`, `fixedSize`: Minimum/maximum/fixed size of the layout.
    -   `minContentSize/maxContentSize`, `fixedContentSize`: Minimum/maximum/fixed size of the `targetView`.
    -   `extendSize (extendWidth, extendHeight)`: Additional size for the `contentSize`.
    -   `heightRatio`: Defines height based on width.
    -   `isIntrinsicSizeEnabled`: Controls if `sizeThatFits` uses `targetView`'s intrinsic size.
-   **Flexibility & Layout Behavior**:
    -   `isFlexible`, `flexibleRatio`: For flexible layouts within a stack.
    -   `allowContentVerticalGrowing/Shrinking`, `allowContentHorizontalGrowing/Shrinking`: Controls how `targetView` adapts to `FrameLayout`'s bounds.
-   **View Hierarchy & State**:
    -   `parent`: The containing `FrameLayout`.
    -   `bindingViews`, `bindingEdgeInsets`, `lazyBindingViews`: For binding other views to `targetView`'s frame.
    -   `ignoreHiddenView`, `isEnabled`, `isEmpty`: Control layout behavior based on visibility and enabled state.
-   **Positioning**:
    -   `translationOffset (translationX, translationY)`: For manual position adjustments.
-   **Callbacks**:
    -   `willSizeThatFitsBlock`: A block that will be called before `sizeThatFits` is called.
    -   `willLayoutSubviewsBlock`: A block that will be called before `layoutSubviews` is called.
    -   `didLayoutSubviewsBlock`: A block that will be called after `layoutSubviews` has finished.
-   **Debugging**:
    -   `debug`, `debugColor`: For visualizing layout frames.
-   **Skeleton Mode**:
    -   `isSkeletonMode`, `skeletonView`, `skeletonColor`, `skeletonMinSize`, `skeletonMaxSize`: For displaying placeholder content.
-   **Performance**:
    -   `shouldCacheSize`: Caches `sizeThatFits` results.

### StackFrameLayout

-   **Core Layout & Distribution**:
    -   `axis`: Direction of the stack (vertical or horizontal). You can use `VStackLayout` (vertical axis), `HStackLayout` (horizontal axis).
    -   `distribution`: How child views are distributed and space is allocated (e.g., `top`, `center`, `bottom`, `left`, `right`, `fill`, `equal`, `split`).
    -   `spacing`: Space between child views.
    -   `isOverlapped`: Allows child views to overlap. `ZStackLayout` automatically sets this to `true`.
    -   `isJustified`, `justifyThreshold`: Enables even distribution of child views. `justifyThreshold` is the minimum remaining space required to trigger justification.
-   **Child Item Management**:
    -   `frameLayouts`: Array of child `FrameLayout`s.
    -   `numberOfFrameLayouts`: Get or set the number of child layouts.
    -   `firstFrameLayout`, `lastFrameLayout`: Access the first and last child layout.
    -   `frameLayout(at: Int)`, `frameLayout(with: UIView)`: Retrieve specific child layouts.
    -   `enumerate(_ block: (FrameLayout, Int, inout Bool) -> Void)`: Iterate over child layouts.
    -   *Item Management Methods*: Includes functions like `add()`, `insert()`, `removeFrameLayout()`, `removeAll()`, `replace()`, `addSpace()`, and `invert()` for managing child items.
    -   `setUserInteraction(enabled: Bool)`: Sets `isUserInteractionEnabled` for the stack and all its child layouts.
-   **Child Item Defaults & Property Propagation**:
    -   `minItemSize`, `maxItemSize`, `fixedItemSize`: Sets default min/max/fixed content size for all child `FrameLayout`s added to the stack.
    -   *Property Propagation*: Many common `FrameLayout` properties (e.g., `ignoreHiddenView`, `allowContent...Growing/Shrinking`, `debug`, `skeletonMode`, `clipsToBounds`, `shouldCacheSize`) when set on a `StackFrameLayout` are propagated to its child `FrameLayout`s.

## Performance

FrameLayoutKit is one of the fastest layout libraries.
![Benchmark Results](images/bechmark.png "Benchmark results")

See: [Layout libraries benchmark's project](https://github.com/layoutBox/LayoutFrameworkBenchmark)

## Requirements

-   iOS 11.0+
-   Swift 5.0+

## Author

Nam Kennic, namkennic@me.com

## License

FrameLayoutKit is available under the MIT license. See the LICENSE file for more info.
