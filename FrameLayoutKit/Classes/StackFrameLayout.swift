//
//  StackFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/19/18.
//

import UIKit

open class StackFrameLayout: FrameLayout {
	public var distribution: NKLayoutDistribution = .top
	public var axis: NKLayoutAxis = .vertical
	
	@available(*, deprecated, renamed: "axis")
	public var layoutDirection: NKLayoutAxis {
		get { axis }
		set { axis = newValue }
	}
	
	@available(*, deprecated, renamed: "distribution")
	public var layoutAlignment: NKLayoutDistribution {
		get { distribution }
		set { distribution = newValue }
	}
	
	public var spacing: CGFloat = 0 {
		didSet {
			if spacing != oldValue {
				setNeedsLayout()
			}
		}
	}
	
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
	
	@available(*, deprecated, renamed: "debug")
	override open var showFrameDebug: Bool {
		didSet {
			for layout in frameLayouts {
				layout.debug = showFrameDebug
			}
		}
	}
	
	override open var debug: Bool {
		didSet {
			for layout in frameLayouts {
				layout.debug = debug
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
		get { frameLayouts.first }
	}
	
	public var lastFrameLayout: FrameLayout? {
		get { frameLayouts.last }
	}
	
	public internal(set) var frameLayouts: [FrameLayout] = []
	
	public var numberOfFrameLayouts: Int {
		get { frameLayouts.count }
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
					add()
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
			add(views)
		}
	}
	
	convenience public init(axis: NKLayoutAxis, distribution: NKLayoutDistribution = .top, views: [UIView]? = nil) {
		self.init()
		
		self.axis = axis
		self.distribution = distribution
		
		if let views = views {
			add(views)
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
	
	@available(*, deprecated, renamed: "add(view:)")
	@discardableResult
	open func append(frameLayout: FrameLayout) -> FrameLayout {
		frameLayouts.append(frameLayout)
		addSubview(frameLayout)
		return frameLayout
	}
	
	@available(*, deprecated, renamed: "add(view:)")
	@discardableResult
	open func append(view: UIView? = nil) -> FrameLayout {
		let frameLayout = FrameLayout(targetView: view)
		frameLayout.debug = debug
		frameLayouts.append(frameLayout)
		addSubview(frameLayout)
		return frameLayout
	}
	
	@discardableResult
	open func add(_ views: [UIView]) -> [FrameLayout] {
		var results = [FrameLayout]()
		views.forEach({ results.append(add($0)) })
		return results
	}
	
	@discardableResult
	open func add(_ view: UIView? = nil) -> FrameLayout {
		if let frameLayout = view as? FrameLayout, frameLayout.superview == nil {
			frameLayouts.append(frameLayout)
			addSubview(frameLayout)
			return frameLayout
		}
		else {
			if let view = view, view.superview == nil { addSubview(view) }
			let frameLayout = FrameLayout(targetView: view)
			frameLayout.debug = debug
			frameLayouts.append(frameLayout)
			addSubview(frameLayout)
			return frameLayout
		}
	}
	
	@discardableResult
	open func insert(_ view: UIView?, at index: Int) -> FrameLayout {
		if let frameLayout = view as? FrameLayout, frameLayout.superview == nil {
			frameLayouts.insert(frameLayout, at: index)
			addSubview(frameLayout)
			return frameLayout
		}
		else {
			if let view = view, view.superview == nil { addSubview(view) }
			let frameLayout = FrameLayout(targetView: view)
			frameLayout.debug = debug
			frameLayouts.insert(frameLayout, at: index)
			return frameLayout
		}
	}
	
	@available(*, deprecated, renamed: "addSpace(size:)")
	@discardableResult
	open func appendSpace(size: CGFloat = 0) -> FrameLayout {
		return addSpace(size)
	}
	
	@discardableResult
	open func addSpace(_ size: CGFloat = 0) -> FrameLayout {
		let frameLayout = add()
		frameLayout.minSize = CGSize(width: size, height: size)
		return frameLayout
	}
	
	open func removeFrameLayout(at index: Int, autoRemoveTargetView: Bool = false) {
		guard index >= 0 && index < frameLayouts.count else { return }
		
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
	
	open func replace(_ frameLayout: FrameLayout?, at index: Int) {
		guard let frameLayout = frameLayout else {
			removeFrameLayout(at: index)
			return
		}
		
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
			insert(nil, at: index)
		}
	}
	
	// MARK: -
	
	public func frameLayout(at index: Int) -> FrameLayout? {
		guard index >= 0 && index < frameLayouts.count else { return nil }
		return frameLayouts[index]
	}
	
	public func frameLayout(with view: UIView) -> FrameLayout? {
		return frameLayouts.first(where: { $0.targetView == view })
	}
	
	public func enumerate(_ block: ((FrameLayout, Int, inout Bool) -> Void)) {
		var stop: Bool = false
		var index = 0
		
		for layout in frameLayouts {
			block(layout, index, &stop)
			if stop { break }
			
			index += 1
		}
	}
	
	// MARK: -
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		frameLayouts.forEach { $0.setNeedsLayout() }
	}
	
	fileprivate func visibleFrames() -> [FrameLayout] {
		return frameLayouts.filter { !$0.isEmpty }
	}
	
	fileprivate func numberOfVisibleFrames() -> Int {
		return visibleFrames().count
	}
	
	// MARK: -
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		preSizeThatFitsConfigurationBlock?(self, size)
		
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
			
			if isOverlapped {
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
						#if DEBUG
						frameLayout.setNeedsDisplay()
						#endif
						continue
					}
					
					let frameSize = frameLayout.sizeThatFits(contentSize)
					result.width = isIntrinsicSizeEnabled ? max(result.width, frameSize.width) : size.width
					result.height = max(result.height, frameSize.height)
				}
				
				if heightRatio > 0 {
					result.height = result.width * heightRatio
				}
				
				return result
			}
			
			var gapSpace: CGFloat = 0
			var totalSpace: CGFloat = 0
			var frameContentSize: CGSize
			
			let isInvertedAlignment = distribution == .bottom || distribution == .right
			let activeFrameLayouts: [FrameLayout] = (isInvertedAlignment ? frameLayouts.reversed() : frameLayouts)
			let lastFrameLayout: FrameLayout? = activeFrameLayouts.last(where: { !$0.isEmpty })
			
			if axis == .horizontal {
				var maxHeight: CGFloat = 0
				
				switch distribution {
					case .left, .right, .top, .bottom:
						var flexibleFrames = [FrameLayout]()
						for frameLayout in activeFrameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							if frameLayout.isFlexible {
								flexibleFrames.append(frameLayout)
								continue
							}
							
							frameContentSize = CGSize(width: contentSize.width - totalSpace, height: contentSize.height)
							frameContentSize = frameLayout.sizeThatFits(frameContentSize)
							
							gapSpace = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
							totalSpace += frameContentSize.width + gapSpace
							maxHeight = max(maxHeight, frameContentSize.height)
						}
						
						let flexibleFrameCount = flexibleFrames.count
						if flexibleFrameCount > 0 {
							let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
							let contentWidth = contentSize.width - totalSpace - remainingSpace
							let ratio = flexibleFrames.map { return $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
							
							var ratioIndex = 0
							for frameLayout in flexibleFrames {
								let ratioValue = ratio[ratioIndex]
								let cellWidth = contentWidth * ratioValue
								frameContentSize = CGSize(width: cellWidth, height: contentSize.height)
								frameContentSize = frameLayout.sizeThatFits(frameContentSize)
								
								maxHeight = max(maxHeight, frameContentSize.height)
								ratioIndex += 1
							}
						}
						
						break
					
					case .equal, .center:
						let visibleFrameLayouts = visibleFrames()
						var flexibleFrames = [FrameLayout]()
						frameContentSize = CGSize(width: contentSize.width / CGFloat(visibleFrameLayouts.count), height: contentSize.height)
						
						for frameLayout in visibleFrameLayouts {
							if frameLayout.isFlexible {
								flexibleFrames.append(frameLayout)
								continue
							}
							
							frameContentSize = frameLayout.sizeThatFits(frameContentSize)
							
							gapSpace = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
							totalSpace += frameContentSize.width + gapSpace
							maxHeight = max(maxHeight, frameContentSize.height)
						}
						
						let flexibleFrameCount = flexibleFrames.count
						if flexibleFrameCount > 0 {
							let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
							let remainingWidth = contentSize.width - totalSpace - remainingSpace
							let cellWidth = remainingWidth / CGFloat(flexibleFrameCount)
							
							for frameLayout in flexibleFrames {
								frameContentSize = CGSize(width: cellWidth, height: contentSize.height)
								frameContentSize = frameLayout.sizeThatFits(frameContentSize)
								
								totalSpace += frameContentSize.width
								maxHeight = max(maxHeight, frameContentSize.height)
							}
						}
						
						break
					
					case .split(let ratio):
						let visibleFrameLayouts = visibleFrames()
						let visibleFrameCount = visibleFrameLayouts.count
						let spaces = CGFloat(visibleFrameCount - 1) * spacing
						let contentWidth = contentSize.width - spaces
						let finalRatio = ratio.autoFill(total: visibleFrameCount)
						
						var ratioIndex = 0
						for frameLayout in visibleFrameLayouts {
							let ratioValue = finalRatio[ratioIndex]
							let cellWidth = contentWidth * ratioValue
							frameContentSize = CGSize(width: cellWidth, height: contentSize.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
							frameContentSize = frameLayout.sizeThatFits(frameContentSize)
							
							gapSpace = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
							totalSpace += frameContentSize.width + gapSpace
							maxHeight = max(maxHeight, frameContentSize.height)
							ratioIndex += 1
						}
						break
				}
				
				if isIntrinsicSizeEnabled {
					result.width = totalSpace
				}
				
				result.height = min(maxHeight, size.height)
			}
			else { // if axis == .vertical {
				var maxWidth: CGFloat = 0
				var flexibleFrames = [FrameLayout]()
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty {
						#if DEBUG
						frameLayout.setNeedsDisplay()
						#endif
						continue
					}
					
					if frameLayout.isFlexible {
						flexibleFrames.append(frameLayout)
						continue
					}
					
					frameContentSize = CGSize(width: contentSize.width, height: contentSize.height - totalSpace)
					frameContentSize = frameLayout.sizeThatFits(frameContentSize)
					
					gapSpace = frameContentSize.height > 0 && frameLayout != lastFrameLayout ? spacing : 0
					totalSpace += frameContentSize.height + gapSpace
					maxWidth = max(maxWidth, frameContentSize.width)
				}
				
				let flexibleFrameCount = flexibleFrames.count
				if flexibleFrameCount > 0 {
					let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
					let contentHeight = contentSize.height - totalSpace - remainingSpace
					let ratio = flexibleFrames.map { return $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
					
					var ratioIndex = 0
					for frameLayout in flexibleFrames {
						let ratioValue = ratio[ratioIndex]
						let cellHeight = contentHeight * ratioValue
						frameContentSize = CGSize(width: contentSize.width, height: cellHeight)
						frameContentSize = frameLayout.sizeThatFits(frameContentSize)
						
						gapSpace = frameContentSize.height > 0 ? spacing : 0
						totalSpace += frameContentSize.height + gapSpace
						maxWidth = max(maxWidth, frameContentSize.width)
						ratioIndex += 1
					}
				}
				
				if isIntrinsicSizeEnabled { result.width = maxWidth }
				result.height = min(totalSpace, size.height)
			}
			
			result.limitedTo(minSize: minSize, maxSize: maxSize)
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
			didLayoutSubviewsBlock?(self)
			return
		}
		
		#if swift(>=4.2)
		let containerFrame = bounds.inset(by: edgeInsets)
		#else
		let containerFrame = UIEdgeInsetsInsetRect(bounds, edgeInsets)
		#endif
		
		var gapSpace: CGFloat = 0
		var usedSpace: CGFloat = 0
		var frameContentSize: CGSize = .zero
		var targetFrame = containerFrame
		
		let isInvertedAlignment = distribution == .bottom || distribution == .right
		let invertedLayoutArray: [FrameLayout] = frameLayouts.reversed()
		let lastFrameLayout: FrameLayout? = (isInvertedAlignment ? frameLayouts : invertedLayoutArray).first(where: { !$0.isEmpty })
		
		if axis == .horizontal {
			switch distribution {
				case .top, .left:
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							frameContentSize = frameLayout.isFlexible ? CGSize(width: containerFrame.size.width * (frameLayout.flexibleRatio < 0.0 ? 1.0 : frameLayout.flexibleRatio), height: containerFrame.size.height) : frameLayout.sizeThatFits(containerFrame.size)
							targetFrame.origin.x = containerFrame.origin.x
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.size.height
							frameLayout.frame = targetFrame
						}
						return
					}
					
					var flexibleFrames = [FrameLayout]()
					
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						if frameLayout.isFlexible {
							flexibleFrames.append(frameLayout)
							continue
						}
						
						frameContentSize = CGSize(width: containerFrame.size.width - usedSpace, height: containerFrame.size.height)
						let fitSize = frameLayout.sizeThatFits(frameContentSize)
						
						if frameLayout == lastFrameLayout && !frameLayout.isIntrinsicSizeEnabled {
							frameContentSize.height = fitSize.height
						}
						else {
							frameContentSize = fitSize
						}
						
						targetFrame.origin.x = containerFrame.origin.x + usedSpace
						targetFrame.size.width = frameContentSize.width
						frameLayout.frame = targetFrame
						
						gapSpace = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
					}
					
					let flexibleFrameCount = flexibleFrames.count
					if flexibleFrameCount > 0 {
						let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
						let contentWidth = containerFrame.size.width - usedSpace - remainingSpace
						let ratio = flexibleFrames.map { return $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
						
						gapSpace = 0
						var ratioIndex = 0
						var offset: CGFloat = edgeInsets.left
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							var rect = frameLayout.frame
							
							if frameLayout.isFlexible {
								let ratioValue = ratio[ratioIndex]
								let cellWidth = contentWidth * ratioValue
								
								rect = targetFrame
								rect.size = CGSize(width: cellWidth, height: containerFrame.size.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
								ratioIndex += 1
							}
							
							if rect.origin.x != offset || frameLayout.frame.size.width != rect.size.width {
								rect.origin.x = offset
								frameLayout.frame = rect
							}
							
							gapSpace = rect.size.width > 0 ? spacing : 0
							offset += rect.size.width + gapSpace
						}
					}
					
					break
				
				case .bottom, .right:
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size)
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.size.height
							targetFrame.origin.x = containerFrame.size.width - targetFrame.size.width
							frameLayout.frame = targetFrame
						}
						return
					}
					
					var flexibleFrames = [FrameLayout]()
					
					for frameLayout in invertedLayoutArray {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						if frameLayout.isFlexible {
							flexibleFrames.append(frameLayout)
							continue
						}
						
						if frameLayout == lastFrameLayout && !frameLayout.isIntrinsicSizeEnabled {
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
						gapSpace = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
					}
					
					let flexibleFrameCount = flexibleFrames.count
					if flexibleFrameCount > 0 {
						let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
						let contentWidth = containerFrame.size.width - usedSpace - remainingSpace
						let ratio = flexibleFrames.map { return $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
						
						gapSpace = 0
						var ratioIndex = 0
						var offset: CGFloat = containerFrame.size.width + edgeInsets.left
						for frameLayout in invertedLayoutArray {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							var rect = frameLayout.frame
							
							if frameLayout.isFlexible {
								let ratioValue = ratio[ratioIndex]
								let cellWidth = contentWidth * ratioValue
								
								rect = targetFrame
								rect.size = CGSize(width: cellWidth, height: containerFrame.size.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
								ratioIndex += 1
							}
							
							offset -= rect.size.width + gapSpace
							
							if rect.origin.x != offset || frameLayout.frame.size.width != rect.size.width {
								rect.origin.x = offset
								frameLayout.frame = rect
							}
							
							gapSpace = rect.size.width > 0 ? spacing : 0
						}
					}
					break
				
				case .equal:
					let visibleFrameLayouts = visibleFrames()
					let visibleFrameCount = visibleFrameLayouts.count
					let spaces = CGFloat(visibleFrameCount - 1) * spacing
					let cellSize = (containerFrame.size.width - spaces) / CGFloat(Float(visibleFrameCount))
					
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : CGSize(width: cellSize, height: containerFrame.size.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
							
							targetFrame.origin.x = containerFrame.origin.x
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.size.height
							frameLayout.frame = targetFrame
						}
						return
					}
					
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						frameContentSize = CGSize(width: cellSize, height: containerFrame.size.height)
						targetFrame.origin.x = containerFrame.origin.x + usedSpace
						targetFrame.size.width = frameContentSize.width
						frameLayout.frame = targetFrame
						
						usedSpace += frameContentSize.width + spacing
					}
					break
				
				case .split(let ratio):
					let visibleFrameCount = numberOfVisibleFrames()
					let spaces: CGFloat = CGFloat(visibleFrameCount - 1) * spacing
					let contentWidth = containerFrame.size.width - spaces
					let finalRatio = ratio.autoFill(total: visibleFrameCount)
					
					var ratioIndex = 0
					
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							let ratioValue = finalRatio[ratioIndex]
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : CGSize(width: contentWidth * ratioValue, height: containerFrame.size.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
							
							targetFrame.origin.x = containerFrame.origin.x
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.size.height
							frameLayout.frame = targetFrame
							ratioIndex += 1
						}
						return
					}
					
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						let ratioValue = finalRatio[ratioIndex]
						let cellWidth = contentWidth * ratioValue
						frameContentSize = CGSize(width: cellWidth, height: containerFrame.size.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
						
						targetFrame.origin.x = containerFrame.origin.x + usedSpace
						targetFrame.size.width = frameContentSize.width
						frameLayout.frame = targetFrame
						
						gapSpace = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
						ratioIndex += 1
					}
					
					break
				
				case .center:
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size)
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.size.height
							targetFrame.origin.x = containerFrame.origin.x + (containerFrame.size.width - targetFrame.size.width)/2
							frameLayout.frame = targetFrame
						}
						return
					}
					
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						frameContentSize = CGSize(width: containerFrame.size.width - usedSpace, height: containerFrame.size.height)
						let fitSize = frameLayout.sizeThatFits(frameContentSize)
						frameContentSize.width = fitSize.width
						
						targetFrame.origin.x = containerFrame.origin.x + usedSpace
						targetFrame.size = frameContentSize
						frameLayout.frame = targetFrame
						
						gapSpace = frameLayout != lastFrameLayout && frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
					}
					
					let offset = (containerFrame.size.width - usedSpace) / 2.0
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						targetFrame = CGRect(x: frameLayout.frame.origin.x + offset, y: frameLayout.frame.origin.y, width: frameLayout.frame.size.width, height: frameLayout.frame.size.height)
						frameLayout.frame = targetFrame
					}
					
					break
			}
		}
		else { // if axis == .vertical
			switch distribution {
				case .top, .left:
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size)
							targetFrame.origin.y = containerFrame.origin.y
							targetFrame.size.width = containerFrame.size.width
							targetFrame.size.height = frameContentSize.height
							frameLayout.frame = targetFrame
						}
						return
					}
					
					var flexibleFrames = [FrameLayout]()
					
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						if frameLayout.isFlexible {
							flexibleFrames.append(frameLayout)
							continue
						}
						
						frameContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - usedSpace)
						let fitSize = frameLayout.sizeThatFits(frameContentSize)
						
						if frameLayout == lastFrameLayout && !frameLayout.isIntrinsicSizeEnabled {
							frameContentSize.width = fitSize.width
						}
						else {
							frameContentSize = fitSize
						}
						
						targetFrame.origin.y = containerFrame.origin.y + usedSpace
						targetFrame.size.height = frameContentSize.height
						frameLayout.frame = targetFrame
						
						gapSpace = frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + gapSpace
					}
					
					let flexibleFrameCount = flexibleFrames.count
					if flexibleFrameCount > 0 {
						let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
						let contentHeight = containerFrame.size.height - usedSpace - remainingSpace
						let ratio = flexibleFrames.map { return $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
						
						gapSpace = 0
						var ratioIndex = 0
						var offset = edgeInsets.top
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							var rect = frameLayout.frame
							
							if frameLayout.isFlexible {
								let ratioValue = ratio[ratioIndex]
								let cellHeight = contentHeight * ratioValue
								
								rect = targetFrame
								rect.size = CGSize(width: containerFrame.size.width, height: cellHeight).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
								ratioIndex += 1
							}
							
							if rect.origin.y != offset || frameLayout.frame.size.height != rect.size.height {
								rect.origin.y = offset
								frameLayout.frame = rect
							}
							
							gapSpace = rect.size.height > 0 ? spacing : 0
							offset += rect.size.height + gapSpace
						}
					}
					break
				
				case .bottom, .right:
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size)
							targetFrame.size.width = containerFrame.size.width
							targetFrame.size.height = frameContentSize.height
							targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - targetFrame.size.height)
							frameLayout.frame = targetFrame
						}
						return
					}
					
					var flexibleFrames = [FrameLayout]()
					
					for frameLayout in invertedLayoutArray {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						if frameLayout.isFlexible {
							flexibleFrames.append(frameLayout)
							continue
						}
						
						if frameLayout == lastFrameLayout && !frameLayout.isIntrinsicSizeEnabled {
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
						
						gapSpace = frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + gapSpace
					}
					
					let flexibleFrameCount = flexibleFrames.count
					if flexibleFrameCount > 0 {
						let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
						let contentHeight = containerFrame.size.height - usedSpace - remainingSpace
						let ratio = flexibleFrames.map { return $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
						
						gapSpace = 0
						var ratioIndex = 0
						var offset = containerFrame.size.height + edgeInsets.top
						for frameLayout in invertedLayoutArray {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							var rect = frameLayout.frame
							
							if frameLayout.isFlexible {
								let ratioValue = ratio[ratioIndex]
								let cellHeight = contentHeight * ratioValue
								
								rect = targetFrame
								rect.size = CGSize(width: containerFrame.size.width, height: cellHeight).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
								ratioIndex += 1
							}
							
							offset -= rect.size.height + gapSpace
							
							if rect.origin.y != offset || frameLayout.frame.size.height != rect.size.height {
								rect.origin.y = offset
								frameLayout.frame = rect
							}
							
							gapSpace = rect.size.height > 0 ? spacing : 0
						}
					}
					break
				
				case .equal:
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							frameLayout.frame = containerFrame
						}
						return
					}
					
					let visibleFrameLayouts = visibleFrames()
					let visibleFrameCount = visibleFrameLayouts.count
					let spaces = CGFloat(visibleFrameCount - 1) * spacing
					let cellSize = (containerFrame.size.height - spaces) / CGFloat(Float(visibleFrameCount))
					
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
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
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size)
							targetFrame.size.width = containerFrame.size.width
							targetFrame.size.height = frameContentSize.height
							targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - targetFrame.size.width)/2
							frameLayout.frame = targetFrame
						}
						return
					}
					
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						frameContentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height - usedSpace)
						let fitSize = frameLayout.sizeThatFits(frameContentSize)
						frameContentSize.height = fitSize.height
						
						targetFrame.origin.y = containerFrame.origin.y + usedSpace
						targetFrame.size = frameContentSize
						frameLayout.frame = targetFrame
						
						gapSpace = frameLayout == lastFrameLayout ? 0.0 : frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + gapSpace
					}
					
					let offset = (containerFrame.size.height - usedSpace) / 2.0
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						targetFrame = frameLayout.frame
						targetFrame.origin.y += offset
						frameLayout.frame = targetFrame
					}
					break
				
				case .split(let ratio):
					let visibleFrameLayouts = visibleFrames()
					let visibleFrameCount = visibleFrameLayouts.count
					let spaces = CGFloat(visibleFrameCount - 1) * spacing
					let contentHeight = containerFrame.size.height - spaces
					
					if isOverlapped {
						for frameLayout in frameLayouts {
							if frameLayout.isEmpty {
								#if DEBUG
								frameLayout.setNeedsDisplay()
								#endif
								continue
							}
							
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
							targetFrame.origin.y = containerFrame.origin.y
							targetFrame.size.width = containerFrame.size.width
							targetFrame.size.height = frameContentSize.height
							frameLayout.frame = targetFrame
						}
						return
					}
					
					let finalRatio = ratio.autoFill(total: visibleFrameCount)
					
					var ratioIndex = 0
					for frameLayout in frameLayouts {
						if frameLayout.isEmpty {
							#if DEBUG
							frameLayout.setNeedsDisplay()
							#endif
							continue
						}
						
						let ratioValue = finalRatio[ratioIndex]
						let cellHeight = contentHeight * ratioValue
						frameContentSize = CGSize(width: containerFrame.size.width, height: cellHeight).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
						
						targetFrame.origin.y = containerFrame.origin.y + usedSpace
						targetFrame.size.height = frameContentSize.height
						frameLayout.frame = targetFrame
						
						gapSpace = frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + gapSpace
						ratioIndex += 1
					}
					break
			}
		}
		
		didLayoutSubviewsBlock?(self)
	}
	
}

fileprivate extension Array where Element == CGFloat {
	
	/// convert [0.2, -1, -1, 0.3] to [0.2, 0.25, 0.25, 0.3] so total value in array equal to 1.0
	
	func autoFill(total: Int) -> [CGFloat] {
		var finalRatio = self
		let gapCount = total - count
		if gapCount > 0 {
			finalRatio.append(contentsOf: [CGFloat](repeating: -1, count: gapCount)) // fill in missing value as -1
		}
		
		let flexibleRatioCount = finalRatio.filter( { $0 < 0.0 }).count
		if flexibleRatioCount > 0 {
			let remainingRatio = Swift.max(1.0 - (self.filter( {$0 > -1}).reduce(0, +)), 0.0) / CGFloat(flexibleRatioCount)
			finalRatio = finalRatio.replacingMultipleOccurrences(using: (of: -1, with: remainingRatio))
		}
		
		return finalRatio
	}
	
}
