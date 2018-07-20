//
//  StackFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/19/18.
//

import UIKit

public class StackFrameLayout: FrameLayout {
	
	public var layoutAlignment: FrameLayoutAlignment = .top
	public var layoutDirection: FrameLayoutDirection = .auto
	public var isIntrinsicSizeEnabled: Bool = true
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
			for layout in frameLayouts {
				layout.ignoreHiddenView = ignoreHiddenView
			}
		}
	}
	
	override public var shouldCacheSize: Bool {
		didSet {
			for layout in frameLayouts {
				layout.shouldCacheSize = shouldCacheSize
			}
		}
	}
	
	override public var showFrameDebug: Bool {
		didSet {
			for layout in frameLayouts {
				layout.showFrameDebug = showFrameDebug
			}
		}
	}
	
	override public var allowContentVerticalGrowing: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentVerticalGrowing = allowContentVerticalGrowing
			}
		}
	}
	
	override public var allowContentVerticalShrinking: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentVerticalShrinking = allowContentVerticalShrinking
			}
		}
	}
	
	override public var allowContentHorizontalGrowing: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentHorizontalGrowing = allowContentHorizontalGrowing
			}
		}
	}
	
	override public var allowContentHorizontalShrinking: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentHorizontalShrinking = allowContentHorizontalShrinking
			}
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
	
	override public var clipsToBounds: Bool {
		didSet {
			for layout in frameLayouts {
				layout.clipsToBounds = clipsToBounds
			}
		}
	}
	
	public var firstFrameLayout: FrameLayout? {
		get {
			return frameLayouts.first
		}
	}
	
	public var lastFrameLayout: FrameLayout? {
		get {
			return frameLayouts.last
		}
	}
	
	public fileprivate(set) var frameLayouts: [FrameLayout]! = [] {
		willSet {
			removeAll()
		}
	}
	
	// MARK: -
	
	convenience public init(direction: FrameLayoutDirection, alignment: FrameLayoutAlignment = .top, views: [UIView]? = nil) {
		self.init()
		
		self.layoutDirection = direction
		self.layoutAlignment = alignment
		
		if let views = views {
			for view in views {
				if view is FrameLayout && view.superview == nil {
					self.append(frameLayout: view as! FrameLayout)
				}
				else {
					self.append(view: view)
				}
			}
		}
	}
	
	override public init() {
		super.init()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	@discardableResult
	public func append(frameLayout: FrameLayout) -> FrameLayout {
		if frameLayouts.contains(frameLayout) == false {
			frameLayout.showFrameDebug = showFrameDebug
			frameLayouts.append(frameLayout)
		}
		
		self.addSubview(frameLayout)
		return frameLayout
	}
	
	@discardableResult
	public func insert(view: UIView? = nil, at index: Int) -> FrameLayout {
		let frameLayout = FrameLayout(targetView: view)
		frameLayout.showFrameDebug = showFrameDebug
		frameLayouts.insert(frameLayout, at: index)
		return frameLayout
	}
	
	@discardableResult
	public func insert(frameLayout: FrameLayout, at index: Int) -> FrameLayout {
		frameLayout.showFrameDebug = showFrameDebug
		frameLayouts.insert(frameLayout, at: index)
		return frameLayout
	}
	
	public func removeFrameLayout(at index: Int, autoRemoveTargetView: Bool = false) {
		guard index >= 0 && index < frameLayouts.count else {
			return
		}
		
		let frameLayout = frameLayouts[index]
		if frameLayout.superview == self {
			frameLayout.removeFromSuperview()
		}
		
		if autoRemoveTargetView {
			frameLayout.targetView?.removeFromSuperview()
		}
		
		frameLayout.targetView = nil
		frameLayouts.remove(at: index)
	}
	
	public func removeAll(autoRemoveTargetView: Bool = false) {
		for layout in frameLayouts {
			if autoRemoveTargetView {
				layout.targetView?.removeFromSuperview()
			}
			
			layout.targetView = nil
			if layout.superview == self {
				layout.removeFromSuperview()
			}
		}
		
		frameLayouts.removeAll()
	}
	
	@discardableResult
	public func append(view: UIView? = nil) -> FrameLayout {
		let frameLayout = FrameLayout(targetView: view)
		frameLayout.showFrameDebug = showFrameDebug
		frameLayouts.append(frameLayout)
		self.addSubview(frameLayout)
		return frameLayout
	}
	
	@discardableResult
	public func appendEmptySpace(size: CGSize) -> FrameLayout {
		let frameLayout = append()
		frameLayout.fixSize = size
		return frameLayout
	}
	
	public func replace(frameLayout: FrameLayout?, at index: Int) {
		if let frameLayout = frameLayout {
			let count = frameLayouts.count
			var currentFrameLayout: FrameLayout? = nil
			
			if index < count {
				currentFrameLayout = frameLayouts[index]
			}
			
			if let currentFrameLayout = currentFrameLayout, currentFrameLayout != frameLayout {
				if currentFrameLayout.superview == self {
					currentFrameLayout.removeFromSuperview()
				}
				
				frameLayouts.insert(frameLayout, at: index)
				self.addSubview(frameLayout)
			}
			else if index == count {
				self.insert(view: nil, at: index)
			}
		}
		else {
			removeFrameLayout(at: index)
		}
	}
	
	// MARK: -
	
	public func frameLayout(at index: Int) -> FrameLayout? {
		guard index >= 0 && index < frameLayouts.count else {
			return nil
		}
		
		return frameLayouts[index]
	}
	
	public func frameLayout(with view: UIView) -> FrameLayout? {
		var result: FrameLayout? = nil
		
		for layout in frameLayouts {
			if layout.targetView == view {
				result = layout
				break
			}
		}
		
		return result
	}
	
	public func enumerate(block: ((FrameLayout, Int, inout Bool) -> Void)) {
		var stop: Bool = false
		var index = 0
		for layout in frameLayouts {
			block(layout, index, &stop)
			if stop {
				break
			}
			
			index += 1
		}
	}
	
	// MARK: -
	
	override public func setNeedsLayout() {
		super.setNeedsLayout()
		
		for layout in frameLayouts {
			layout.setNeedsLayout()
		}
	}
	
	fileprivate func numberOfVisibleFrames() -> Int {
		var count: Int = 0
		for layout in frameLayouts {
			if layout.isHidden || (layout.targetView?.isHidden ?? true) {
				continue
			}
			
			count += 1
		}
		
		return count
	}
	
	// MARK: -
	
	override public func sizeThatFits(_ size: CGSize) -> CGSize {
		var result: CGSize = .zero
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			result = minSize
		}
		else {
			let contentSize = CGSize(width: max(size.width - verticalEdgeValues, 0), height: max(size.height - horizontalEdgeValues, 0))
			var space: CGFloat = 0
			var usedSpace: CGFloat = 0
			var frameContentSize: CGSize
			
			let isInvertedAlignment = layoutAlignment == .bottom || layoutAlignment == .right
			let layouts: [FrameLayout] = isInvertedAlignment ? frameLayouts.reversed() : frameLayouts
			
			var lastFrameLayout: FrameLayout? = nil
			for layout in layouts {
				if !layout.isHidden && !(layout.targetView?.isHidden ?? true) {
					lastFrameLayout = layout
					break
				}
			}
			
			var direction: FrameLayoutDirection = layoutDirection
			if layoutDirection == .auto {
				direction = size.width < size.height ? .vertical : .horizontal
			}
			
			if direction == .horizontal {
				var maxHeight: CGFloat = 0
				
				switch layoutAlignment {
				case .left, .right, .top, .bottom:
					for frameLayout in frameLayouts {
						if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? true) {
							continue
						}
						
						frameContentSize = CGSize(width: contentSize.width - usedSpace, height: contentSize.height)
						if isIntrinsicSizeEnabled {
							frameContentSize = frameLayout.sizeThatFits(frameContentSize)
						}
						
						space = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
						usedSpace += frameContentSize.width + space
						maxHeight = max(maxHeight, frameContentSize.height)
					}
					break
					
				case .split, .center:
					break
				}
			}
			else {
				switch layoutAlignment {
				case .top, .left:
					break
					
				case .bottom, .right:
					break
					
				case .split:
					break
					
				case .center:
					break
				}
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
	
}
