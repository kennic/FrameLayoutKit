//
//  DoubleFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/17/18.
//

import UIKit

public enum NKLayoutDirection : Int {
    case horizontal = 0 // left - right
    case vertical // top - bottom
    case auto
}

public enum NKLayoutAlignment : Int {
	case top = 0
    case bottom
    public static let left: NKLayoutAlignment = .top
    public static let right: NKLayoutAlignment = .bottom
    case split
    case center
}

open class DoubleFrameLayout: FrameLayout {
	
	public var layoutAlignment: NKLayoutAlignment = .top
	public var layoutDirection: NKLayoutDirection = .auto
	
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
			self.frameLayout1.ignoreHiddenView = ignoreHiddenView
			self.frameLayout2.ignoreHiddenView = ignoreHiddenView
		}
	}
	
	override open var shouldCacheSize: Bool {
		didSet {
			self.frameLayout1.shouldCacheSize = shouldCacheSize
			self.frameLayout2.shouldCacheSize = shouldCacheSize
		}
	}
	
	override open var showFrameDebug: Bool {
		didSet {
			self.frameLayout1.showFrameDebug = showFrameDebug
			self.frameLayout2.showFrameDebug = showFrameDebug
		}
	}
	
	override open var allowContentVerticalGrowing: Bool {
		didSet {
			self.frameLayout1.allowContentVerticalGrowing = allowContentVerticalGrowing
			self.frameLayout2.allowContentVerticalGrowing = allowContentVerticalGrowing
		}
	}
	
	override open var allowContentVerticalShrinking: Bool {
		didSet {
			self.frameLayout1.allowContentVerticalShrinking = allowContentVerticalShrinking
			self.frameLayout2.allowContentVerticalShrinking = allowContentVerticalShrinking
		}
	}
	
	override open var allowContentHorizontalGrowing: Bool {
		didSet {
			self.frameLayout1.allowContentHorizontalGrowing = allowContentHorizontalGrowing
			self.frameLayout2.allowContentHorizontalGrowing = allowContentHorizontalGrowing
		}
	}
	
	override open var allowContentHorizontalShrinking: Bool {
		didSet {
			self.frameLayout1.allowContentHorizontalShrinking = allowContentHorizontalShrinking
			self.frameLayout2.allowContentHorizontalShrinking = allowContentHorizontalShrinking
		}
	}
	
	override open var frame: CGRect {
		didSet {
			self.setNeedsLayout()
		}
	}
	
	override open var bounds: CGRect {
		didSet {
			self.setNeedsLayout()
		}
	}
	
	override open var description: String {
		return "[\(super.description)]\n[frameLayout1: \(String(describing: self.frameLayout1))]\n-[frameLayout2: \(String(describing: self.frameLayout2))]"
	}
	
	// MARK: -
	
	public var frameLayout1: FrameLayout = FrameLayout() {
		didSet {
			if frameLayout1 != oldValue {
				if oldValue.superview == self {
					oldValue.removeFromSuperview()
				}
				
				if frameLayout1 != self {
					self.addSubview(frameLayout1)
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
					self.addSubview(frameLayout2)
				}
			}
		}
	}
	
	public var topFrameLayout: FrameLayout {
		get {
			return self.frameLayout1
		}
		set {
			self.frameLayout1 = newValue
		}
	}
	
	public var leftFrameLayout: FrameLayout {
		get {
			return self.frameLayout1
		}
		set {
			self.frameLayout1 = newValue
		}
	}
	
	public var bottomFrameLayout: FrameLayout {
		get {
			return self.frameLayout2
		}
		set {
			self.frameLayout2 = newValue
		}
	}
	
	public var rightFrameLayout: FrameLayout {
		get {
			return self.frameLayout2
		}
		set {
			self.frameLayout2 = newValue
		}
	}
	
	// MARK: -
	
	convenience public init(direction: NKLayoutDirection, alignment: NKLayoutAlignment = .top, views: [UIView]? = nil) {
		self.init()
		
		self.layoutDirection = direction
		self.layoutAlignment = alignment
		
		defer {
			if let views = views {
				let count = views.count
				
				if count > 0 {
					var targetView = views[0]
					
					if targetView is FrameLayout && targetView.superview == nil {
						self.frameLayout1 = targetView as! FrameLayout
					}
					else {
						self.frameLayout1.targetView = targetView
					}
					
					if count > 1 {
						targetView = views[1]
						
						if targetView is FrameLayout && targetView.superview == nil {
							self.frameLayout2 = targetView as! FrameLayout
						}
						else {
							self.frameLayout2.targetView = targetView
						}
					}
				}
			}
		}
	}
	
	override public init() {
		super.init()
		
		self.addSubview(frameLayout1)
		self.addSubview(frameLayout2)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		
		self.frameLayout1.setNeedsLayout()
		self.frameLayout2.setNeedsLayout()
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
			var space: CGFloat = 0
			var direction: NKLayoutDirection = layoutDirection
			if layoutDirection == .auto {
				direction = size.width < size.height ? .vertical : .horizontal
			}
			
			if direction == .horizontal {
				switch layoutAlignment {
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
					
				case .split:
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
				switch layoutAlignment {
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
					
				case .split:
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
		
		let containerFrame: CGRect = bounds.inset(by: edgeInsets)
		guard containerFrame.size.width > 0 && containerFrame.size.height > 0 else {
			return
		}
		
		var frame1ContentSize: CGSize = .zero
		var frame2ContentSize: CGSize = .zero
		var targetFrame1: CGRect = containerFrame
		var targetFrame2: CGRect = containerFrame
		var space: CGFloat = 0
		var direction: NKLayoutDirection = layoutDirection
		if layoutDirection == .auto {
			let size = self.bounds.size
			direction = size.width < size.height ? .vertical : .horizontal
		}
		
		if direction == .horizontal {
			switch layoutAlignment {
			case .top, .left:
				frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
				targetFrame1.size.width = frame1ContentSize.width
				space = frame1ContentSize.width > 0 ? spacing : 0
				
				frame2ContentSize = CGSize(width: containerFrame.size.width - frame1ContentSize.width - space, height: containerFrame.size.height)
				targetFrame2.origin.x = containerFrame.origin.x + frame1ContentSize.width + space
				targetFrame2.size.width = frame2ContentSize.width
				break
				
			case .bottom, .right:
				frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size)
				targetFrame2.origin.x = containerFrame.origin.x + (containerFrame.size.width - frame2ContentSize.width)
				targetFrame2.size.width = frame2ContentSize.width
				space = frame2ContentSize.width > 0 ? spacing : 0
				
				frame1ContentSize = CGSize(width: containerFrame.size.width - frame2ContentSize.width - space, height: containerFrame.size.height)
				targetFrame1.size.width = frame1ContentSize.width
				break
				
			case .split:
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
				break
				
			case .center:
				frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
				space = frame1ContentSize.width > 0 ? spacing : 0
				
				frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: containerFrame.size.width - frame1ContentSize.width - space, height: containerFrame.size.height))
				
				let totalWidth = frame1ContentSize.width + frame2ContentSize.width + space
				targetFrame1.origin.x = containerFrame.origin.x + (containerFrame.size.width - totalWidth)/2
				targetFrame1.size.width = frame1ContentSize.width
				
				targetFrame2.origin.x = targetFrame1.origin.x + frame1ContentSize.width + space
				targetFrame2.size.width = frame2ContentSize.width
				break
			}
		}
		else {
			switch layoutAlignment {
			case .top, .left:
				frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size, intrinsic: frameLayout1.heightRatio == 0)
				targetFrame1.size.height = frame1ContentSize.height
				space = frame1ContentSize.height > 0 ? spacing : 0
				
				frame2ContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - frame1ContentSize.height - space)
				targetFrame2.origin.y = containerFrame.origin.y + frame1ContentSize.height + space
				targetFrame2.size.height = frame2ContentSize.height
				break
				
			case .bottom, .right:
				frame2ContentSize = frameLayout2.sizeThatFits(containerFrame.size, intrinsic: frameLayout2.heightRatio == 0)
				targetFrame2.origin.y = containerFrame.origin.y + (containerFrame.size.height - frame2ContentSize.height)
				targetFrame2.size.height = frame2ContentSize.height
				space = frame2ContentSize.height > 0 ? spacing : 0
				
				frame1ContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - frame2ContentSize.height - space)
				targetFrame1.size.height = frame1ContentSize.height
				break
				
			case .split:
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
				break
				
			case .center:
				frame1ContentSize = frameLayout1.sizeThatFits(containerFrame.size)
				space = frame1ContentSize.height > 0 ? spacing : 0
				
				frame2ContentSize = frameLayout2.sizeThatFits(CGSize(width: containerFrame.size.width, height: containerFrame.size.height - frame1ContentSize.height - space))
				
				let totalHeight: CGFloat = frame1ContentSize.height + frame2ContentSize.height + space
				targetFrame1.origin.y = containerFrame.origin.y + (containerFrame.size.height - totalHeight)/2
				targetFrame1.size.height = frame1ContentSize.height
				
				targetFrame2.origin.y = targetFrame1.origin.y + frame1ContentSize.height + space
				targetFrame2.size.height = frame2ContentSize.height
				break
			}
		}
		
		frameLayout1.frame = targetFrame1.integral
		frameLayout2.frame = targetFrame2.integral
	}
	
}
