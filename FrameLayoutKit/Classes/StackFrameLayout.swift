//
//  StackFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/19/18.
//

import UIKit

public class StackFrameLayout: FrameLayout {
	
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
	
	public fileprivate(set) var frameLayouts: [FrameLayout]! = []
	
	public var numberOfFrameLayouts: Int {
		get {
			return frameLayouts.count
		}
		set {
			let count = frameLayouts.count
			
			if newValue == 0 {
				removeAll()
				return
			}
			
			if newValue < count {
				while frameLayouts.count > newValue {
					removeFrameLayout(at: frameLayouts.count - 1)
				}
			}
			else if newValue > count {
				while frameLayouts.count < newValue {
					append()
				}
			}
		}
	}
	
	// MARK: -
	
	convenience public init(direction: NKLayoutDirection, alignment: NKLayoutAlignment = .top, views: [UIView]? = nil) {
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
		
		isIntrinsicSizeEnabled = true
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	@discardableResult
	public func append(frameLayout: FrameLayout) -> FrameLayout {
		frameLayouts.append(frameLayout)
		self.addSubview(frameLayout)
		return frameLayout
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
	public func appendEmptySpace(size: CGSize = .zero) -> FrameLayout {
		let frameLayout = append(view: UIView())
		frameLayout.fixSize = size
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
			if layout.isHidden || (layout.targetView?.isHidden ?? false) {
				continue
			}
			
			count += 1
		}
		
		return count
	}
	
	// MARK: -
	
	override public func sizeThatFits(_ size: CGSize) -> CGSize {
		var result: CGSize = size
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			result = minSize
		}
		else {
			let contentSize = CGSize(width: max(size.width - verticalEdgeValues, 0), height: max(size.height - horizontalEdgeValues, 0))
			var space: CGFloat = 0
			var totalSpace: CGFloat = 0
			var frameContentSize: CGSize
			
			let isInvertedAlignment = layoutAlignment == .bottom || layoutAlignment == .right
			let invertedLayoutArray: [FrameLayout] = frameLayouts.reversed()
			
			var lastFrameLayout: FrameLayout? = nil
			for layout in (isInvertedAlignment ? frameLayouts : invertedLayoutArray) {
				if !layout.isHidden && !(layout.targetView?.isHidden ?? false) {
					lastFrameLayout = layout
					break
				}
			}
			
			var direction: NKLayoutDirection = layoutDirection
			if layoutDirection == .auto {
				direction = size.width < size.height ? .vertical : .horizontal
			}
			
			if direction == .horizontal {
				var maxHeight: CGFloat = 0
				
				switch layoutAlignment {
				case .left, .right, .top, .bottom:
					for frameLayout in frameLayouts {
						if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
							continue
						}
						
						frameContentSize = CGSize(width: contentSize.width - totalSpace, height: contentSize.height)
						if isIntrinsicSizeEnabled {
							frameContentSize = frameLayout.sizeThatFits(frameContentSize)
						}
						
						space = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
						totalSpace += frameContentSize.width + space
						maxHeight = max(maxHeight, frameContentSize.height)
					}
					break
					
				case .split, .center:
					frameContentSize = CGSize(width: contentSize.width / CGFloat(numberOfVisibleFrames()), height: contentSize.height)
					for frameLayout in frameLayouts {
						if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
							continue
						}
						
						frameContentSize = frameLayout.sizeThatFits(frameContentSize)
						
						space = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
						totalSpace += frameContentSize.width + space
						maxHeight = max(maxHeight, frameContentSize.height)
					}
					break
				}
				
				if isIntrinsicSizeEnabled {
					result.width = totalSpace
				}
				
				result.height = min(maxHeight, size.height)
			}
			else {
				var maxWidth: CGFloat = 0
				
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					frameContentSize = CGSize(width: contentSize.width, height: contentSize.height - totalSpace)
					if isIntrinsicSizeEnabled {
						frameContentSize = frameLayout.sizeThatFits(frameContentSize)
					}
					
					space = frameContentSize.height > 0 && frameLayout != lastFrameLayout ? spacing : 0
					totalSpace += frameContentSize.height + space
					maxWidth = max(maxWidth, frameContentSize.width)
				}
				
				if isIntrinsicSizeEnabled {
					result.width = maxWidth
				}
				result.height = min(totalSpace, size.height)
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
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		if bounds.size == .zero {
			return
		}
		
		let containerFrame = UIEdgeInsetsInsetRect(bounds, edgeInsets)
		var space: CGFloat = 0
		var usedSpace: CGFloat = 0
		var frameContentSize: CGSize = .zero
		var targetFrame = containerFrame
		
		let isInvertedAlignment = layoutAlignment == .bottom || layoutAlignment == .right
		let invertedLayoutArray: [FrameLayout] = frameLayouts.reversed()
		
		var lastFrameLayout: FrameLayout? = nil
		for layout in (isInvertedAlignment ? frameLayouts : invertedLayoutArray) {
			if !layout.isHidden && !(layout.targetView?.isHidden ?? false) {
				lastFrameLayout = layout
				break
			}
		}
		
		var direction: NKLayoutDirection = layoutDirection
		if layoutDirection == .auto {
			direction = frame.size.width < frame.size.height ? .vertical : .horizontal
		}
		
		if direction == .horizontal {
			switch layoutAlignment {
			case .top, .left:
				var flexibleFrame: FrameLayout? = nil
				var flexibleLeftEdge: CGFloat = 0
				
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					if frameLayout.isFlexible {
						flexibleFrame = frameLayout
						flexibleLeftEdge = containerFrame.origin.x + usedSpace
						break
					}
					
					frameContentSize = CGSize(width: containerFrame.size.width - usedSpace, height: containerFrame.size.height)
					if isIntrinsicSizeEnabled || (frameLayout != lastFrameLayout) {
						let fitSize = frameLayout.sizeThatFits(frameContentSize)
						
						if !frameLayout.isIntrinsicSizeEnabled && frameLayout == lastFrameLayout {
							frameContentSize.height = fitSize.height
						}
						else {
							frameContentSize = fitSize
						}
					}
					
					targetFrame.origin.x = containerFrame.origin.x + usedSpace
					targetFrame.size.width = frameContentSize.width
					frameLayout.frame = targetFrame
					
					space = frameContentSize.width > 0 ? spacing : 0
					usedSpace += frameContentSize.width + space
				}
				
				if flexibleFrame != nil {
					space = 0
					usedSpace = 0
					
					for frameLayout in invertedLayoutArray {
						if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
							continue
						}
						
						if frameLayout == flexibleFrame {
							targetFrame.origin.x = flexibleLeftEdge
							targetFrame.size.width = containerFrame.size.width - flexibleLeftEdge - usedSpace + edgeInsets.left
						}
						else {
							frameContentSize = CGSize(width: containerFrame.size.width - usedSpace, height: containerFrame.size.height)
							frameContentSize = frameLayout.sizeThatFits(frameContentSize)
							targetFrame.origin.x = max(bounds.size.width - frameContentSize.width - edgeInsets.right - usedSpace, 0)
							targetFrame.size.width = frameContentSize.width
						}
						
						frameLayout.frame = targetFrame
						if frameLayout == flexibleFrame {
							break
						}
						
						space = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + space
					}
				}
				
				break
				
			case .bottom, .right:
				var flexibleFrame: FrameLayout? = nil
				var flexibleRightEdge: CGFloat = 0
				
				for frameLayout in invertedLayoutArray {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					if frameLayout.isFlexible {
						flexibleFrame = frameLayout
						flexibleRightEdge = containerFrame.size.width - usedSpace
						break
					}
					
					if frameLayout.isIntrinsicSizeEnabled == false && (frameLayout == lastFrameLayout) {
						targetFrame.origin.x = edgeInsets.left
						targetFrame.size.width = containerFrame.size.width - usedSpace
					}
					else {
						frameContentSize = CGSize(width: containerFrame.size.width - usedSpace, height: containerFrame.size.height)
						frameContentSize = frameLayout.sizeThatFits(frameContentSize)
						
						targetFrame.origin.x = max(bounds.size.width - frameContentSize.width - edgeInsets.right - usedSpace, 0)
						targetFrame.size.width = frameContentSize.width
					}
					
					frameLayout.frame = targetFrame
					space = frameContentSize.width > 0 ? spacing : 0
					usedSpace += frameContentSize.width + space
				}
				
				if flexibleFrame != nil {
					space = 0
					usedSpace = 0
					
					for frameLayout in frameLayouts {
						if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
							continue
						}
						
						frameContentSize = CGSize(width: containerFrame.size.width - usedSpace, height: containerFrame.size.height)
						if isIntrinsicSizeEnabled || (frameLayout != lastFrameLayout) {
							let fitSize = frameLayout.sizeThatFits(frameContentSize)
							
							if frameLayout.isIntrinsicSizeEnabled && frameLayout == flexibleFrame {
								frameContentSize.height = fitSize.height
							}
							else {
								frameContentSize = fitSize
							}
						}
						
						targetFrame.origin.x = containerFrame.origin.x + usedSpace
						
						if frameLayout == flexibleFrame {
							targetFrame.size.width = flexibleRightEdge - usedSpace
						}
						else {
							targetFrame.size.width = frameContentSize.width
						}
						
						frameLayout.frame = targetFrame
						if frameLayout == flexibleFrame {
							break
						}
						
						space = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + space
					}
				}
				break
				
			case .split:
				let visibleFrameCount = numberOfVisibleFrames()
				let spaces: CGFloat = CGFloat(visibleFrameCount - 1) * spacing
				let cellSize = (containerFrame.size.width - spaces) / CGFloat(Float(visibleFrameCount))
				
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					frameContentSize = CGSize(width: cellSize, height: containerFrame.size.height)
					targetFrame.origin.x = containerFrame.origin.x + usedSpace
					targetFrame.size.width = frameContentSize.width
					frameLayout.frame = targetFrame
					
					usedSpace += frameContentSize.width + spacing
				}
				break
				
			case .center:
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					frameContentSize = CGSize(width: containerFrame.size.width - usedSpace, height: containerFrame.size.height)
					let fitSize = frameLayout.sizeThatFits(frameContentSize)
					if frameLayout.isIntrinsicSizeEnabled {
						frameContentSize = fitSize
					}
					else {
						frameContentSize.width = fitSize.width
					}
					
					targetFrame.origin.x = containerFrame.origin.x + usedSpace
					targetFrame.size = frameContentSize
					frameLayout.frame = targetFrame
					
					space = frameContentSize.width > 0 ? spacing : 0
					space = frameLayout != lastFrameLayout ? space : 0
					usedSpace += frameContentSize.width + space
				}
				
				let spaceToCenter: CGFloat = (containerFrame.size.width - usedSpace) / 2
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					targetFrame = frameLayout.frame
					targetFrame.origin.x += spaceToCenter
					frameLayout.frame = targetFrame
				}
				
				break
			}
		}
		else {
			switch layoutAlignment {
			case .top, .left:
				var flexibleFrame: FrameLayout? = nil
				var flexibleTopEdge: CGFloat = 0
				
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					if frameLayout.isFlexible {
						flexibleFrame = frameLayout
						flexibleTopEdge = containerFrame.origin.y + usedSpace
						break
					}
					
					frameContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - usedSpace)
					if isIntrinsicSizeEnabled || frameLayout != lastFrameLayout {
						let fitSize = frameLayout.sizeThatFits(frameContentSize)
						
						if !frameLayout.isIntrinsicSizeEnabled && (frameLayout == lastFrameLayout) {
							frameContentSize.width = fitSize.width
						}
						else {
							frameContentSize = fitSize
						}
					}
					
					targetFrame.origin.y = containerFrame.origin.y + usedSpace
					targetFrame.size.height = frameContentSize.height
					frameLayout.frame = targetFrame
					
					space = frameContentSize.height > 0 ? spacing : 0
					usedSpace += frameContentSize.height + space
				}
				
				if flexibleFrame != nil {
					space = 0
					usedSpace = 0
					
					for frameLayout in invertedLayoutArray {
						if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
							continue
						}
						
						if frameLayout == flexibleFrame {
							targetFrame.origin.y = flexibleTopEdge
							targetFrame.size.height = containerFrame.size.height - flexibleTopEdge - usedSpace + edgeInsets.top
						}
						else {
							frameContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - usedSpace)
							frameContentSize = frameLayout.sizeThatFits(frameContentSize)
							targetFrame.origin.y = max(bounds.size.height - frameContentSize.height - edgeInsets.bottom - usedSpace, 0)
							targetFrame.size.height = frameContentSize.height
						}
						
						frameLayout.frame = targetFrame
						
						if frameLayout == flexibleFrame {
							break
						}
						
						space = frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + space
					}
				}
				break
				
			case .bottom, .right:
				var flexibleFrame: FrameLayout? = nil
				var flexibleBottomEdge: CGFloat = 0
				
				for frameLayout in invertedLayoutArray {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					if frameLayout.isFlexible {
						flexibleFrame = frameLayout
						flexibleBottomEdge = containerFrame.size.height - usedSpace
						break
					}
					
					if !frameLayout.isIntrinsicSizeEnabled && (frameLayout == lastFrameLayout) {
						targetFrame.origin.y = edgeInsets.top
						targetFrame.size.height = containerFrame.size.height - usedSpace
					}
					else {
						frameContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - usedSpace)
						frameContentSize = frameLayout.sizeThatFits(frameContentSize)
						
						targetFrame.origin.y = max(bounds.size.height - frameContentSize.height - edgeInsets.bottom - usedSpace, 0)
						targetFrame.size.height = frameContentSize.height
					}
					
					frameLayout.frame = targetFrame
					
					space = frameContentSize.height > 0 ? spacing : 0
					usedSpace += frameContentSize.height + space
				}
				
				if flexibleFrame != nil {
					space = 0
					usedSpace = 0
					
					for frameLayout in frameLayouts {
						if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
							continue
						}
						
						frameContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - usedSpace)
						if isIntrinsicSizeEnabled || frameLayout != flexibleFrame {
							let fitSize = frameLayout.sizeThatFits(frameContentSize)
							
							if !frameLayout.isIntrinsicSizeEnabled && (frameLayout == flexibleFrame) {
								frameContentSize.width = fitSize.width
							}
							else {
								frameContentSize = fitSize
							}
						}
						
						targetFrame.origin.y = containerFrame.origin.y + usedSpace
						
						if frameLayout == flexibleFrame {
							targetFrame.size.height = flexibleBottomEdge - usedSpace
						}
						else {
							targetFrame.size.height = frameContentSize.height
						}
						
						frameLayout.frame = targetFrame
						
						if frameLayout == flexibleFrame {
							break
						}
						
						space = frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + space
					}
				}
				break
				
			case .split:
				let visibleFramecount = numberOfVisibleFrames()
				let spaces: CGFloat = CGFloat(visibleFramecount - 1) * spacing
				let cellSize = (containerFrame.size.height - spaces) / CGFloat(Float(visibleFramecount))
				
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					frameContentSize = CGSize(width: containerFrame.size.width, height: cellSize)
					//if (frameLayout.intrinsicSizeEnabled) frameContentSize = [frameLayout sizeThatFits:frameContentSize];
					
					targetFrame.origin.y = containerFrame.origin.y + usedSpace
					targetFrame.size.height = frameContentSize.height
					frameLayout.frame = targetFrame
					
					usedSpace += frameContentSize.height + spacing
				}
				break
				
			case .center:
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					frameContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - usedSpace)
					let fitSize = frameLayout.sizeThatFits(frameContentSize)
					if frameLayout.isIntrinsicSizeEnabled {
						frameContentSize = fitSize
					}
					else {
						frameContentSize.height = fitSize.height
					}
					
					targetFrame.origin.y = containerFrame.origin.y + usedSpace
					targetFrame.size = frameContentSize
					frameLayout.frame = targetFrame
					
					if frameLayout != lastFrameLayout {
						space = frameContentSize.height > 0 ? spacing : 0
					}
					else {
						space = 0
					}
					
					usedSpace += frameContentSize.height + space
				}
				
				let spaceToCenter: CGFloat = (containerFrame.size.height - usedSpace) / 2
				for frameLayout in frameLayouts {
					if frameLayout.isHidden || (frameLayout.targetView?.isHidden ?? false) {
						continue
					}
					
					targetFrame = frameLayout.frame
					targetFrame.origin.y += spaceToCenter
					frameLayout.frame = targetFrame
				}
				break
			}
		}
	}
	
}
