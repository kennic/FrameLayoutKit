//
//  DoubleFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/17/18.
//

import UIKit

public enum LayoutDirection : Int {
    case horizontal = 0 // left - right
    case vertical // top - bottom
    case auto
}

public enum LayoutAlignment : Int {
	case top = 0
    case bottom
    public static let left: LayoutAlignment = .top
    public static let right: LayoutAlignment = .bottom
    case split
    case center
}

public class DoubleFrameLayout: FrameLayout {
	
	public var layoutAlignment: LayoutAlignment = .top
	public var layoutDirection: LayoutDirection = .auto
	public var isIntrinsicSizeEnabled: Bool = false
	public var spacing: CGFloat = 0 {
		didSet {
			if spacing != oldValue {
				setNeedsLayout()
			}
		}
	}
	public var splitRatio: CGFloat = 0.5
	
	override public var ignoreHiddenView: Bool {
		didSet {
			self.frameLayout1?.ignoreHiddenView = ignoreHiddenView
			self.frameLayout2?.ignoreHiddenView = ignoreHiddenView
		}
	}
	
	override public var shouldCacheSize: Bool {
		didSet {
			self.frameLayout1?.shouldCacheSize = shouldCacheSize
			self.frameLayout2?.shouldCacheSize = shouldCacheSize
		}
	}
	
	override public var allowContentVerticalGrowing: Bool {
		didSet {
			self.frameLayout1?.allowContentVerticalGrowing = allowContentVerticalGrowing
			self.frameLayout2?.allowContentVerticalGrowing = allowContentVerticalGrowing
		}
	}
	
	override public var allowContentVerticalShrinking: Bool {
		didSet {
			self.frameLayout1?.allowContentVerticalShrinking = allowContentVerticalShrinking
			self.frameLayout2?.allowContentVerticalShrinking = allowContentVerticalShrinking
		}
	}
	
	override public var allowContentHorizontalGrowing: Bool {
		didSet {
			self.frameLayout1?.allowContentHorizontalGrowing = allowContentHorizontalGrowing
			self.frameLayout2?.allowContentHorizontalGrowing = allowContentHorizontalGrowing
		}
	}
	
	override public var allowContentHorizontalShrinking: Bool {
		didSet {
			self.frameLayout1?.allowContentHorizontalShrinking = allowContentHorizontalShrinking
			self.frameLayout2?.allowContentHorizontalShrinking = allowContentHorizontalShrinking
		}
	}
	
	override public var frame: CGRect {
		didSet {
			self.setNeedsLayout()
		}
	}
	
	override public var bounds: CGRect {
		didSet {
			self.setNeedsLayout()
		}
	}
	
	// MARK: -
	
	public var frameLayout1: FrameLayout? = nil {
		didSet {
			if frameLayout1 != oldValue {
				if let oldFrameLayout = oldValue, oldFrameLayout.superview == self {
					oldFrameLayout.removeFromSuperview()
				}
				
				if frameLayout1 != nil && frameLayout1 != self {
					self.addSubview(frameLayout1!)
				}
			}
		}
	}
	
	public var frameLayout2: FrameLayout? = nil {
		didSet {
			if frameLayout2 != oldValue {
				if let oldFrameLayout = oldValue, oldFrameLayout.superview == self {
					oldFrameLayout.removeFromSuperview()
				}
				
				if frameLayout2 != nil && frameLayout2 != self {
					self.addSubview(frameLayout2!)
				}
			}
		}
	}
	
	public var topFrameLayout: FrameLayout? {
		get {
			return self.frameLayout1
		}
		set {
			self.frameLayout1 = newValue
		}
	}
	
	public var leftFrameLayout: FrameLayout? {
		get {
			return self.frameLayout1
		}
		set {
			self.frameLayout1 = newValue
		}
	}
	
	public var bottomFrameLayout: FrameLayout? {
		get {
			return self.frameLayout2
		}
		set {
			self.frameLayout2 = newValue
		}
	}
	
	public var rightFrameLayout: FrameLayout? {
		get {
			return self.frameLayout2
		}
		set {
			self.frameLayout2 = newValue
		}
	}
	
	// MARK: -
	
	convenience public init(direction: LayoutDirection, alignment: LayoutAlignment = .top, views: [UIView]? = nil) {
		self.init()
		
		self.layoutDirection = direction
		self.layoutAlignment = alignment
		
		if let views = views {
			let count = views.count
			
			if count > 0 {
				var targetView = views[0]
				
				if targetView is FrameLayout && targetView.superview == nil {
					self.frameLayout1 = targetView as? FrameLayout
				}
				else {
					self.frameLayout1?.targetView = targetView
				}
				
				if count > 1 {
					targetView = views[1]
					
					if targetView is FrameLayout && targetView.superview == nil {
						self.frameLayout2 = targetView as? FrameLayout
					}
					else {
						self.frameLayout2?.targetView = targetView
					}
				}
			}
		}
	}
	
	override public init() {
		super.init()
		
		frameLayout1 = FrameLayout()
		frameLayout2 = FrameLayout()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	override public func setNeedsLayout() {
		super.setNeedsLayout()
		self.frameLayout1?.setNeedsLayout()
		self.frameLayout2?.setNeedsLayout()
	}
	
	override public func sizeThatFits(_ size: CGSize) -> CGSize {
		var result: CGSize = .zero
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
			var direction: LayoutDirection = layoutDirection
			if layoutDirection == .auto {
				direction = size.width < size.height ? .vertical : .horizontal
			}
			
			if direction == .horizontal {
				switch layoutAlignment {
				case .left, .top:
					frame1ContentSize = frameLayout1?.sizeThatFits(contentSize) ?? .zero
					space = frame1ContentSize.width > 0 ? spacing : 0
					
					frame2ContentSize = CGSize(width: contentSize.width - frame1ContentSize.width - space, height: contentSize.height)
					frame2ContentSize = frameLayout2?.sizeThatFits(frame2ContentSize) ?? .zero
					break
					
				case .right, .bottom:
					frame2ContentSize = frameLayout2?.sizeThatFits(contentSize) ?? .zero
					space = frame2ContentSize.width > 0 ? spacing : 0
					
					frame1ContentSize = CGSize(width: contentSize.width - frame2ContentSize.width - space, height: contentSize.height)
					frame1ContentSize = frameLayout1?.sizeThatFits(frame1ContentSize) ?? .zero
					break
					
				case .split:
					var ratioValue: CGFloat = splitRatio
					var spaceValue: CGFloat = spacing
					
					if frameLayout1?.isEmpty ?? true {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2?.isEmpty ?? true {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = CGSize(width: (contentSize.width - spaceValue) * ratioValue, height: contentSize.height)
					frame1ContentSize = frameLayout1?.sizeThatFits(frame1ContentSize) ?? .zero
					space = frame1ContentSize.width > 0 ? spaceValue : 0
					
					frame2ContentSize = CGSize(width: contentSize.width - frame1ContentSize.width - space, height: contentSize.height)
					frame2ContentSize = frameLayout2?.sizeThatFits(frame2ContentSize) ?? .zero
					break
					
				case .center:
					frame1ContentSize = frameLayout1?.sizeThatFits(contentSize) ?? .zero
					space = frame1ContentSize.width > 0 ? spacing : 0
					
					frame2ContentSize = CGSize(width: contentSize.width - frame1ContentSize.width - space, height: contentSize.height)
					frame2ContentSize = frameLayout2?.sizeThatFits(frame2ContentSize) ?? .zero
					break
				}
				
				if isIntrinsicSizeEnabled {
					space = frame1ContentSize.width > 0 && frame2ContentSize.width > 0 ? spacing : 0
					result.width = frame1ContentSize.width + frame2ContentSize.width + space
				}
				else {
					result.width = size.width
				}
				
				result.height = max(frame1ContentSize.height, frame2ContentSize.height)
			}
			else {
				switch layoutAlignment {
				case .top, .left:
					frame1ContentSize = frameLayout1?.sizeThatFits(contentSize) ?? .zero
					space = frame1ContentSize.height > 0 ? spacing : 0
					
					frame2ContentSize = CGSize(width: contentSize.width, height: contentSize.height - frame1ContentSize.height - space)
					frame2ContentSize = frameLayout2?.sizeThatFits(frame2ContentSize) ?? .zero
					break
					
				case .bottom, .right:
					frame2ContentSize = frameLayout2?.sizeThatFits(contentSize) ?? .zero
					space = frame2ContentSize.height > 0 ? spacing : 0
					
					frame1ContentSize = CGSize(width: contentSize.width, height: contentSize.height - frame2ContentSize.height - space)
					frame1ContentSize = frameLayout1?.sizeThatFits(frame1ContentSize) ?? .zero
					break
					
				case .split:
					var ratioValue: CGFloat = splitRatio
					var spaceValue: CGFloat = spacing
					
					if frameLayout1?.isEmpty ?? true {
						ratioValue = 0
						spaceValue = 0
					}
					
					if frameLayout2?.isEmpty ?? true {
						ratioValue = 1
						spaceValue = 0
					}
					
					frame1ContentSize = CGSize(width: contentSize.width, height: (contentSize.height - spaceValue) * ratioValue)
					frame1ContentSize = frameLayout1?.sizeThatFits(frame1ContentSize) ?? .zero
					space = frame1ContentSize.height > 0 ? spaceValue : 0
					
					frame2ContentSize = CGSize(width: contentSize.width, height: contentSize.height - frame1ContentSize.height - space)
					frame2ContentSize = frameLayout2?.sizeThatFits(frame2ContentSize) ?? .zero
					break
					
				case .center:
					frame1ContentSize = frameLayout1?.sizeThatFits(contentSize) ?? .zero
					frame2ContentSize = frameLayout2?.sizeThatFits(contentSize) ?? .zero
					break
				}
				
				result.width = isIntrinsicSizeEnabled ? max(frame1ContentSize.width, frame2ContentSize.width) : size.width
				space = frame1ContentSize.height > 0 && frame2ContentSize.height > 0 ? spacing : 0
				result.height = frame1ContentSize.height + frame2ContentSize.height + space
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
	
	// MARK: -
	
}
