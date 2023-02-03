//
//  FrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/12/18.
//

import UIKit
import CoreGraphics

public enum NKContentVerticalAlignment {
	case center
	case top
	case bottom
	case fill
	case fit
}

public enum NKContentHorizontalAlignment {
	case center
	case left
	case right
	case fill
	case fit
}

/**
FrameLayout is the fundamental component of the kit. This class will automatically adjust the size and position of the view assigned to it based on the size and position of the frameLayout itself, and the specified alignment value.
*/
open class FrameLayout<T: UIView>: UIView {
//	/// Show warnings on debug console when adding a UIControl without `isUserInteractionEnabled` turned on, which will make that control untouchabe
//	public static var showDebugWarnings = false
	/// Target view that handled by this frameLayout
	public var targetView: T? = nil
	/// Additional views that will have their frames binding to `targetView`'s frame
	public var bindingViews: [UIView]?
	/// edgeInsets that will be applied to binding views
	public var bindingEdgeInsets: UIEdgeInsets = .zero
	/// other views that will be binded to this frame
	public var lazyBindingViews: (() -> [UIView?]?)?
	/// If set to `true`, `sizeThatFits(size:)` will returns `.zero` if `targetView` is hidden.
	public var ignoreHiddenView = true
	/// If set to `false`, it will return .zero in sizeThatFits and ignore running layoutSubviews. It will also ignore `willSizeThatFits` and `willLayoutSubviews` blocks.
	public var isEnabled = true
	/// Padding edge insets
	public var edgeInsets: UIEdgeInsets = .zero
	/// Add translation position to view
	public var translationOffset: CGPoint = .zero
	/// Add x translation to view
	public var translationX: CGFloat {
		get { translationOffset.x }
		set {
			translationOffset.x = newValue
			setNeedsLayout()
		}
	}
	/// Add y translation to view
	public var translationY: CGFloat {
		get { translationOffset.y }
		set {
			translationOffset.y = newValue
			setNeedsLayout()
		}
	}
	/// Minimum size of this frameLayout
	public var minSize: CGSize = .zero
	/// Mininum width of this frameLayout
	public var minWidth: CGFloat {
		get { minSize.width }
		set { minSize.width = newValue }
	}
	/// Mininum height of this frameLayout
	public var minHeight: CGFloat {
		get { minSize.height }
		set { minSize.height = newValue }
	}
	/// Maximum size of frameLayout
	public var maxSize: CGSize = .zero
	/// Maximum width of this frameLayout
	public var maxWidth: CGFloat {
		get { maxSize.width }
		set { maxSize.width = newValue }
	}
	/// Maximum height of this frameLayout
	public var maxHeight: CGFloat {
		get { maxSize.height }
		set { maxSize.height = newValue }
	}
	/// Minimum size of `targetView`
	public var minContentSize: CGSize = .zero
	/// Mininum width of `targetView`
	public var minContentWidth: CGFloat {
		get { minContentSize.width }
		set { minContentSize.width = newValue }
	}
	/// Mininum height of `targetView`
	public var minContentHeight: CGFloat {
		get { minContentSize.height }
		set { minContentSize.height = newValue }
	}
	/// Maximum size of targetView
	public var maxContentSize: CGSize = .zero
	/// Maximum width of `targetView`
	public var maxContentWidth: CGFloat {
		get { maxContentSize.width }
		set { maxContentSize.width = newValue }
	}
	/// Maximum height of `targetView`
	public var maxContentHeight: CGFloat {
		get { maxContentSize.height }
		set { maxContentSize.height = newValue }
	}
	/// Adding size to content size. `minSize` and `maxSize` is still the limitation.
	public var extendSize: CGSize = .zero
	/// Extending width to content size
	public var extendWidth: CGFloat {
		get { extendSize.width }
		set { extendSize.width = newValue }
	}
	/// Extending height to content size
	public var extendHeight: CGFloat {
		get { extendSize.height }
		set { extendSize.height = newValue }
	}
	/// Width of `targetView` will be stretched out to fill frameLayout if the width of this frameLayout is larger than `targetView`'s width
	public var allowContentVerticalGrowing = false
	/// Width of `targetView` will be shrinked down to fit frameLayout if the width of this frameLayout is smaller than `targetView`'s width
	public var allowContentVerticalShrinking = false
	/// Height of `targetView` will be stretched out to fill frameLayout if the height of this frameLayout is larger than `targetView`'s height
	public var allowContentHorizontalGrowing = false
	/// Height of `targetView` will be shrinked down to fit frameLayout if the height of this frameLayout is smaller than `targetView`'s height
	public var allowContentHorizontalShrinking = false
	/// Value of `sizeThatFits` will be cached based on `targetView`'s memory address. This is not proved for better performance, use it with care. Default is `false`
	public var shouldCacheSize = false
	/// Make it flexible in a `StackFrameLayout`, that means when it was added to a stack, this flexible stack will be stretched base on the stack size
	public var isFlexible = false
	/// Ratio used in `StackFrameLayout` when `isFlexible` = true. Default value is auto (`-1`)
	public var flexibleRatio: CGFloat = -1
	/// if `true`, `sizeThatFits` will returns the intrinsic width of `targetView`
	public var isIntrinsicSizeEnabled = true
	/// Returns height from `sizeThatFits` base on ratio of width. For example setting `1.0` will returns a square size from `sizeThatFits`
	public var heightRatio: CGFloat = 0 {
		didSet {
			if heightRatio > 0 {
				isIntrinsicSizeEnabled = false
			}
		}
	}
	
	/// Show the dash line of the frameLayout for debugging. This works in development mode only, released version will ignore this
	public var debug: Bool = false {
		didSet {
			#if DEBUG
			setNeedsDisplay()
			#endif
		}
	}
	
	/// Set the color of debug line
	public var debugColor: UIColor? = nil {
		didSet {
			#if DEBUG
			setNeedsDisplay()
			#endif
		}
	}
	
	/// Set the fixed size of frameLayout
	public var fixedSize: CGSize = .zero {
		didSet {
			minSize = fixedSize
			maxSize = fixedSize
		}
	}
	
	public var fixedWidth: CGFloat {
		get { fixedSize.width }
		set { fixedSize.width = newValue }
	}
	
	public var fixedHeight: CGFloat {
		get { fixedSize.height }
		set { fixedSize.height = newValue }
	}
	
	/// Set the fixed size of targetView
	public var fixedContentSize: CGSize = .zero {
		didSet {
			minContentSize = fixedContentSize
			maxContentSize = fixedContentSize
		}
	}
	
	public var fixedContentWidth: CGFloat {
		get { fixedContentSize.width }
		set { fixedContentSize.width = newValue }
	}
	
	public var fixedContentHeight: CGFloat {
		get { fixedContentSize.height }
		set { fixedContentSize.height = newValue }
	}
	
	/// Set the alignment of both axis
	public var alignment: (vertical: NKContentVerticalAlignment, horizontal: NKContentHorizontalAlignment) = (.fill, .fill)
	
	/// Block will be called before calling sizeThatFits
	public var willSizeThatFitsBlock: ((FrameLayout, CGSize) -> Void)?
	/// Block will be called before calling layoutSubviews
	public var willLayoutSubviewsBlock: ((FrameLayout) -> Void)?
	/// Block will be called at the end of layoutSubviews function
	public var didLayoutSubviewsBlock: ((FrameLayout) -> Void)?
	
	override open var frame: CGRect {
		get { super.frame }
		set {
			if newValue.isInfinite || newValue.isNull || newValue.minX.isNaN || newValue.minY.isNaN || newValue.width.isNaN || newValue.height.isNaN { return }
			
			super.frame = newValue
			setNeedsLayout()
			
			#if DEBUG
			if debug {
				setNeedsDisplay()
			}
			#endif
			
			if superview == nil {
				layoutIfNeeded()
			}
		}
	}
	
	override open var bounds: CGRect {
		get { super.bounds }
		set {
			if newValue.isInfinite || newValue.isNull || newValue.minX.isNaN || newValue.minY.isNaN || newValue.width.isNaN || newValue.height.isNaN { return }
			
			super.bounds = newValue
			setNeedsLayout()
			
			#if DEBUG
			if debug {
				setNeedsDisplay()
			}
			#endif
			
			if superview == nil {
				layoutIfNeeded()
			}
		}
	}
	
	open override var description: String {
		return "[\(super.description)]-targetView: \(String(describing: targetView))"
	}
	
	lazy fileprivate var sizeCacheData: [String: CGSize] = {
		return [:]
	}()
	
	/// Returns `true` if `targetView` is nil or hidden. And if `ignoreHiddenView` is `true`
	public var isEmpty: Bool {
		return ((targetView?.isHidden ?? false || isHidden) && ignoreHiddenView)
	}
	
	/// Returns intrinsic content size
	open override var intrinsicContentSize: CGSize {
		return contentSizeThatFits(size: bounds.size)
	}
	
	// MARK: -
	
	@discardableResult
	public convenience init(_ block: (FrameLayout) throws -> Void) rethrows {
		self.init()
		try block(self)
	}
	
	convenience public init(targetView: T? = nil) {
		self.init()
		self.targetView = targetView
	}
	
	public required init() {
		super.init(frame: .zero)
		
		backgroundColor = .clear
		isUserInteractionEnabled = false
		isIntrinsicSizeEnabled = true
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	@discardableResult
	open func flexible(ratio: CGFloat = -1) -> Self {
		isFlexible = true
		flexibleRatio = ratio
		return self
	}
	
	@discardableResult
	open func inflexible() -> Self {
		isFlexible = false
		return self
	}
	
	@discardableResult
	open func padding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
		edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
		return self
	}
	
	@discardableResult
	open func addPadding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
		edgeInsets = UIEdgeInsets(top: edgeInsets.top + top, left: edgeInsets.left + left, bottom: edgeInsets.bottom + bottom, right: edgeInsets.right + right)
		return self
	}
	
	#if DEBUG
	override open func draw(_ rect: CGRect) {
		guard debug, !isEmpty, bounds != .zero else {
			super.draw(rect)
			return
		}
		
		if debugColor == nil {
			debugColor = randomColor()
		}
		
		guard let context = UIGraphicsGetCurrentContext() else { return }
		context.saveGState()
		context.setStrokeColor(debugColor!.cgColor)
		context.setLineDash(phase: 0, lengths: [4.0, 2.0])
		context.stroke(bounds)
		context.restoreGState()
	}
	
	fileprivate func randomColor() -> UIColor {
		let colors: [UIColor] = [.red, .green, .blue, .brown, .gray, .yellow, .magenta, .black, .orange, .purple, .cyan]
		let randomIndex = Int(arc4random()) % colors.count
		return colors[randomIndex]
	}
	#endif
	
	open func sizeThatFits(_ size: CGSize, intrinsic: Bool = true) -> CGSize {
		isIntrinsicSizeEnabled = intrinsic
		return sizeThatFits(size)
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		return sizeThatFits(size, ignoreHiddenView: true)
	}
	
	open func sizeThatFits(_ size: CGSize, ignoreHiddenView: Bool) -> CGSize {
		if !isEnabled { return .zero }
		
		willSizeThatFitsBlock?(self, size)
		guard !isEmpty || !ignoreHiddenView else { return .zero }
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 { return minSize }
		
		var result: CGSize = .zero
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		let contentSize = CGSize(width: max(size.width - verticalEdgeValues, 0), height: max(size.height - horizontalEdgeValues, 0))
		
		if heightRatio > 0 {
			result.width = isIntrinsicSizeEnabled ? contentSizeThatFits(size: contentSize).width : contentSize.width
			result.height = result.width * heightRatio
		}
		else {
			result = contentSizeThatFits(size: contentSize)
			
			if !isIntrinsicSizeEnabled {
				result.width = contentSize.width
			}
		}
		
		result.limitedTo(minSize: minSize, maxSize: maxSize)
		
		if result.width > 0 { result.width += verticalEdgeValues }
		if result.height > 0 { result.height += horizontalEdgeValues }
		
		result.width = min(result.width, size.width)
		result.height = min(result.height, size.height)
		
		return result
	}
	
	override open func layoutSubviews() {
		if !isEnabled { return }
		
		willLayoutSubviewsBlock?(self)
		super.layoutSubviews()
		
		defer {
			didLayoutSubviewsBlock?(self)
		}
		
		guard let targetView = targetView, !bounds.isEmpty else {
			var bindViews = bindingViews ?? []
			if let views = lazyBindingViews?() { bindViews.append(contentsOf: views.compactMap {$0}) }
			
			guard !bindViews.isEmpty else { return }
			#if swift(>=4.2)
			let targetFrame = frame.inset(by: bindingEdgeInsets)
			#else
			let targetFrame = UIEdgeInsetsInsetRect(frame, bindingEdgeInsets)
			#endif
			guard !targetFrame.isEmpty else { return }
			
			bindViews.forEach {
				if $0.superview == self.targetView {
					$0.frame = CGRect(origin: .zero, size: targetFrame.size)
				}
				else if $0.superview != superview, let superView1 = $0.superview, let superView2 = superview {
					$0.frame = superView2.convert(targetFrame, to: superView1)
				}
				else {
					$0.frame = targetFrame
				}
			}
			
			return
		}
		
		var targetFrame: CGRect = .zero
		#if swift(>=4.2)
		let containerFrame = bounds.inset(by: edgeInsets)
		#else
		let containerFrame = UIEdgeInsetsInsetRect(bounds, edgeInsets)
		#endif
		let contentSize = (alignment.horizontal != .fill || alignment.vertical != .fill) || (minContentSize != .zero || maxContentSize != .zero) ? contentSizeThatFits(size: containerFrame.size) : .zero
		
		switch alignment.horizontal {
		case .left:
			if allowContentHorizontalGrowing {
				targetFrame.size.width = max(containerFrame.width, contentSize.width)
			}
			else {
				targetFrame.size.width = allowContentHorizontalShrinking ? min(containerFrame.width, contentSize.width) : contentSize.width
			}
			
			targetFrame.origin.x = containerFrame.minX
			break
			
		case .right:
			if allowContentHorizontalGrowing {
				targetFrame.size.width = max(containerFrame.width, contentSize.width)
			}
			else {
				targetFrame.size.width = allowContentHorizontalShrinking ? min(containerFrame.width, contentSize.width) : contentSize.width
			}
			
			targetFrame.origin.x = containerFrame.maxX - targetFrame.width
			break
			
		case .center:
			if allowContentHorizontalGrowing {
				targetFrame.size.width = max(containerFrame.width, contentSize.width)
			}
			else {
				targetFrame.size.width = allowContentHorizontalShrinking ? min(containerFrame.width, contentSize.width) : contentSize.width
			}
			
			targetFrame.origin.x = containerFrame.minX + (containerFrame.width - targetFrame.width) / 2
			break
			
		case .fill:
			targetFrame.origin.x = containerFrame.minX
			targetFrame.size.width = containerFrame.width
			break
			
		case .fit:
			if allowContentHorizontalGrowing {
				targetFrame.size.width = max(containerFrame.width, contentSize.width)
			}
			else {
				targetFrame.size.width = min(containerFrame.width, contentSize.width)
			}
			
			targetFrame.origin.x = containerFrame.minX + (containerFrame.width - targetFrame.width) / 2
			break
		}
		
		switch alignment.vertical {
		case .top:
			if allowContentVerticalGrowing {
				targetFrame.size.height = max(containerFrame.height, contentSize.height)
			}
			else if allowContentVerticalShrinking {
				targetFrame.size.height = min(containerFrame.height, contentSize.height)
			}
			else {
				targetFrame.size.height = contentSize.height
			}
			
			targetFrame.origin.y = containerFrame.minY
			break
		
		case .bottom:
			if allowContentVerticalGrowing {
				targetFrame.size.height = max(containerFrame.height, contentSize.height)
			}
			else if allowContentVerticalShrinking {
				targetFrame.size.height = min(containerFrame.height, contentSize.height)
			}
			else {
				targetFrame.size.height = contentSize.height
			}
			
			targetFrame.origin.y = containerFrame.maxY - contentSize.height
			break
			
		case .center:
			if allowContentVerticalGrowing {
				targetFrame.size.height = max(containerFrame.height, contentSize.height)
			}
			else if allowContentVerticalShrinking {
				targetFrame.size.height = min(containerFrame.height, contentSize.height)
			}
			else {
				targetFrame.size.height = contentSize.height
			}
			
			targetFrame.origin.y = containerFrame.minY + (containerFrame.height - contentSize.height) / 2
			break
			
		case .fill:
			targetFrame.origin.y = containerFrame.minY
			targetFrame.size.height = containerFrame.height
			break
			
		case .fit:
			if allowContentVerticalGrowing {
				targetFrame.size.height = max(containerFrame.height, contentSize.height)
			}
			else {
				targetFrame.size.height = min(containerFrame.height, contentSize.height)
			}
			
			targetFrame.origin.y = containerFrame.minY + (containerFrame.height - targetFrame.height) / 2
			break
		}
		
		targetFrame.size.limitedTo(minSize: minContentSize, maxSize: maxContentSize)
		targetFrame = targetFrame.integral
		targetFrame = targetFrame.offsetBy(dx: translationOffset.x, dy: translationOffset.y)
		
		if targetView.superview == self {
			targetView.frame = targetFrame
		}
		else {
			if superview == nil || window == nil  {
				targetFrame.origin.x = frame.minX
				targetFrame.origin.y = frame.minY
				
				var superView: UIView? = superview
				while superView != nil && (superView is FrameLayout) {
					targetFrame.origin.x += superView!.frame.minX
					targetFrame.origin.y += superView!.frame.minY
					superView = superView!.superview
				}
				
				targetView.frame = targetFrame.offsetBy(dx: translationOffset.x, dy: translationOffset.y)
			}
			else {
				targetView.frame = convert(targetFrame, to: targetView.superview)
			}
		}
		
		var bindViews = bindingViews ?? []
		if let views = lazyBindingViews?() { bindViews.append(contentsOf: views.compactMap {$0}) }
		
		guard !bindViews.isEmpty else { return }
		#if swift(>=4.2)
		targetFrame = targetView.frame.inset(by: bindingEdgeInsets)
		#else
		targetFrame = UIEdgeInsetsInsetRect(targetView.frame, bindingEdgeInsets)
		#endif
		bindViews.forEach {
			if $0.superview == targetView {
				$0.frame = CGRect(origin: .zero, size: targetFrame.size)
			}
			else if $0.superview != targetView.superview, let superView1 = $0.superview, let superView2 = targetView.superview {
				$0.frame = superView2.convert(targetFrame, to: superView1)
			}
			else {
				$0.frame = targetFrame
			}
		}
	}
	
	open override func didMoveToWindow() {
		super.didMoveToWindow()
		setNeedsLayout()
	}
	
	open override func didMoveToSuperview() {
		super.didMoveToSuperview()
		setNeedsLayout()
	}
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		targetView?.setNeedsLayout()
	}
	
	override open func layoutIfNeeded() {
		super.layoutIfNeeded()
		targetView?.layoutIfNeeded()
	}
	
	// MARK: -
	
	fileprivate func addressOf<T: AnyObject>(_ o: T) -> String {
		let addr = unsafeBitCast(o, to: Int.self)
		return String(format: "%p", addr)
	}
	
	fileprivate func contentSizeThatFits(size: CGSize) -> CGSize {
		guard let targetView = targetView else { return .zero }
		
		if minContentSize == maxContentSize && minContentSize.width > 0 && minContentSize.height > 0 { return minContentSize }
		
		var result: CGSize
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			result = minSize // fixedSize
		}
		else {
			if shouldCacheSize {
				let key = "\(addressOf(targetView))_\(size)"
				if let value = sizeCacheData[key] {
					return value
				}
				else {
					result = targetView.sizeThatFits(size)
					sizeCacheData[key] = result
				}
			}
			else {
				result = targetView.sizeThatFits(size)
			}
			
			result.width += extendSize.width
			result.height += extendSize.height
			
			result.limitedTo(minSize: minSize, maxSize: maxSize)
		}
		
		result.limitedTo(minSize: minContentSize, maxSize: maxContentSize)
		return result
	}
	
}
