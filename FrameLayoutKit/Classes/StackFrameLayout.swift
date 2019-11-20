//
//  StackFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/19/18.
//

import UIKit

open class StackFrameLayout: FrameLayout {
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
	
	public var isOverlapped: Bool = false {
		didSet {
			setNeedsLayout()
		}
	}
	
	override open var ignoreHiddenView: Bool {
		didSet {
			for layout in frameLayouts {
				layout.ignoreHiddenView = ignoreHiddenView
			}
		}
	}
	
	override open var shouldCacheSize: Bool {
		didSet {
			for layout in frameLayouts {
				layout.shouldCacheSize = shouldCacheSize
			}
		}
	}
	
	override open var showFrameDebug: Bool {
		didSet {
			for layout in frameLayouts {
				layout.showFrameDebug = showFrameDebug
			}
		}
	}
	
	override open var allowContentVerticalGrowing: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentVerticalGrowing = allowContentVerticalGrowing
			}
		}
	}
	
	override open var allowContentVerticalShrinking: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentVerticalShrinking = allowContentVerticalShrinking
			}
		}
	}
	
	override open var allowContentHorizontalGrowing: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentHorizontalGrowing = allowContentHorizontalGrowing
			}
		}
	}
	
	override open var allowContentHorizontalShrinking: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentHorizontalShrinking = allowContentHorizontalShrinking
			}
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
	
	override open var clipsToBounds: Bool {
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
	
	public fileprivate(set) var frameLayouts: [FrameLayout] = []
	
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
	
	@available(*, deprecated, renamed: "init(axis:distribution:views:)")
	convenience public init(direction: NKLayoutAxis, alignment: NKLayoutDistribution = .top, views: [UIView]? = nil) {
		self.init()
		
		self.axis = direction
		self.distribution = alignment
		
		if let views = views {
			append(views: views)
		}
	}
	
	convenience public init(axis: NKLayoutAxis, distribution: NKLayoutDistribution = .top, views: [UIView]? = nil) {
		self.init()
		
		self.axis = axis
		self.distribution = distribution
		
		if let views = views {
			append(views: views)
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
	open func append(frameLayout: FrameLayout) -> FrameLayout {
		frameLayouts.append(frameLayout)
		addSubview(frameLayout)
		return frameLayout
	}
	
	@discardableResult
	open func append(view: UIView? = nil) -> FrameLayout {
		let frameLayout = FrameLayout(targetView: view)
		frameLayout.showFrameDebug = showFrameDebug
		frameLayouts.append(frameLayout)
		addSubview(frameLayout)
		return frameLayout
	}
	
	open func append(views: [UIView]) {
		for view in views {
			if view is FrameLayout && view.superview == nil {
				append(frameLayout: view as! FrameLayout)
			}
			else {
				append(view: view)
			}
		}
	}
	
	@discardableResult
	open func appendEmptySpace(size: CGFloat = 0) -> FrameLayout {
		let frameLayout = append(view: UIView())
		frameLayout.fixSize = CGSize(width: size, height: size)
		return frameLayout
	}
	
	@discardableResult
	open func insert(view: UIView? = nil, at index: Int) -> FrameLayout {
		let frameLayout = FrameLayout(targetView: view)
		frameLayout.showFrameDebug = showFrameDebug
		frameLayouts.insert(frameLayout, at: index)
		return frameLayout
	}
	
	@discardableResult
	open func insert(frameLayout: FrameLayout, at index: Int) -> FrameLayout {
		frameLayouts.insert(frameLayout, at: index)
		return frameLayout
	}
	
	open func removeFrameLayout(at index: Int, autoRemoveTargetView: Bool = false) {
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
	
	open func removeAll(autoRemoveTargetView: Bool = false) {
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
	
	open func replace(frameLayout: FrameLayout?, at index: Int) {
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
				addSubview(frameLayout)
			}
			else if index == count {
				insert(view: nil, at: index)
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
	
	public func enumerate(_ block: ((FrameLayout, Int, inout Bool) -> Void)) {
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
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		
		for layout in frameLayouts {
			layout.setNeedsLayout()
		}
	}
	
	fileprivate func numberOfVisibleFrames() -> Int {
		var count: Int = 0
		for layout in frameLayouts {
			if layout.isEmpty {
				continue
			}
			
			count += 1
		}
		
		return count
	}
	
	// MARK: -
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		var result: CGSize = size
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			result = minSize
		}
		else {
			let contentSize = CGSize(width: max(size.width - verticalEdgeValues, 0), height: max(size.height - horizontalEdgeValues, 0))
			
			if isOverlapped {
				for layout in frameLayouts {
					if layout.isEmpty {
						continue
					}
					
					let frameSize = layout.sizeThatFits(contentSize)
					result.width = isIntrinsicSizeEnabled ? max(result.width, frameSize.width) : size.width
					result.height = max(result.height, frameSize.height)
				}
				
				if heightRatio > 0 {
					result.height = result.width * heightRatio
				}
				
				return result
			}
			
			var space: CGFloat = 0
			var totalSpace: CGFloat = 0
			var frameContentSize: CGSize
			
			let isInvertedAlignment = distribution == .bottom || distribution == .right
			let invertedLayoutArray: [FrameLayout] = frameLayouts.reversed()
			
			var lastFrameLayout: FrameLayout? = nil
			for layout in (isInvertedAlignment ? frameLayouts : invertedLayoutArray) {
				if !layout.isEmpty {
					lastFrameLayout = layout
					break
				}
			}
			
			var direction: NKLayoutAxis = axis
			if axis == .auto {
				direction = size.width < size.height ? .vertical : .horizontal
			}
			
			if direction == .horizontal {
				var maxHeight: CGFloat = 0
				
				switch distribution {
				case .left, .right, .top, .bottom:
					var flexibleFrame: FrameLayout? = nil
					for frameLayout in frameLayouts {
						if frameLayout.isFlexible {
							flexibleFrame = frameLayout
							lastFrameLayout = flexibleFrame
							continue
						}
						
						if frameLayout.isEmpty {
							continue
						}
						
						frameContentSize = CGSize(width: contentSize.width - totalSpace, height: contentSize.height)
						frameContentSize = frameLayout.sizeThatFits(frameContentSize)
						
						space = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
						totalSpace += frameContentSize.width + space
						maxHeight = max(maxHeight, frameContentSize.height)
					}
					
					if let flexibleFrame = flexibleFrame {
						frameContentSize = CGSize(width: contentSize.width - totalSpace, height: contentSize.height)
						frameContentSize = flexibleFrame.sizeThatFits(frameContentSize)
						
						totalSpace += frameContentSize.width
						maxHeight = max(maxHeight, frameContentSize.height)
					}
					
					break
					
				case .equal, .center:
					var flexibleFrame: FrameLayout? = nil
					frameContentSize = CGSize(width: contentSize.width / CGFloat(numberOfVisibleFrames()), height: contentSize.height)
					for frameLayout in frameLayouts {
						if frameLayout.isFlexible {
							flexibleFrame = frameLayout
							lastFrameLayout = flexibleFrame
							continue
						}
						
						if frameLayout.isEmpty {
							continue
						}
						
						frameContentSize = frameLayout.sizeThatFits(frameContentSize)
						
						space = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
						totalSpace += frameContentSize.width + space
						maxHeight = max(maxHeight, frameContentSize.height)
					}
					
					if let flexibleFrame = flexibleFrame {
						frameContentSize = CGSize(width: contentSize.width - totalSpace, height: contentSize.height)
						frameContentSize = flexibleFrame.sizeThatFits(frameContentSize)
						
						totalSpace += frameContentSize.width
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
				var flexibleFrame: FrameLayout? = nil
				for frameLayout in frameLayouts {
					if frameLayout.isFlexible {
						flexibleFrame = frameLayout
						lastFrameLayout = flexibleFrame
						continue
					}
					
					if frameLayout.isEmpty {
						continue
					}
					
					frameContentSize = CGSize(width: contentSize.width, height: contentSize.height - totalSpace)
					frameContentSize = frameLayout.sizeThatFits(frameContentSize)
					
					space = frameContentSize.height > 0 && frameLayout != lastFrameLayout ? spacing : 0
					totalSpace += frameContentSize.height + space
					maxWidth = max(maxWidth, frameContentSize.width)
				}
				
				if let flexibleFrame = flexibleFrame {
					frameContentSize = CGSize(width: contentSize.width, height: contentSize.height - totalSpace)
					frameContentSize = flexibleFrame.sizeThatFits(frameContentSize)
					
					totalSpace += frameContentSize.height
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
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		if bounds.size == .zero {
			return
		}
		
		#if swift(>=4.2)
		let containerFrame = bounds.inset(by: edgeInsets)
		#else
		let containerFrame = UIEdgeInsetsInsetRect(bounds, edgeInsets)
		#endif
		
		var space: CGFloat = 0
		var usedSpace: CGFloat = 0
		var frameContentSize: CGSize = .zero
		var targetFrame = containerFrame
		
		let isInvertedAlignment = distribution == .bottom || distribution == .right
		let invertedLayoutArray: [FrameLayout] = frameLayouts.reversed()
		
		var lastFrameLayout: FrameLayout? = nil
		for layout in (isInvertedAlignment ? frameLayouts : invertedLayoutArray) {
			if !layout.isEmpty {
				lastFrameLayout = layout
				break
			}
		}
		
		var direction: NKLayoutAxis = axis
		if axis == .auto {
			direction = frame.size.width < frame.size.height ? .vertical : .horizontal
		}
		
		if direction == .horizontal {
			switch distribution {
			case .top, .left:
				if isOverlapped {
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							continue
						}
						
						frameContentSize = frameLayout.sizeThatFits(CGSize(width: containerFrame.size.width, height: containerFrame.size.height))
						targetFrame.origin.x = containerFrame.origin.x
						targetFrame.size.width = frameContentSize.width
						targetFrame.size.height = min(frameContentSize.height, containerFrame.size.height)
						frameLayout.frame = targetFrame
					}
					return
				}
				
				var flexibleFrame: FrameLayout? = nil
				var flexibleLeftEdge: CGFloat = 0
				
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
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
						if frameLayout.isEmpty {
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
				if isOverlapped {
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							continue
						}
						
						frameContentSize = frameLayout.sizeThatFits(CGSize(width: containerFrame.size.width, height: containerFrame.size.height))
						targetFrame.size.width = frameContentSize.width
						targetFrame.size.height = min(frameContentSize.height, containerFrame.size.height)
						targetFrame.origin.x = containerFrame.size.width - targetFrame.size.width
						frameLayout.frame = targetFrame
					}
					return
				}
				
				var flexibleFrame: FrameLayout? = nil
				var flexibleRightEdge: CGFloat = 0
				
				for frameLayout in invertedLayoutArray {
					if frameLayout.isEmpty {
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
						if frameLayout.isEmpty {
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
				
			case .equal:
				if isOverlapped {
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							continue
						}
						
						frameLayout.frame = containerFrame
					}
					return
				}
				
				let visibleFrameCount = numberOfVisibleFrames()
				let spaces: CGFloat = CGFloat(visibleFrameCount - 1) * spacing
				let cellSize = (containerFrame.size.width - spaces) / CGFloat(Float(visibleFrameCount))
				
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
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
				if isOverlapped {
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							continue
						}
						
						frameContentSize = frameLayout.sizeThatFits(CGSize(width: containerFrame.size.width, height: containerFrame.size.height))
						targetFrame.origin.x = containerFrame.origin.x + (containerFrame.size.width - frameContentSize.width)/2
						targetFrame.size.width = frameContentSize.width
						targetFrame.size.height = min(frameContentSize.height, containerFrame.size.height)
						frameLayout.frame = targetFrame
					}
					return
				}
				
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
						continue
					}
					
					frameContentSize = CGSize(width: containerFrame.size.width - usedSpace, height: containerFrame.size.height)
					let fitSize = frameLayout.sizeThatFits(frameContentSize)
					frameContentSize.width = fitSize.width
					
					targetFrame.origin.x = containerFrame.origin.x + usedSpace
					targetFrame.size = frameContentSize
					frameLayout.frame = targetFrame
					
					space = frameContentSize.width > 0 ? spacing : 0
					space = frameLayout != lastFrameLayout ? space : 0
					usedSpace += frameContentSize.width + space
				}
				
				let spaceToCenter: CGFloat = (containerFrame.size.width - usedSpace) / 2
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
						continue
					}
					
					targetFrame = CGRect(x: frameLayout.frame.origin.x + spaceToCenter, y: frameLayout.frame.origin.y, width: frameLayout.frame.size.width, height: frameLayout.frame.size.height)
					frameLayout.frame = targetFrame
				}
				
				break
			}
		}
		else {
			switch distribution {
			case .top, .left:
				if isOverlapped {
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							continue
						}
						
						frameContentSize = frameLayout.sizeThatFits(CGSize(width: containerFrame.size.width, height: containerFrame.size.height))
						targetFrame.origin.y = containerFrame.origin.y
						targetFrame.size.width = containerFrame.size.width
						targetFrame.size.height = min(frameContentSize.height, containerFrame.size.height)
						frameLayout.frame = targetFrame
					}
					return
				}
				
				var flexibleFrame: FrameLayout? = nil
				var flexibleTopEdge: CGFloat = 0
				
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
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
						if frameLayout.isEmpty {
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
				if isOverlapped {
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							continue
						}
						
						frameContentSize = frameLayout.sizeThatFits(CGSize(width: containerFrame.size.width, height: containerFrame.size.height))
						targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - frameContentSize.height)
						targetFrame.size.width = containerFrame.size.width
						targetFrame.size.height = min(frameContentSize.height, containerFrame.size.height)
						frameLayout.frame = targetFrame
					}
					return
				}
				
				var flexibleFrame: FrameLayout? = nil
				var flexibleBottomEdge: CGFloat = 0
				
				for frameLayout in invertedLayoutArray {
					if frameLayout.isEmpty {
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
						if frameLayout.isEmpty {
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
				
			case .equal:
				if isOverlapped {
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							continue
						}
						
						frameLayout.frame = containerFrame
					}
					return
				}
				
				let visibleFramecount = numberOfVisibleFrames()
				let spaces: CGFloat = CGFloat(visibleFramecount - 1) * spacing
				let cellSize = (containerFrame.size.height - spaces) / CGFloat(Float(visibleFramecount))
				
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
						continue
					}
					
					frameContentSize = CGSize(width: containerFrame.size.width, height: cellSize)
					//if (frameLayout.isIntrinsicSizeEnabled) frameContentSize = [frameLayout sizeThatFits:frameContentSize];
					
					targetFrame.origin.y = containerFrame.origin.y + usedSpace
					targetFrame.size.height = frameContentSize.height
					frameLayout.frame = targetFrame
					
					usedSpace += frameContentSize.height + spacing
				}
				break
				
			case .center:
				if isOverlapped {
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							continue
						}
						
						frameContentSize = frameLayout.sizeThatFits(CGSize(width: containerFrame.size.width, height: containerFrame.size.height))
						targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - frameContentSize.height)/2
						targetFrame.size.width = min(frameContentSize.width, containerFrame.size.width)
						targetFrame.size.height = min(frameContentSize.height, containerFrame.size.height)
						frameLayout.frame = targetFrame
					}
					return
				}
				
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
						continue
					}
					
					frameContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - usedSpace)
					let fitSize = frameLayout.sizeThatFits(frameContentSize)
					frameContentSize.height = fitSize.height
					
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
					if frameLayout.isEmpty {
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
