//
//  StackFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/19/18.
//

import UIKit

open class StackFrameLayout<T: UIView>: FrameLayout<T> {
	public var distribution: NKLayoutDistribution = .top
	public var axis: NKLayoutAxis = .vertical
	
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
	
	public var isJustified: Bool = false {
		didSet {
			setNeedsLayout()
		}
	}
	
	public var justifyThreshold: CGFloat = 0.0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	override open var ignoreHiddenView: Bool {
		didSet {
			frameLayouts.forEach { $0.ignoreHiddenView = ignoreHiddenView }
		}
	}
	
	override open var shouldCacheSize: Bool {
		didSet {
			frameLayouts.forEach { $0.shouldCacheSize = shouldCacheSize }
		}
	}
	
	override open var debug: Bool {
		didSet {
			frameLayouts.forEach { $0.debug = debug }
		}
	}
	
	/// Set minContentSize for every FrameLayout inside
	open var minItemSize: CGSize = .zero {
		didSet {
			frameLayouts.forEach { $0.minContentSize = minItemSize }
		}
	}
	
	/// Set maxContentSize for every FrameLayout inside
	open var maxItemSize: CGSize = .zero {
		didSet {
			frameLayouts.forEach { $0.maxContentSize = maxItemSize }
		}
	}
	
	/// Set fixContentSize for every FrameLayout inside
	open var fixItemSize: CGSize = .zero {
		didSet {
			frameLayouts.forEach { $0.fixContentSize = fixItemSize }
		}
	}
	
	/// Allow content view to expand its height to fill its frameLayout when the layout is higher than the view itself
	override open var allowContentVerticalGrowing: Bool {
		didSet {
			frameLayouts.forEach { $0.allowContentVerticalGrowing = allowContentVerticalGrowing }
		}
	}
	
	/// Allow content view to shrink its height to fit its frameLayout when the layout is shorter than the view itself
	override open var allowContentVerticalShrinking: Bool {
		didSet {
			frameLayouts.forEach { $0.allowContentVerticalShrinking = allowContentVerticalShrinking }
		}
	}
	
	/// Allow content view to expand its width to fill its frameLayout when the layout is wider than the view itself
	override open var allowContentHorizontalGrowing: Bool {
		didSet {
			frameLayouts.forEach { $0.allowContentHorizontalGrowing = allowContentHorizontalGrowing }
		}
	}
	
	/// Allow content view to shrink its width to fit its frameLayout when the layout is narrower than the view itself
	override open var allowContentHorizontalShrinking: Bool {
		didSet {
			frameLayouts.forEach { $0.allowContentHorizontalShrinking = allowContentHorizontalShrinking }
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
			frameLayouts.forEach { $0.clipsToBounds = clipsToBounds }
		}
	}
	
	public var firstFrameLayout: FrameLayout<T>? {
		get { frameLayouts.first }
	}
	
	public var lastFrameLayout: FrameLayout<T>? {
		get { frameLayouts.last }
	}
	
	public internal(set) var frameLayouts: [FrameLayout<T>] = []
	
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
	
	convenience public init(axis: NKLayoutAxis, distribution: NKLayoutDistribution = .top, views: [T]? = nil) {
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
	
	@discardableResult
	open func add(_ views: [T]) -> [FrameLayout<T>] {
		return views.map { add($0) }
	}
	
	@discardableResult
	open func add(_ view: T? = nil) -> FrameLayout<T> {
		if let frameLayout = view as? FrameLayout<T>, frameLayout.superview == nil {
			frameLayouts.append(frameLayout)
			addSubview(frameLayout)
			return frameLayout
		}
		else {
			if let view = view, view.superview == nil {
				#if DEBUG
				if !isUserInteractionEnabled, view is UIControl {
					print("⚠️ [FrameLayoutKit] \(view) was automatically added to StackFrameLayout \(self) which was disabled user interation. This could make your control unable to interact. You can either set isUserInteractionEnabled = true for this FrameLayout or addSubview(your control) before adding to frameLayout.")
				}
				#endif
				addSubview(view)
			}
			
			let frameLayout = FrameLayout(targetView: view)
			frameLayout.debug = debug
			frameLayout.ignoreHiddenView = ignoreHiddenView
			frameLayout.fixContentSize = fixItemSize
			frameLayout.minContentSize = minItemSize
			frameLayout.maxContentSize = maxItemSize
			frameLayouts.append(frameLayout)
			addSubview(frameLayout)
			return frameLayout
		}
	}
	
	@discardableResult
	open func insert(_ view: T?, at index: Int) -> FrameLayout<T> {
		if let frameLayout = view as? FrameLayout<T>, frameLayout.superview == nil {
			frameLayouts.insert(frameLayout, at: index)
			addSubview(frameLayout)
			return frameLayout
		}
		else {
			if let view = view, view.superview == nil {
				#if DEBUG
				if !isUserInteractionEnabled, view is UIControl {
					print("⚠️ [FrameLayoutKit] \(view) was automatically added to StackFrameLayout \(self) which was disabled user interation. This could make your control unable to interact. You can either set isUserInteractionEnabled = true for this FrameLayout or addSubview(your control) before adding to frameLayout.")
				}
				#endif
				addSubview(view)
			}
			
			let frameLayout = FrameLayout(targetView: view)
			frameLayout.debug = debug
			frameLayout.ignoreHiddenView = ignoreHiddenView
			frameLayout.fixContentSize = fixItemSize
			frameLayout.minContentSize = minItemSize
			frameLayout.maxContentSize = maxItemSize
			frameLayouts.insert(frameLayout, at: index)
			addSubview(frameLayout)
			return frameLayout
		}
	}
	
	@discardableResult
	open func addSpace(_ size: CGFloat = 0) -> FrameLayout<T> {
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
	
	open func replace(_ frameLayout: FrameLayout<T>?, at index: Int, autoRemoveOldTargetView: Bool = false) {
		guard let frameLayout = frameLayout else {
			removeFrameLayout(at: index, autoRemoveTargetView: autoRemoveOldTargetView)
			return
		}
		
		let count = frameLayouts.count
		var currentFrameLayout: FrameLayout<T>? = nil
		
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
	
	public func invert() {
		frameLayouts = frameLayouts.reversed()
		setNeedsLayout()
	}
	
	// MARK: -
	
	public func frameLayout(at index: Int) -> FrameLayout<T>? {
		guard index >= 0 && index < frameLayouts.count else { return nil }
		return frameLayouts[index]
	}
	
	public func frameLayout(with view: T) -> FrameLayout<T>? {
		return frameLayouts.first(where: { $0.targetView == view })
	}
	
	public func enumerate(_ block: ((FrameLayout<T>, Int, inout Bool) -> Void)) {
		var stop: Bool = false
		var index = 0
		
		for layout in frameLayouts {
			block(layout, index, &stop)
			if stop { break }
			
			index += 1
		}
	}
	
	public func justified(threshold: CGFloat = 0) {
		justifyThreshold = threshold
		isJustified = true
	}
	
	// MARK: -
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		frameLayouts.forEach { $0.setNeedsLayout() }
	}
	
	fileprivate func visibleFrames() -> [FrameLayout<T>] {
		return frameLayouts.filter { !$0.isEmpty }
	}
	
	fileprivate func numberOfVisibleFrames() -> Int {
		return visibleFrames().count
	}
	
	// MARK: -
	
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
			
			if isOverlapped {
				result = .zero
				
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty { continue }
					
					let frameSize = frameLayout.sizeThatFits(contentSize)
					result.width = isIntrinsicSizeEnabled ? max(result.width, frameSize.width) : size.width
					result.height = max(result.height, frameSize.height)
				}
				
				if heightRatio > 0 { result.height = result.width * heightRatio }
				if result.width > 0 { result.width += verticalEdgeValues }
				if result.height > 0 { result.height += horizontalEdgeValues }
				
				result.width = min(result.width, size.width)
				result.height = min(result.height, size.height)
				
				return result
			}
			
			var gapSpace: CGFloat = 0
			var totalSpace: CGFloat = 0
			var frameContentSize: CGSize = .zero
			
			let isInvertedAlignment = distribution == .bottom || distribution == .right
			let activeFrameLayouts: [FrameLayout<T>] = (isInvertedAlignment ? frameLayouts.reversed() : frameLayouts)
			let lastFrameLayout: FrameLayout<T>? = activeFrameLayouts.last(where: { !$0.isEmpty })
			
			if axis == .horizontal {
				var maxHeight: CGFloat = 0
				
				switch distribution {
					case .left, .right, .top, .bottom, .center:
						var flexibleFrames = [FrameLayout<T>]()
						for frameLayout in activeFrameLayouts {
							if frameLayout.isEmpty { continue }
							
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
							let ratio = flexibleFrames.map { $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
							
							var ratioIndex = 0
							flexibleFrames.forEach {
								let ratioValue = ratio[ratioIndex]
								let cellWidth = contentWidth * ratioValue
								frameContentSize = CGSize(width: cellWidth, height: contentSize.height)
								frameContentSize = $0.sizeThatFits(frameContentSize)
								
								gapSpace = frameContentSize.width > 0 && $0 != lastFrameLayout ? spacing : 0
								totalSpace += frameContentSize.width + gapSpace
								maxHeight = max(maxHeight, frameContentSize.height)
								ratioIndex += 1
							}
						}
						
						break
					
					case .equal:
						let visibleFrameLayouts = visibleFrames()
						let visibleFrameCount = visibleFrameLayouts.count
						let spaces = CGFloat(visibleFrameCount - 1) * spacing
						let contentWidth = contentSize.width - spaces
						let cellWidth = contentWidth / CGFloat(visibleFrameCount)
						
						visibleFrameLayouts.forEach {
							frameContentSize = CGSize(width: cellWidth, height: contentSize.height).limitTo(minSize: $0.minSize, maxSize: $0.maxSize)
							frameContentSize = $0.sizeThatFits(frameContentSize)
							
							gapSpace = frameContentSize.width > 0 && $0 != lastFrameLayout ? spacing : 0
							totalSpace += frameContentSize.width + gapSpace
							maxHeight = max(maxHeight, frameContentSize.height)
						}
						
						break
					
					case .split(let ratio):
						let visibleFrameLayouts = visibleFrames()
						let visibleFrameCount = visibleFrameLayouts.count
						let spaces = CGFloat(visibleFrameCount - 1) * spacing
						let contentWidth = contentSize.width - spaces
						let finalRatio = ratio.autoFill(total: visibleFrameCount)
						
						var ratioIndex = 0
						visibleFrameLayouts.forEach {
							let ratioValue = finalRatio[ratioIndex]
							let cellWidth = contentWidth * ratioValue
							frameContentSize = CGSize(width: cellWidth, height: contentSize.height).limitTo(minSize: $0.minSize, maxSize: $0.maxSize)
							frameContentSize = $0.sizeThatFits(frameContentSize)
							
							gapSpace = frameContentSize.width > 0 && $0 != lastFrameLayout ? spacing : 0
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
				var flexibleFrames = [FrameLayout<T>]()
				for frameLayout in frameLayouts {
					if frameLayout.isEmpty { continue }
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
					let ratio = flexibleFrames.map { $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
					
					var ratioIndex = 0
					flexibleFrames.forEach {
						let ratioValue = ratio[ratioIndex]
						let cellHeight = contentHeight * ratioValue
						frameContentSize = CGSize(width: contentSize.width, height: cellHeight)
						frameContentSize = $0.sizeThatFits(frameContentSize)
						
						gapSpace = frameContentSize.height > 0 && $0 != lastFrameLayout ? spacing : 0
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
		
		if bounds.size == .zero { return }
		
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
		let invertedLayoutArray: [FrameLayout<T>] = frameLayouts.reversed()
		var lastFrameLayout: FrameLayout<T>? = (isInvertedAlignment ? frameLayouts : invertedLayoutArray).first(where: { !$0.isEmpty })
		
		if axis == .horizontal {
			switch distribution {
				case .top, .left:
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameContentSize = frameLayout.isFlexible ? CGSize(width: containerFrame.width * (frameLayout.flexibleRatio < 0.0 ? 1.0 : frameLayout.flexibleRatio), height: containerFrame.height) : frameLayout.sizeThatFits(containerFrame.size, ignoreHiddenView: false)
							targetFrame.origin.x = containerFrame.minX
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.height
							frameLayout.frame = targetFrame
						}
						break
					}
					
					var flexibleFrames = [FrameLayout<T>]()
					
					for frameLayout in frameLayouts {
						let isEmpty = frameLayout.isEmpty
						
						if frameLayout.isFlexible && !isEmpty {
							flexibleFrames.append(frameLayout)
							lastFrameLayout = frameLayout
							continue
						}
						
						frameContentSize = CGSize(width: containerFrame.width - usedSpace, height: containerFrame.height)
						let fitSize = frameLayout.sizeThatFits(frameContentSize, ignoreHiddenView: false)
						
						if frameLayout == lastFrameLayout && !frameLayout.isIntrinsicSizeEnabled {
							frameContentSize.height = fitSize.height
						}
						else {
							frameContentSize = fitSize
						}
						
						targetFrame.origin.x = containerFrame.minX + usedSpace
						targetFrame.size.width = frameContentSize.width
						frameLayout.frame = targetFrame
						
						if isEmpty { continue }
						
						gapSpace = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
					}
					
					let flexibleFrameCount = flexibleFrames.count
					if flexibleFrameCount > 0 {
						let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
						let contentWidth = containerFrame.width - usedSpace - remainingSpace
						let ratio = flexibleFrames.map { $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
						
						gapSpace = 0
						var ratioIndex = 0
						var offset: CGFloat = edgeInsets.left
						for frameLayout in frameLayouts {
							var rect = frameLayout.frame
							let isEmpty = frameLayout.isEmpty
							
							if frameLayout.isFlexible && !isEmpty {
								let ratioValue = ratio[ratioIndex]
								let cellWidth = contentWidth * ratioValue
								
								rect = targetFrame
								rect.size = CGSize(width: cellWidth, height: containerFrame.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
								ratioIndex += 1
							}
							
							if rect.minX != offset || frameLayout.frame.size != rect.size {
								rect.origin.x = offset
								frameLayout.frame = rect
							}
							
							if isEmpty { continue }
							
							gapSpace = rect.width > 0 ? spacing : 0
							offset += rect.width + gapSpace
						}
					}
					else if isJustified {
						let remainingWidth = containerFrame.width - usedSpace
						let numberOfSpaces = numberOfVisibleFrames() - 1
						
						if remainingWidth > justifyThreshold, numberOfSpaces > 0 {
							let spaces = CGFloat(numberOfSpaces)
							let extraValuePerSpace = (remainingWidth / spaces) + (spacing / spaces)
							let firstFrame = frameLayouts.first(where: { !$0.isEmpty })
							
							var index = 1
							for frameLayout in frameLayouts {
								if frameLayout == firstFrame { continue }
								var rect = frameLayout.frame
								rect.origin.x += extraValuePerSpace * CGFloat(index)
								frameLayout.frame = rect
								
								if !frameLayout.isEmpty { index += 1 }
							}
						}
					}
					
					break
				
				case .bottom, .right:
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size, ignoreHiddenView: false)
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.height
							targetFrame.origin.x = containerFrame.width - targetFrame.width
							frameLayout.frame = targetFrame
						}
						break
					}
					
					var flexibleFrames = [FrameLayout<T>]()
					
					for frameLayout in invertedLayoutArray {
						let isEmpty = frameLayout.isEmpty
						
						if frameLayout.isFlexible && !isEmpty {
							flexibleFrames.append(frameLayout)
							lastFrameLayout = frameLayout
							continue
						}
						
						if frameLayout == lastFrameLayout && !frameLayout.isIntrinsicSizeEnabled {
							targetFrame.origin.x = edgeInsets.left
							targetFrame.size.width = containerFrame.width - usedSpace
						}
						else {
							frameContentSize = CGSize(width: containerFrame.width - usedSpace, height: containerFrame.height)
							frameContentSize = frameLayout.sizeThatFits(frameContentSize, ignoreHiddenView: false)
							
							targetFrame.origin.x = max(bounds.width - frameContentSize.width - edgeInsets.right - usedSpace, 0)
							targetFrame.size.width = frameContentSize.width
						}
						
						frameLayout.frame = targetFrame
						
						if isEmpty { continue }
						
						gapSpace = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
					}
					
					let flexibleFrameCount = flexibleFrames.count
					if flexibleFrameCount > 0 {
						let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
						let contentWidth = containerFrame.width - usedSpace - remainingSpace
						let ratio = flexibleFrames.map { $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
						
						gapSpace = 0
						var ratioIndex = 0
						var offset: CGFloat = containerFrame.width + edgeInsets.left
						for frameLayout in invertedLayoutArray {
							var rect = frameLayout.frame
							let isEmpty = frameLayout.isEmpty
							
							if frameLayout.isFlexible && !isEmpty {
								let ratioValue = ratio[ratioIndex]
								let cellWidth = contentWidth * ratioValue
								
								rect = targetFrame
								rect.size = CGSize(width: cellWidth, height: containerFrame.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
								ratioIndex += 1
							}
							
							offset -= rect.width + gapSpace
							
							if rect.minX != offset || frameLayout.frame.size != rect.size {
								rect.origin.x = offset
								frameLayout.frame = rect
							}
							
							if isEmpty { continue }
							
							gapSpace = rect.width > 0 ? spacing : 0
						}
					}
					else if isJustified {
						let remainingWidth = containerFrame.width - usedSpace
						let numberOfSpaces = numberOfVisibleFrames() - 1
						
						if remainingWidth > justifyThreshold, numberOfSpaces > 0 {
							let spaces = CGFloat(numberOfSpaces)
							let extraValuePerSpace = (remainingWidth / spaces) + (spacing / spaces)
							let lastFrame = invertedLayoutArray.first(where: { !$0.isEmpty })
							
							var index = 1
							for frameLayout in invertedLayoutArray {
								if frameLayout == lastFrame { continue }
								var rect = frameLayout.frame
								rect.origin.x -= extraValuePerSpace * CGFloat(index)
								frameLayout.frame = rect
								if !frameLayout.isEmpty { index += 1 }
							}
						}
					}
					break
				
				case .equal:
					let visibleFrameLayouts = visibleFrames()
					let visibleFrameCount = visibleFrameLayouts.count
					let spaces = CGFloat(visibleFrameCount - 1) * spacing
					let cellWidth = (containerFrame.width - spaces) / CGFloat(Float(visibleFrameCount))
					
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : CGSize(width: cellWidth, height: containerFrame.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
							
							targetFrame.origin.x = containerFrame.minX
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.height
							frameLayout.frame = targetFrame
						}
						break
					}
					
					for frameLayout in frameLayouts {
						frameContentSize = CGSize(width: cellWidth, height: containerFrame.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
						targetFrame.origin.x = containerFrame.minX + usedSpace
						targetFrame.size.width = frameContentSize.width
						frameLayout.frame = targetFrame
						
						if frameLayout.isEmpty { continue }
						
						gapSpace = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
					}
					break
				
				case .split(let ratio):
					let visibleFrameCount = numberOfVisibleFrames()
					let spaces: CGFloat = CGFloat(visibleFrameCount - 1) * spacing
					let contentWidth = containerFrame.width - spaces
					let finalRatio = ratio.autoFill(total: visibleFrameCount)
					
					var ratioIndex = 0
					
					if isOverlapped {
						for frameLayout in frameLayouts {
							let ratioValue = finalRatio[ratioIndex]
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : CGSize(width: contentWidth * ratioValue, height: containerFrame.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
							
							targetFrame.origin.x = containerFrame.minX
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.height
							frameLayout.frame = targetFrame
							ratioIndex += 1
						}
						break
					}
					
					for frameLayout in frameLayouts {
						let ratioValue = finalRatio[ratioIndex]
						let cellWidth = contentWidth * ratioValue
						frameContentSize = CGSize(width: cellWidth, height: containerFrame.height).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
						
						targetFrame.origin.x = containerFrame.minX + usedSpace
						targetFrame.size.width = frameContentSize.width
						frameLayout.frame = targetFrame
						
						if frameLayout.isEmpty { continue }
						
						gapSpace = frameContentSize.width > 0 ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
						ratioIndex += 1
					}
					
					break
				
				case .center:
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size, ignoreHiddenView: false)
							targetFrame.size.width = frameContentSize.width
							targetFrame.size.height = containerFrame.height
							targetFrame.origin.x = containerFrame.minX + (containerFrame.width - targetFrame.width)/2
							frameLayout.frame = targetFrame
						}
						break
					}
					
					for frameLayout in frameLayouts {
						frameContentSize = containerFrame.size
						let fitSize = frameLayout.sizeThatFits(frameContentSize, ignoreHiddenView: false)
						frameContentSize.width = fitSize.width
						
						targetFrame.origin.x = containerFrame.minX + usedSpace
						targetFrame.size = frameContentSize
						frameLayout.frame = targetFrame
						
						if frameLayout.isEmpty { continue }
						
						gapSpace = frameContentSize.width > 0 && frameLayout != lastFrameLayout ? spacing : 0
						usedSpace += frameContentSize.width + gapSpace
					}
					
					let offset = (containerFrame.width - usedSpace) / 2.0
					for frameLayout in frameLayouts {
						frameLayout.frame = frameLayout.frame.offsetBy(dx: offset, dy: 0)
					}
					
					break
			}
		}
		else { // if axis == .vertical
			switch distribution {
				case .top, .left:
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size, ignoreHiddenView: false)
							targetFrame.origin.y = containerFrame.minY
							targetFrame.size.width = containerFrame.width
							targetFrame.size.height = frameContentSize.height
							frameLayout.frame = targetFrame
						}
						break
					}
					
					var flexibleFrames = [FrameLayout<T>]()
					
					for frameLayout in frameLayouts {
						let isEmpty = frameLayout.isEmpty
						
						if frameLayout.isFlexible && !isEmpty {
							flexibleFrames.append(frameLayout)
							continue
						}
						
						frameContentSize = CGSize(width: containerFrame.width, height: containerFrame.height - usedSpace)
						let fitSize = frameLayout.sizeThatFits(frameContentSize, ignoreHiddenView: false)
						
						if frameLayout == lastFrameLayout && !frameLayout.isIntrinsicSizeEnabled {
							frameContentSize.width = fitSize.width
						}
						else {
							frameContentSize = fitSize
						}
						
						targetFrame.origin.y = containerFrame.minY + usedSpace
						targetFrame.size.height = frameContentSize.height
						frameLayout.frame = targetFrame
						
						if isEmpty { continue }
						
						gapSpace = frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + gapSpace
					}
					
					let flexibleFrameCount = flexibleFrames.count
					if flexibleFrameCount > 0 {
						let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
						let contentHeight = containerFrame.height - usedSpace - remainingSpace
						let ratio = flexibleFrames.map { $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
						
						gapSpace = 0
						var ratioIndex = 0
						var offset = edgeInsets.top
						for frameLayout in frameLayouts {
							var rect = frameLayout.frame
							let isEmpty = frameLayout.isEmpty
							
							if frameLayout.isFlexible && !isEmpty {
								let ratioValue = ratio[ratioIndex]
								let cellHeight = contentHeight * ratioValue
								
								rect = targetFrame
								rect.size = CGSize(width: containerFrame.width, height: cellHeight).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
								ratioIndex += 1
							}
							
							if rect.minY != offset || frameLayout.frame.size != rect.size {
								rect.origin.y = offset
								frameLayout.frame = rect
							}
							
							if isEmpty { continue }
							
							gapSpace = rect.height > 0 ? spacing : 0
							offset += rect.height + gapSpace
						}
					}
					else if isJustified {
						let remainingHeight = containerFrame.height - usedSpace
						let numberOfSpaces = numberOfVisibleFrames() - 1
						
						if remainingHeight > justifyThreshold, numberOfSpaces > 0 {
							let spaces = CGFloat(numberOfSpaces)
							let extraValuePerSpace = (remainingHeight / spaces) + (spacing / spaces)
							let firstFrame = frameLayouts.first(where: { !$0.isEmpty })
							
							var index = 1
							for frameLayout in frameLayouts {
								if frameLayout == firstFrame { continue }
								var rect = frameLayout.frame
								rect.origin.y += extraValuePerSpace * CGFloat(index)
								frameLayout.frame = rect
								if !frameLayout.isEmpty { index += 1 }
							}
						}
					}
					break
				
				case .bottom, .right:
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size, ignoreHiddenView: false)
							targetFrame.size.width = containerFrame.width
							targetFrame.size.height = frameContentSize.height
							targetFrame.origin.y = containerFrame.minY + (containerFrame.height - targetFrame.height)
							frameLayout.frame = targetFrame
						}
						break
					}
					
					var flexibleFrames = [FrameLayout<T>]()
					
					for frameLayout in invertedLayoutArray {
						let isEmpty = frameLayout.isEmpty
						
						if frameLayout.isFlexible && !isEmpty {
							flexibleFrames.append(frameLayout)
							continue
						}
						
						if frameLayout == lastFrameLayout && !frameLayout.isIntrinsicSizeEnabled {
							targetFrame.origin.y = edgeInsets.top
							targetFrame.size.height = containerFrame.height - usedSpace
						}
						else {
							frameContentSize = CGSize(width: containerFrame.width, height: containerFrame.height - usedSpace)
							frameContentSize = frameLayout.sizeThatFits(frameContentSize, ignoreHiddenView: false)
							
							targetFrame.origin.y = max(bounds.height - frameContentSize.height - edgeInsets.bottom - usedSpace, 0)
							targetFrame.size.height = frameContentSize.height
						}
						
						frameLayout.frame = targetFrame
						
						if isEmpty { continue }
						
						gapSpace = frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + gapSpace
					}
					
					let flexibleFrameCount = flexibleFrames.count
					if flexibleFrameCount > 0 {
						let remainingSpace = CGFloat(flexibleFrameCount - 1) * spacing
						let contentHeight = containerFrame.height - usedSpace - remainingSpace
						let ratio = flexibleFrames.map { $0.flexibleRatio }.autoFill(total: flexibleFrameCount)
						
						gapSpace = 0
						var ratioIndex = 0
						var offset = containerFrame.maxY
						for frameLayout in invertedLayoutArray {
							var rect = frameLayout.frame
							let isEmpty = frameLayout.isEmpty
							
							if frameLayout.isFlexible && !isEmpty {
								let ratioValue = ratio[ratioIndex]
								let cellHeight = contentHeight * ratioValue
								
								rect = targetFrame
								rect.size = CGSize(width: containerFrame.width, height: cellHeight).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
								ratioIndex += 1
							}
							
							if isEmpty { continue }
							
							offset -= rect.height + gapSpace
							
							if rect.minY != offset || frameLayout.frame.size != rect.size {
								rect.origin.y = offset
								frameLayout.frame = rect
							}
							
							gapSpace = rect.height > 0 ? spacing : 0
						}
					}
					else if isJustified {
						let remainingHeight = containerFrame.height - usedSpace
						let numberOfSpaces = numberOfVisibleFrames() - 1
						
						if remainingHeight > justifyThreshold, numberOfSpaces > 0 {
							let spaces = CGFloat(numberOfSpaces)
							let extraValuePerSpace = (remainingHeight / spaces) + (spacing / spaces)
							let firstFrame = frameLayouts.first(where: { !$0.isEmpty })
							
							var index = 1
							for frameLayout in frameLayouts {
								if frameLayout == firstFrame { continue }
								var rect = frameLayout.frame
								rect.origin.y -= extraValuePerSpace * CGFloat(index)
								frameLayout.frame = rect
								if !frameLayout.isEmpty { index += 1 }
							}
						}
					}
					break
				
				case .equal:
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameLayout.frame = containerFrame
						}
						break
					}
					
					let visibleFrameLayouts = visibleFrames()
					let visibleFrameCount = visibleFrameLayouts.count
					let spaces = CGFloat(visibleFrameCount - 1) * spacing
					let cellSize = (containerFrame.height - spaces) / CGFloat(Float(visibleFrameCount))
					
					for frameLayout in frameLayouts {
						frameContentSize = CGSize(width: containerFrame.width, height: cellSize)
						//if frameLayout.isIntrinsicSizeEnabled frameContentSize = frameLayout.sizeThatFits(frameContentSize, ignoreHiddenView: false)
						
						targetFrame.origin.y = containerFrame.minY + usedSpace
						targetFrame.size.height = frameContentSize.height
						frameLayout.frame = targetFrame
						
						if frameLayout.isEmpty { continue }
						
						usedSpace += frameContentSize.height + spacing
					}
					break
				
				case .center:
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size, ignoreHiddenView: false)
							targetFrame.size.width = containerFrame.width
							targetFrame.size.height = frameContentSize.height
							targetFrame.origin.y = containerFrame.minY + (containerFrame.height - targetFrame.width)/2
							frameLayout.frame = targetFrame
						}
						break
					}
					
					for frameLayout in frameLayouts {
						frameContentSize = containerFrame.size
						let fitSize = frameLayout.sizeThatFits(frameContentSize, ignoreHiddenView: false)
						frameContentSize.height = fitSize.height
						
						targetFrame.origin.y = containerFrame.minY + usedSpace
						targetFrame.size = frameContentSize
						frameLayout.frame = targetFrame
						
						if frameLayout.isEmpty { continue }
						
						gapSpace = frameContentSize.height > 0 && frameLayout != lastFrameLayout ? spacing : 0
						usedSpace += frameContentSize.height + gapSpace
					}
					
					let offset = (containerFrame.height - usedSpace) / 2.0
					for frameLayout in frameLayouts {
						frameLayout.frame = frameLayout.frame.offsetBy(dx: 0, dy: offset)
					}
					break
				
				case .split(let ratio):
					let visibleFrameLayouts = visibleFrames()
					let visibleFrameCount = visibleFrameLayouts.count
					let spaces = CGFloat(visibleFrameCount - 1) * spacing
					let contentHeight = containerFrame.height - spaces
					
					if isOverlapped {
						for frameLayout in frameLayouts {
							frameContentSize = frameLayout.isFlexible ? containerFrame.size : frameLayout.sizeThatFits(containerFrame.size, ignoreHiddenView: false).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
							targetFrame.origin.y = containerFrame.minY
							targetFrame.size.width = containerFrame.width
							targetFrame.size.height = frameContentSize.height
							frameLayout.frame = targetFrame
						}
						break
					}
					
					let finalRatio = ratio.autoFill(total: visibleFrameCount)
					
					var ratioIndex = 0
					for frameLayout in frameLayouts {
						let ratioValue = finalRatio[ratioIndex]
						let cellHeight = contentHeight * ratioValue
						frameContentSize = CGSize(width: containerFrame.width, height: cellHeight).limitTo(minSize: frameLayout.minSize, maxSize: frameLayout.maxSize)
						
						targetFrame.origin.y = containerFrame.minY + usedSpace
						targetFrame.size.height = frameContentSize.height
						frameLayout.frame = targetFrame
						
						if frameLayout.isEmpty { continue }
						
						gapSpace = frameContentSize.height > 0 ? spacing : 0
						usedSpace += frameContentSize.height + gapSpace
						ratioIndex += 1
					}
					break
			}
		}
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
