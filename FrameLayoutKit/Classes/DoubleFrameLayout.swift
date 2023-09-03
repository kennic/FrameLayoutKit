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
}

public enum NKLayoutDistribution: Equatable {
	case top
    case bottom
    case equal
	case split(ratio: [CGFloat])
    case center
	
	public static let left: NKLayoutDistribution = .top
	public static let right: NKLayoutDistribution = .bottom
	
	public init(split ratio: CGFloat...) {
		self = .split(ratio: ratio)
	}
}

@propertyWrapper
public struct Clamping<Value: Comparable> {
	var value: Value
	let range: ClosedRange<Value>
	
	public init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
		precondition(range.contains(value))
		self.value = value
		self.range = range
	}
	
	public var wrappedValue: Value {
		get { value }
		set { value = min(max(range.lowerBound, newValue), range.upperBound) }
	}
}

/*
@propertyWrapper
public struct UnitPercentage<Value: FloatingPoint> {
	@Clamping(0...1)
	public var wrappedValue: Value = .zero
	
	public init(wrappedValue value: Value) {
		self.wrappedValue = value
	}
}
*/

open class DoubleFrameLayout<T: UIView>: FrameLayout<T> {
	public var distribution: NKLayoutDistribution = .top
	public var axis: NKLayoutAxis = .vertical
	
	public var spacing: CGFloat = 0 {
		didSet {
			if spacing != oldValue {
				setNeedsLayout()
			}
		}
	}
	
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
	
	override open var debug: Bool {
		didSet {
			super.debug = debug
			frameLayout1.debug = debug
			frameLayout2.debug = debug
		}
	}
	
	override open var debugColor: UIColor?{
		didSet {
			super.debugColor = debugColor
			frameLayout1.debugColor = debugColor
			frameLayout2.debugColor = debugColor
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
		didSet { setNeedsLayout() }
	}
	
	override open var bounds: CGRect {
		didSet { setNeedsLayout() }
	}
	
	override open var description: String {
		return "[\(super.description)]\n[frameLayout1: \(String(describing: frameLayout1))]\n-[frameLayout2: \(String(describing: frameLayout2))]"
	}
	
	// Skeleton
	
	/// set color for skeleton mode
	override public var skeletonColor: UIColor {
		get { frameLayout1.skeletonColor }
		set {
			super.skeletonColor = newValue
			frameLayout1.skeletonColor = newValue
			frameLayout2.skeletonColor = newValue
		}
	}
	override public var skeletonMinSize: CGSize {
		get { frameLayout1.skeletonMinSize }
		set {
			frameLayout1.skeletonMinSize = newValue
			frameLayout2.skeletonMinSize = newValue
		}
	}
	override public var skeletonMaxSize: CGSize {
		get { frameLayout1.skeletonMaxSize }
		set {
			frameLayout1.skeletonMaxSize = newValue
			frameLayout2.skeletonMaxSize = newValue
		}
	}
	override public var isSkeletonMode: Bool {
		didSet {
			frameLayout1.isSkeletonMode = isSkeletonMode
			frameLayout2.isSkeletonMode = isSkeletonMode
		}
	}
	
	// MARK: -
	
	public var frameLayout1: FrameLayout = FrameLayout<T>() {
		didSet {
			guard frameLayout1 != oldValue else { return }
			if oldValue.superview == self { oldValue.removeFromSuperview() }
			if frameLayout1 != self { addSubview(frameLayout1) }
		}
	}
	
	public var frameLayout2: FrameLayout = FrameLayout<T>() {
		didSet {
			guard frameLayout2 != oldValue else { return }
			if oldValue.superview == self { oldValue.removeFromSuperview() }
			if frameLayout2 != self { addSubview(frameLayout2) }
		}
	}
	
	public var topFrameLayout: FrameLayout<T> {
		get { frameLayout1 }
		set { frameLayout1 = newValue }
	}
	
	public var leftFrameLayout: FrameLayout<T> {
		get { frameLayout1 }
		set { frameLayout1 = newValue }
	}
	
	public var bottomFrameLayout: FrameLayout<T> {
		get { frameLayout2 }
		set { frameLayout2 = newValue }
	}
	
	public var rightFrameLayout: FrameLayout<T> {
		get { frameLayout2 }
		set { frameLayout2 = newValue }
	}
	
	public var isOverlapped: Bool = false {
		didSet { setNeedsLayout() }
	}
	
	public override var isUserInteractionEnabled: Bool {
		didSet {
			frameLayout1.isUserInteractionEnabled = isUserInteractionEnabled
			frameLayout2.isUserInteractionEnabled = isUserInteractionEnabled
		}
	}
	
	// MARK: -
	
	@discardableResult
	public convenience init(_ block: (DoubleFrameLayout) throws -> Void) rethrows {
		self.init()
		try block(self)
	}
	
	convenience public init(axis: NKLayoutAxis, distribution: NKLayoutDistribution = .top, views: [T]? = nil) {
		self.init()
		
		self.axis = axis
		self.distribution = distribution
		
		defer {
			if let views {
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
	
	public required init() {
		super.init()
		
		addSubview(frameLayout1)
		addSubview(frameLayout2)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	@discardableResult
	open func setLeft(_ view: T?) -> FrameLayout<T> {
		if let frameLayout = view as? FrameLayout<T>, frameLayout.superview == nil {
			self.frameLayout1 = frameLayout
			return frameLayout
		}
		
		frameLayout1.targetView = view
		return frameLayout1
	}
	
	@discardableResult
	open func setRight(_ view: T?) -> FrameLayout<T> {
		if let frameLayout = view as? FrameLayout<T>, frameLayout.superview == nil {
			self.frameLayout2 = frameLayout
			return frameLayout
		}
		
		frameLayout2.targetView = view
		return frameLayout2
	}
	
	@discardableResult
	open func setTop(_ view: T?) -> FrameLayout<T> {
		return setLeft(view)
	}
	
	@discardableResult
	open func setBottom(_ view: T?) -> FrameLayout<T> {
		return setRight(view)
	}
	
	// MARK: -
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		
		frameLayout1.setNeedsLayout()
		frameLayout2.setNeedsLayout()
	}
	
	open override func sizeThatFits(_ size: CGSize, ignoreHiddenView: Bool) -> CGSize {
		willSizeThatFitsBlock?(self, size)
		
		var result: CGSize = size
		
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			result = minSize
		}
		else if heightRatio > 0 && !isIntrinsicSizeEnabled {
			result.height = result.width * heightRatio
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
			
			if axis == .horizontal {
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
					var ratioValue: CGFloat = 0.5
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
					
				case .split(let ratio):
					var ratioValue: CGFloat = ratio.first ?? 0.5
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
					var ratioValue: CGFloat = 0.5
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
					
				case .split(let ratio):
					var ratioValue: CGFloat = ratio.first ?? 0.5
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
			
			result.limitedTo(minSize: minSize, maxSize: maxSize)
		}
		
		if result.width > 0 { result.width += verticalEdgeValues }
		if result.height > 0 { result.height += horizontalEdgeValues }
		
		result.width = min(result.width, size.width)
		result.height = min(result.height, size.height)
		
		return result
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		defer {
			didLayoutSubviewsBlock?(self)
		}
		
		#if swift(>=4.2)
		let containerFrame: CGRect = bounds.inset(by: edgeInsets)
		#else
		let containerFrame: CGRect = UIEdgeInsetsInsetRect(bounds, edgeInsets)
		#endif
		
		guard !containerFrame.isEmpty else { return }
		
		var frame1ContentSize: CGSize = .zero
		var frame2ContentSize: CGSize = .zero
		var targetFrame1: CGRect = containerFrame
		var targetFrame2: CGRect = containerFrame
		var space: CGFloat = 0
		
		if axis == .horizontal {
			switch distribution {
			case .top, .left:
				frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
				targetFrame1.size.width = frame1ContentSize.width
				
				if isOverlapped {
					if frameLayout2.isIntrinsicSizeEnabled && !frameLayout2.isFlexible {
						frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size)
						targetFrame2.size.width = min(frame2ContentSize.width, containerFrame.width)
					}
					else {
						targetFrame2.size.width = containerFrame.width
					}
				}
				else {
					space = frame1ContentSize.width > 0 ? spacing : 0
					
					frame2ContentSize = CGSize(width: containerFrame.width - frame1ContentSize.width - space, height: containerFrame.height)
					targetFrame2.origin.x = containerFrame.minX + frame1ContentSize.width + space
					targetFrame2.size.width = frame2ContentSize.width
				}
				break
				
			case .bottom, .right:
				frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size, intrinsic: true)
				targetFrame2.origin.x = containerFrame.minX + (containerFrame.width - frame2ContentSize.width)
				targetFrame2.size.width = frame2ContentSize.width
				
				if isOverlapped {
					if frameLayout1.isIntrinsicSizeEnabled && !frameLayout1.isFlexible {
						frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
						targetFrame1.size.width = min(frame1ContentSize.width, containerFrame.width)
						targetFrame1.origin.x = containerFrame.minX + (containerFrame.width - targetFrame1.width)
					}
					else {
						targetFrame1.size.width = containerFrame.width
					}
				}
				else {
					space = frame2ContentSize.width > 0 ? spacing : 0
					
					frame1ContentSize = CGSize(width: containerFrame.width - frame2ContentSize.width - space, height: containerFrame.height)
					targetFrame1.size.width = frame1ContentSize.width
				}
				break
				
			case .equal:
				if isOverlapped {
					targetFrame1 = containerFrame
					targetFrame2 = containerFrame
				}
				else {
					var ratioValue: CGFloat = 0.5
					var spaceValue = spacing
					
					if frameLayout1.isEmpty {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2.isEmpty {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = CGSize(width: (containerFrame.width - spaceValue) * ratioValue, height: containerFrame.height)
					targetFrame1.size.width = frame1ContentSize.width
					space = frame1ContentSize.width > 0 ? spaceValue : 0
					
					frame2ContentSize = CGSize(width: containerFrame.width - frame1ContentSize.width - space, height: containerFrame.height)
					targetFrame2.origin.x = containerFrame.minX + frame1ContentSize.width + space
					targetFrame2.size.width = frame2ContentSize.width
				}
				break
				
			case .split(let ratio):
				if isOverlapped {
					targetFrame1 = containerFrame
					targetFrame2 = containerFrame
				}
				else {
					var ratioValue = ratio.first ?? 0.5
					var spaceValue = spacing
					
					if frameLayout1.isEmpty {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2.isEmpty {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = CGSize(width: (containerFrame.width - spaceValue) * ratioValue, height: containerFrame.height)
					targetFrame1.size.width = frame1ContentSize.width
					space = frame1ContentSize.width > 0 ? spaceValue : 0
					
					frame2ContentSize = CGSize(width: containerFrame.width - frame1ContentSize.width - space, height: containerFrame.height)
					targetFrame2.origin.x = containerFrame.minX + frame1ContentSize.width + space
					targetFrame2.size.width = frame2ContentSize.width
				}
				break
				
			case .center:
				if isOverlapped {
					frame1ContentSize = frameLayout1.isFlexible ? containerFrame.size : frameLayout1.sizeThatFits(containerFrame.size)
					frame2ContentSize = frameLayout2.isFlexible ? containerFrame.size : frameLayout2.sizeThatFits(containerFrame.size)
					targetFrame1.size.width = min(frame1ContentSize.width, containerFrame.width)
					targetFrame2.size.width = min(frame2ContentSize.width, containerFrame.width)
					targetFrame1.origin.x = containerFrame.minX + (containerFrame.width - targetFrame1.width)/2
					targetFrame2.origin.x = containerFrame.minX + (containerFrame.width - targetFrame2.width)/2
				}
				else {
					frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
					space = frame1ContentSize.width > 0 ? spacing : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: containerFrame.width - frame1ContentSize.width - space, height: containerFrame.height))
					
					let totalWidth = frame1ContentSize.width + frame2ContentSize.width + space
					targetFrame1.origin.x = containerFrame.minX + (containerFrame.width - totalWidth)/2
					targetFrame1.size.width = frame1ContentSize.width
					
					targetFrame2.origin.x = targetFrame1.minX + frame1ContentSize.width + space
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
					if frameLayout2.isIntrinsicSizeEnabled && !frameLayout2.isFlexible {
						frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size, intrinsic: frameLayout2.heightRatio == 0)
						targetFrame2.size.height = min(frame2ContentSize.height, containerFrame.height)
					}
					else {
						targetFrame2.size.height = containerFrame.height
					}
				}
				else {
					space = frame1ContentSize.height > 0 ? spacing : 0
					
					frame2ContentSize = CGSize(width: containerFrame.width, height: containerFrame.height - frame1ContentSize.height - space)
					targetFrame2.origin.y = containerFrame.minY + frame1ContentSize.height + space
					targetFrame2.size.height = frame2ContentSize.height
				}
				break
				
			case .bottom, .right:
				frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size, intrinsic: frameLayout2.heightRatio == 0)
				targetFrame2.origin.y = containerFrame.minY + (containerFrame.height - frame2ContentSize.height)
				targetFrame2.size.height = frame2ContentSize.height
				
				if isOverlapped {
					if frameLayout1.isIntrinsicSizeEnabled && !frameLayout1.isFlexible {
						frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size, intrinsic: frameLayout1.heightRatio == 0)
						targetFrame1.size.height = min(frame1ContentSize.height, containerFrame.height)
						targetFrame1.origin.y = containerFrame.minY + (containerFrame.height - targetFrame1.height)
					}
					else {
						targetFrame1.size.height = containerFrame.height
					}
				}
				else {
					space = frame2ContentSize.height > 0 ? spacing : 0
					
					frame1ContentSize = CGSize(width: containerFrame.width, height: containerFrame.height - frame2ContentSize.height - space)
					targetFrame1.size.height = frame1ContentSize.height
				}
				break
				
			case .equal:
				if isOverlapped {
					targetFrame1 = containerFrame
					targetFrame2 = containerFrame
				}
				else {
					var ratioValue: CGFloat = 0.5
					var spaceValue = spacing
					
					if frameLayout1.isEmpty {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2.isEmpty {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = CGSize(width: containerFrame.width, height: (containerFrame.height - spaceValue) * ratioValue)
					targetFrame1.size.height = frame1ContentSize.height
					space = frame1ContentSize.height > 0 ? spaceValue : 0
					
					frame2ContentSize = CGSize(width: containerFrame.width, height: containerFrame.height - frame1ContentSize.height - space)
					targetFrame2.origin.y = containerFrame.minY + targetFrame1.height + space
					targetFrame2.size.height = frame2ContentSize.height
				}
				break
				
			case .split(let ratio):
					if isOverlapped {
						targetFrame1 = containerFrame
						targetFrame2 = containerFrame
					}
					else {
						var ratioValue = ratio.first ?? 0.5
						var spaceValue = spacing
						
						if frameLayout1.isEmpty {
							ratioValue = 0
							spaceValue = 0
						}
						
						if frameLayout2.isEmpty {
							ratioValue = 1
							spaceValue = 0
						}
						
						frame1ContentSize = CGSize(width: containerFrame.width, height: (containerFrame.height - spaceValue) * ratioValue)
						targetFrame1.size.height = frame1ContentSize.height
						space = frame1ContentSize.height > 0 ? spaceValue : 0
						
						frame2ContentSize = CGSize(width: containerFrame.width, height: containerFrame.height - frame1ContentSize.height - space)
						targetFrame2.origin.y = containerFrame.minY + targetFrame1.height + space
						targetFrame2.size.height = frame2ContentSize.height
					}
					break
				
			case .center:
				if isOverlapped {
					frame1ContentSize = frameLayout1.isFlexible ? containerFrame.size : frameLayout1.sizeThatFits(containerFrame.size)
					frame2ContentSize = frameLayout2.isFlexible ? containerFrame.size : frameLayout2.sizeThatFits(containerFrame.size)
					targetFrame1.size.height = min(frame1ContentSize.height, containerFrame.height)
					targetFrame2.size.height = min(frame2ContentSize.height, containerFrame.height)
					targetFrame1.origin.y = containerFrame.minY + (containerFrame.height - targetFrame1.height)/2
					targetFrame2.origin.y = containerFrame.minY + (containerFrame.height - targetFrame2.height)/2
				}
				else {
					frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
					space = frame1ContentSize.height > 0 ? spacing : 0
					
					frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: containerFrame.width, height: containerFrame.height - frame1ContentSize.height - space))
					
					let totalHeight: CGFloat = frame1ContentSize.height + frame2ContentSize.height + space
					targetFrame1.origin.y = containerFrame.minY + (containerFrame.height - totalHeight)/2
					targetFrame1.size.height = frame1ContentSize.height
					
					targetFrame2.origin.y = targetFrame1.minY + frame1ContentSize.height + space
					targetFrame2.size.height = frame2ContentSize.height
				}
				break
			}
		}
		
		frameLayout1.frame = targetFrame1.integral
		frameLayout2.frame = targetFrame2.integral
	}
	
}
