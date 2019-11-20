//
//  DoubleFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/17/18.
//

import UIKit

public enum NKLayoutAxis {
    case horizontal // left - right
    case vertical // top - bottom
    case auto
}

public enum NKLayoutDistribution {
	case top
    case bottom
    case equal
    case center
	
	public static let left: NKLayoutDistribution = .top
	public static let right: NKLayoutDistribution = .bottom
}

open class DoubleFrameLayout: FrameLayout {
	public var distribution: NKLayoutDistribution = .top
	public var axis: NKLayoutAxis = .auto
	
	@available(*, deprecated, renamed: "axis")
	public var layoutDirection: NKLayoutAxis {
		get {
			return axis
		}
		set {
			axis = newValue
		}
	}
	
	@available(*, deprecated, renamed: "distribution")
	public var layoutAlignment: NKLayoutDistribution {
		get {
			return distribution
		}
		set {
			distribution = newValue
		}
	}
	
	public var spacing: CGFloat = 0 {
		didSet {
			if spacing != oldValue {
				setNeedsLayout()
			}
		}
	}
	public var splitRatio: CGFloat = 0.5
	
	override open var ignoreHiddenView: Bool {
		didSet {
			frameLayout1.ignoreHiddenView = ignoreHiddenView
			frameLayout2.ignoreHiddenView = ignoreHiddenView
		}
	}
	
	override open var shouldCacheSize: Bool {
		didSet {
			frameLayout1.shouldCacheSize = shouldCacheSize
			frameLayout2.shouldCacheSize = shouldCacheSize
		}
	}
	
	override open var showFrameDebug: Bool {
		didSet {
			frameLayout1.showFrameDebug = showFrameDebug
			frameLayout2.showFrameDebug = showFrameDebug
		}
	}
	
	override open var allowContentVerticalGrowing: Bool {
		didSet {
			frameLayout1.allowContentVerticalGrowing = allowContentVerticalGrowing
			frameLayout2.allowContentVerticalGrowing = allowContentVerticalGrowing
		}
	}
	
	override open var allowContentVerticalShrinking: Bool {
		didSet {
			frameLayout1.allowContentVerticalShrinking = allowContentVerticalShrinking
			frameLayout2.allowContentVerticalShrinking = allowContentVerticalShrinking
		}
	}
	
	override open var allowContentHorizontalGrowing: Bool {
		didSet {
			frameLayout1.allowContentHorizontalGrowing = allowContentHorizontalGrowing
			frameLayout2.allowContentHorizontalGrowing = allowContentHorizontalGrowing
		}
	}
	
	override open var allowContentHorizontalShrinking: Bool {
		didSet {
			frameLayout1.allowContentHorizontalShrinking = allowContentHorizontalShrinking
			frameLayout2.allowContentHorizontalShrinking = allowContentHorizontalShrinking
		}
	}
	
	override open var frame: CGRect {
		didSet {
			setNeedsLayout()
		}
	}
	
	override open var bounds: CGRect {
		didSet {
			setNeedsLayout()
		}
	}
	
	override open var description: String {
		return "[\(super.description)]\n[frameLayout1: \(String(describing: frameLayout1))]\n-[frameLayout2: \(String(describing: frameLayout2))]"
	}
	
	// MARK: -
	
	public var frameLayout1: FrameLayout = FrameLayout() {
		didSet {
			if frameLayout1 != oldValue {
				if oldValue.superview == self {
					oldValue.removeFromSuperview()
				}
				
				if frameLayout1 != self {
					addSubview(frameLayout1)
				}
			}
		}
	}
	
	public var frameLayout2: FrameLayout = FrameLayout() {
		didSet {
			if frameLayout2 != oldValue {
				if oldValue.superview == self {
					oldValue.removeFromSuperview()
				}
				
				if frameLayout2 != self {
					addSubview(frameLayout2)
				}
			}
		}
	}
	
	public var topFrameLayout: FrameLayout {
		get {
			return frameLayout1
		}
		set {
			frameLayout1 = newValue
		}
	}
	
	public var leftFrameLayout: FrameLayout {
		get {
			return frameLayout1
		}
		set {
			frameLayout1 = newValue
		}
	}
	
	public var bottomFrameLayout: FrameLayout {
		get {
			return frameLayout2
		}
		set {
			frameLayout2 = newValue
		}
	}
	
	public var rightFrameLayout: FrameLayout {
		get {
			return frameLayout2
		}
		set {
			frameLayout2 = newValue
		}
	}
	
	public var isOverlapped: Bool = false {
		didSet {
			setNeedsLayout()
		}
	}
	
	// MARK: -
	
	@available(*, deprecated, renamed: "init(axis:distribution:views:)")
	convenience public init(direction: NKLayoutAxis, alignment: NKLayoutDistribution = .top, views: [UIView]? = nil) {
		self.init(axis: direction, distribution: alignment, views: views)
	}
	
	convenience public init(axis: NKLayoutAxis, distribution: NKLayoutDistribution = .top, views: [UIView]? = nil) {
		self.init()
		
		self.axis = axis
		self.distribution = distribution
		
		defer {
			if let views = views {
				let count = views.count
				
				if count > 0 {
					var targetView = views[0]
					
					if targetView is FrameLayout && targetView.superview == nil {
						frameLayout1 = targetView as! FrameLayout
					}
					else {
						frameLayout1.targetView = targetView
					}
					
					if count > 1 {
						targetView = views[1]
						
						if targetView is FrameLayout && targetView.superview == nil {
							frameLayout2 = targetView as! FrameLayout
						}
						else {
							frameLayout2.targetView = targetView
						}
						
						#if DEBUG
						if count > 2 {
							print("[\(self)] This DoubleFrameLayout should has only 2 target views, currently set \(count) views. Switch to StackFrameLayout to handle multi views.")
						}
						#endif
					}
				}
			}
		}
	}
	
	override public init() {
		super.init()
		
		addSubview(frameLayout1)
		addSubview(frameLayout2)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		
		frameLayout1.setNeedsLayout()
		frameLayout2.setNeedsLayout()
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		var result: CGSize = size
		
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			result = minSize
		}
		else {
			let contentSize = CGSize(width: max(size.width - verticalEdgeValues, 0), height: max(size.height - horizontalEdgeValues, 0))
			
			var frame1ContentSize: CGSize = .zero
			var frame2ContentSize: CGSize = .zero
			
			if isOverlapped {
				frame1ContentSize = frameLayout1.sizeThatFits(contentSize)
				frame2ContentSize = frameLayout2.sizeThatFits(contentSize)
				
				result.width = isIntrinsicSizeEnabled ? max(frame1ContentSize.width, frame2ContentSize.width) : size.width
				
				if heightRatio > 0 {
					result.height = result.width * heightRatio
				}
				else {
					result.height = max(frame1ContentSize.height, frame2ContentSize.height)
				}
				
				return result
			}
			
			var space: CGFloat = 0
			var direction: NKLayoutAxis = axis
			if axis == .auto {
				direction = size.width < size.height ? .vertical : .horizontal
			}
			
			if direction == .horizontal {
				switch distribution {
				case .left, .top:
					frame1ContentSize = frameLayout1.sizeThatFits(contentSize)
					space = frame1ContentSize.width > 0 ? spacing : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: contentSize.width - frame1ContentSize.width - space, height: contentSize.height), intrinsic: isIntrinsicSizeEnabled || frameLayout2.heightRatio == 0)
					break
					
				case .right, .bottom:
					frame2ContentSize = frameLayout2.sizeThatFits(contentSize)
					space = frame2ContentSize.width > 0 ? spacing : 0
					
					frame1ContentSize = frameLayout1.sizeThatFits(CGSize(width: contentSize.width - frame2ContentSize.width - space, height: contentSize.height), intrinsic: isIntrinsicSizeEnabled || frameLayout1.heightRatio == 0)
					break
					
				case .equal:
					var ratioValue: CGFloat = splitRatio
					var spaceValue: CGFloat = spacing
					
					if frameLayout1.isEmpty {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2.isEmpty {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = frameLayout1.sizeThatFits(CGSize(width: (contentSize.width - spaceValue) * ratioValue, height: contentSize.height), intrinsic: isIntrinsicSizeEnabled || frameLayout1.heightRatio == 0)
					space = frame1ContentSize.width > 0 ? spaceValue : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: contentSize.width - frame1ContentSize.width - space, height: contentSize.height), intrinsic: isIntrinsicSizeEnabled || frameLayout2.heightRatio == 0)
					
					if frame1ContentSize.width > frame2ContentSize.width {
						frame2ContentSize.width = frame1ContentSize.width
						
						if frameLayout2.heightRatio > 0 {
							frame2ContentSize.height = frame2ContentSize.width * heightRatio
						}
					}
					else if frame2ContentSize.width > frame1ContentSize.width {
						frame1ContentSize.width = frame2ContentSize.width
						
						if frameLayout1.heightRatio > 0 {
							frame1ContentSize.height = frame1ContentSize.width * heightRatio
						}
					}
					
					break
					
				case .center:
					frame1ContentSize = frameLayout1.sizeThatFits(contentSize)
					space = frame1ContentSize.width > 0 ? spacing : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: contentSize.width - frame1ContentSize.width - space, height: contentSize.height))
					break
				}
				
				if isIntrinsicSizeEnabled {
					space = frame1ContentSize.width > 0 && frame2ContentSize.width > 0 ? spacing : 0
					result.width = frame1ContentSize.width + frame2ContentSize.width + space
				}
				else {
					result.width = size.width
				}
				
				if heightRatio > 0 {
					result.height = result.width * heightRatio
				}
				else {
					result.height = max(frame1ContentSize.height, frame2ContentSize.height)
				}
			}
			else {
				switch distribution {
				case .top, .left:
					frame1ContentSize = frameLayout1.sizeThatFits(contentSize)
					space = frame1ContentSize.height > 0 ? spacing : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: contentSize.width, height: contentSize.height - frame1ContentSize.height - space))
					
					if frame1ContentSize.width > frame2ContentSize.width {
						if frameLayout2.heightRatio > 0 {
							frame2ContentSize.height = frame1ContentSize.width * heightRatio
						}
					}
					else if frame2ContentSize.width > frame1ContentSize.width {
						if frameLayout1.heightRatio > 0 {
							frame1ContentSize.height = frame2ContentSize.width * heightRatio
						}
					}
					
					break
					
				case .bottom, .right:
					frame2ContentSize = frameLayout2.sizeThatFits(contentSize)
					space = frame2ContentSize.height > 0 ? spacing : 0
					
					frame1ContentSize = frameLayout1.sizeThatFits(CGSize(width: contentSize.width, height: contentSize.height - frame2ContentSize.height - space))
					
					if frame1ContentSize.width > frame2ContentSize.width {
						if frameLayout2.heightRatio > 0 {
							frame2ContentSize.height = frame1ContentSize.width * heightRatio
						}
					}
					else if frame2ContentSize.width > frame1ContentSize.width {
						if frameLayout1.heightRatio > 0 {
							frame1ContentSize.height = frame2ContentSize.width * heightRatio
						}
					}
					
					break
					
				case .equal:
					var ratioValue: CGFloat = splitRatio
					var spaceValue: CGFloat = spacing
					
					if frameLayout1.isEmpty {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2.isEmpty  {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = frameLayout1.sizeThatFits(CGSize(width: contentSize.width, height: (contentSize.height - spaceValue) * ratioValue))
					space = frame1ContentSize.height > 0 ? spaceValue : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: contentSize.width, height: contentSize.height - frame1ContentSize.height - space))
					
					if frameLayout2.heightRatio > 0 {
						if frame1ContentSize.width > frame2ContentSize.width {
							frame2ContentSize.height = frame1ContentSize.width * heightRatio
						}
					}
					
					if frameLayout1.heightRatio > 0 {
						if frame2ContentSize.width > frame1ContentSize.width {
							frame1ContentSize.height = frame2ContentSize.width * heightRatio
						}
					}
					
					if frame1ContentSize.height > frame2ContentSize.height {
						frame2ContentSize.height = frame1ContentSize.height
					}
					else if frame2ContentSize.height > frame1ContentSize.height {
						frame1ContentSize.height = frame2ContentSize.height
					}
					
					break
					
				case .center:
					frame1ContentSize = frameLayout1.sizeThatFits(contentSize)
					frame2ContentSize = frameLayout2.sizeThatFits(contentSize)
					break
				}
				
				result.width = isIntrinsicSizeEnabled ? max(frame1ContentSize.width, frame2ContentSize.width) : size.width
				if heightRatio > 0 {
					result.height = result.width * heightRatio
				}
				else {
					space = frame1ContentSize.height > 0 && frame2ContentSize.height > 0 ? spacing : 0
					result.height = frame1ContentSize.height + frame2ContentSize.height + space
				}
			}
			
			result.width = max(minSize.width, result.width)
			result.height = max(minSize.height, result.height)
			
			if maxSize.width > 0 && maxSize.width >= minSize.width {
				result.width = min(maxSize.width, result.width)
			}
			
			if maxSize.height > 0 && maxSize.height >= minSize.height {
				result.height = min(maxSize.height, result.height)
			}
		}
		
		if result.width > 0 {
			result.width += verticalEdgeValues
		}
		
		if result.height > 0 {
			result.height += horizontalEdgeValues
		}
		
		result.width = min(result.width, size.width)
		result.height = min(result.height, size.height)
		
		return result
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		#if swift(>=4.2)
		let containerFrame: CGRect = bounds.inset(by: edgeInsets)
		#else
		let containerFrame: CGRect = UIEdgeInsetsInsetRect(bounds, edgeInsets)
		#endif
		
		guard containerFrame.size.width > 0 && containerFrame.size.height > 0 else {
			return
		}
		
		var frame1ContentSize: CGSize = .zero
		var frame2ContentSize: CGSize = .zero
		var targetFrame1: CGRect = containerFrame
		var targetFrame2: CGRect = containerFrame
		var space: CGFloat = 0
		var direction: NKLayoutAxis = axis
		if axis == .auto {
			let size = bounds.size
			direction = size.width < size.height ? .vertical : .horizontal
		}
		
		if direction == .horizontal {
			switch distribution {
			case .top, .left:
				frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
				targetFrame1.size.width = frame1ContentSize.width
				
				if isOverlapped {
					if frameLayout2.isIntrinsicSizeEnabled {
						frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size)
						targetFrame2.size.width = min(frame2ContentSize.width, containerFrame.size.width)
					}
					else {
						targetFrame2.size.width = containerFrame.size.width
					}
				}
				else {
					space = frame1ContentSize.width > 0 ? spacing : 0
					
					frame2ContentSize = CGSize(width: containerFrame.size.width - frame1ContentSize.width - space, height: containerFrame.size.height)
					targetFrame2.origin.x = containerFrame.origin.x + frame1ContentSize.width + space
					targetFrame2.size.width = frame2ContentSize.width
				}
				break
				
			case .bottom, .right:
				frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size, intrinsic: true)
				targetFrame2.origin.x = containerFrame.origin.x + (containerFrame.size.width - frame2ContentSize.width)
				targetFrame2.size.width = frame2ContentSize.width
				
				if isOverlapped {
					if frameLayout1.isIntrinsicSizeEnabled {
						frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
						targetFrame1.size.width = min(frame1ContentSize.width, containerFrame.size.width)
						targetFrame1.origin.x = containerFrame.origin.x + (containerFrame.size.width - targetFrame1.size.width)
					}
					else {
						targetFrame1.size.width = containerFrame.size.width
					}
				}
				else {
					space = frame2ContentSize.width > 0 ? spacing : 0
					
					frame1ContentSize = CGSize(width: containerFrame.size.width - frame2ContentSize.width - space, height: containerFrame.size.height)
					targetFrame1.size.width = frame1ContentSize.width
				}
				break
				
			case .equal:
				if isOverlapped {
					targetFrame1 = containerFrame
					targetFrame2 = containerFrame
				}
				else {
					var ratioValue = splitRatio
					var spaceValue = spacing
					
					if frameLayout1.isEmpty {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2.isEmpty {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = CGSize(width: (containerFrame.size.width - spaceValue) * ratioValue, height: containerFrame.size.height)
					targetFrame1.size.width = frame1ContentSize.width
					space = frame1ContentSize.width > 0 ? spaceValue : 0
					
					frame2ContentSize = CGSize(width: containerFrame.size.width - frame1ContentSize.width - space, height: containerFrame.size.height)
					targetFrame2.origin.x = containerFrame.origin.x + frame1ContentSize.width + space
					targetFrame2.size.width = frame2ContentSize.width
				}
				break
				
			case .center:
				if isOverlapped {
					frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
					frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size)
					targetFrame1.size.width = min(frame1ContentSize.width, containerFrame.size.width)
					targetFrame2.size.width = min(frame2ContentSize.width, containerFrame.size.width)
					targetFrame1.origin.x = containerFrame.origin.x + (containerFrame.size.width - targetFrame1.size.width)/2
					targetFrame2.origin.x = containerFrame.origin.x + (containerFrame.size.width - targetFrame2.size.width)/2
				}
				else {
					frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
					space = frame1ContentSize.width > 0 ? spacing : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: containerFrame.size.width - frame1ContentSize.width - space, height: containerFrame.size.height))
					
					let totalWidth = frame1ContentSize.width + frame2ContentSize.width + space
					targetFrame1.origin.x = containerFrame.origin.x + (containerFrame.size.width - totalWidth)/2
					targetFrame1.size.width = frame1ContentSize.width
					
					targetFrame2.origin.x = targetFrame1.origin.x + frame1ContentSize.width + space
					targetFrame2.size.width = frame2ContentSize.width
				}
				break
			}
		}
		else {
			switch distribution {
			case .top, .left:
				frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size, intrinsic: frameLayout1.heightRatio == 0)
				targetFrame1.size.height = frame1ContentSize.height
				
				if isOverlapped {
					if frameLayout2.isIntrinsicSizeEnabled {
						frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size, intrinsic: frameLayout2.heightRatio == 0)
						targetFrame2.size.height = min(frame2ContentSize.height, containerFrame.size.height)
					}
					else {
						targetFrame2.size.height = containerFrame.size.height
					}
				}
				else {
					space = frame1ContentSize.height > 0 ? spacing : 0
					
					frame2ContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - frame1ContentSize.height - space)
					targetFrame2.origin.y = containerFrame.origin.y + frame1ContentSize.height + space
					targetFrame2.size.height = frame2ContentSize.height
				}
				break
				
			case .bottom, .right:
				frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size, intrinsic: frameLayout2.heightRatio == 0)
				targetFrame2.origin.y = containerFrame.origin.y + (containerFrame.size.height - frame2ContentSize.height)
				targetFrame2.size.height = frame2ContentSize.height
				
				if isOverlapped {
					if frameLayout1.isIntrinsicSizeEnabled {
						frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size, intrinsic: frameLayout1.heightRatio == 0)
						targetFrame1.size.height = min(frame1ContentSize.height, containerFrame.size.height)
						targetFrame1.origin.y = containerFrame.origin.y + (containerFrame.size.height - targetFrame1.size.height)
					}
					else {
						targetFrame1.size.height = containerFrame.size.height
					}
				}
				else {
					space = frame2ContentSize.height > 0 ? spacing : 0
					
					frame1ContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - frame2ContentSize.height - space)
					targetFrame1.size.height = frame1ContentSize.height
				}
				break
				
			case .equal:
				if isOverlapped {
					targetFrame1 = containerFrame
					targetFrame2 = containerFrame
				}
				else {
					var ratioValue = splitRatio
					var spaceValue = spacing
					
					if frameLayout1.isEmpty {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2.isEmpty {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = CGSize(width: containerFrame.size.width, height: (containerFrame.size.height - spaceValue) * ratioValue)
					targetFrame1.size.height = frame1ContentSize.height
					space = frame1ContentSize.height > 0 ? spaceValue : 0
					
					frame2ContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - frame1ContentSize.height - space)
					targetFrame2.origin.y = containerFrame.origin.y + targetFrame1.size.height + space
					targetFrame2.size.height = frame2ContentSize.height
				}
				break
				
			case .center:
				if isOverlapped {
					frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
					frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size)
					targetFrame1.size.height = min(frame1ContentSize.height, containerFrame.size.height)
					targetFrame2.size.height = min(frame2ContentSize.height, containerFrame.size.height)
					targetFrame1.origin.y = containerFrame.origin.y + (containerFrame.size.height - targetFrame1.size.height)/2
					targetFrame2.origin.y = containerFrame.origin.y + (containerFrame.size.height - targetFrame2.size.height)/2
				}
				else {
					frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
					space = frame1ContentSize.height > 0 ? spacing : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: containerFrame.size.width, height: containerFrame.size.height - frame1ContentSize.height - space))
					
					let totalHeight: CGFloat = frame1ContentSize.height + frame2ContentSize.height + space
					targetFrame1.origin.y = containerFrame.origin.y + (containerFrame.size.height - totalHeight)/2
					targetFrame1.size.height = frame1ContentSize.height
					
					targetFrame2.origin.y = targetFrame1.origin.y + frame1ContentSize.height + space
					targetFrame2.size.height = frame2ContentSize.height
				}
				break
			}
		}
		
		frameLayout1.frame = targetFrame1.integral
		frameLayout2.frame = targetFrame2.integral
	}
	
}
