//
//  FrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/12/18.
//

import UIKit

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

open class FrameLayout: UIView {
	public var targetView: UIView? = nil
	public var ignoreHiddenView = true
	public var edgeInsets: UIEdgeInsets = .zero
	public var minSize: CGSize = .zero
	public var maxSize: CGSize = .zero
	public var verticalAlignment: NKContentVerticalAlignment = .fill
	public var horizontalAlignment: NKContentHorizontalAlignment = .fill
	public var allowContentVerticalGrowing = false
	public var allowContentVerticalShrinking = false
	public var allowContentHorizontalGrowing = false
	public var allowContentHorizontalShrinking = false
	public var shouldCacheSize = false
	public var isFlexible = false
	public var isIntrinsicSizeEnabled = true
	public var contentSize: CGSize = .zero
	public var heightRatio: CGFloat = 0 {
		didSet {
			if heightRatio > 0 {
				isIntrinsicSizeEnabled = false
			}
		}
	}
	
	@available(*, deprecated, renamed: "debug")
	public var showFrameDebug: Bool {
		get {
			return debug
		}
		set {
			debug = newValue
		}
	}
	
	public var debug: Bool = false {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var debugColor: UIColor? = nil {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var fixSize: CGSize = .zero {
		didSet {
			minSize = fixSize
			maxSize = fixSize
		}
	}
	
	@available(*, deprecated, renamed: "alignment")
	public var contentAlignment: (vertical: NKContentVerticalAlignment, horizontal: NKContentHorizontalAlignment) = (.fill, .fill) {
		didSet {
			verticalAlignment = contentAlignment.vertical
			horizontalAlignment = contentAlignment.horizontal
			
			setNeedsLayout()
		}
	}
	
	public var alignment: (vertical: NKContentVerticalAlignment, horizontal: NKContentHorizontalAlignment) = (.fill, .fill) {
		didSet {
			verticalAlignment = alignment.vertical
			horizontalAlignment = alignment.horizontal
			
			setNeedsLayout()
		}
	}
	
	@available(*, deprecated, message: "use `with` instead")
	public var configurationBlock: ((_ frameLayout: FrameLayout) -> Void)? = nil {
		didSet {
			configurationBlock?(self)
		}
	}
	
	/// Block will be called before calling sizeThatFits
	public var preSizeThatFitsConfigurationBlock: ((_ frameLayout: FrameLayout) -> Void)?
	/// Block will be called before calling layoutSubviews
	public var preLayoutConfigurationBlock: ((_ frameLayout: FrameLayout) -> Void)?
	
	override open var frame: CGRect {
		get {
			return super.frame
		}
		set {
			if newValue.isInfinite || newValue.isNull || newValue.origin.x.isNaN || newValue.origin.y.isNaN || newValue.size.width.isNaN || newValue.size.height.isNaN {
				return
			}
			
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
		get {
			return super.bounds
		}
		set {
			if newValue.isInfinite || newValue.isNull || newValue.origin.x.isNaN || newValue.origin.y.isNaN || newValue.size.width.isNaN || newValue.size.height.isNaN {
				return
			}
			
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
	
	internal var isEmpty: Bool {
		return ((targetView?.isHidden ?? false || isHidden) && ignoreHiddenView)
	}
	
	// MARK: -
	
	@discardableResult
	public convenience init(_ block: (FrameLayout) throws -> Void) rethrows {
		self.init()
		try block(self)
	}
	
	convenience public init(targetView: UIView? = nil) {
		self.init()
		self.targetView = targetView
	}
	
	public init() {
		super.init(frame: .zero)
		
		backgroundColor = .clear
		isUserInteractionEnabled = false
		isIntrinsicSizeEnabled = true
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	open func flexible() {
		isFlexible = true
	}
	
	open func padding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
		edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
	
	open func addPadding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
		edgeInsets = UIEdgeInsets(top: edgeInsets.top + top, left: edgeInsets.left + left, bottom: edgeInsets.bottom + bottom, right: edgeInsets.right + right)
	}
	
	#if DEBUG
	override open func draw(_ rect: CGRect) {
		guard debug else {
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
		let colors: [UIColor] = [.red, .green, .blue, .brown, .gray, .yellow, .magenta, .black, .orange, .purple]
		let randomIndex = Int(arc4random()) % colors.count
		return colors[randomIndex]
	}
	#endif
	
	public func sizeThatFits(_ size: CGSize, intrinsic: Bool = true) -> CGSize {
		isIntrinsicSizeEnabled = intrinsic
		return sizeThatFits(size)
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		preSizeThatFitsConfigurationBlock?(self)
		guard isEmpty == false else { return .zero }
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			return minSize
		}
		
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
		
		result.width = max(minSize.width, result.width)
		result.height = max(minSize.height, result.height)
		
		if maxSize.width > 0 && maxSize.width >= minSize.width {
			result.width = min(maxSize.width, result.width)
		}
		if maxSize.height > 0 && maxSize.height >= minSize.height {
			result.height = min(maxSize.height, result.height)
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
		preLayoutConfigurationBlock?(self)
		super.layoutSubviews()
		
		guard let targetView = targetView, !targetView.isHidden, !isHidden, bounds.size.width > 0, bounds.size.height > 0 else { return }
		
		var targetFrame: CGRect = .zero
		#if swift(>=4.2)
		let containerFrame = bounds.inset(by: edgeInsets)
		#else
		let containerFrame = UIEdgeInsetsInsetRect(bounds, edgeInsets)
		#endif
		var contentSize = horizontalAlignment != .fill || verticalAlignment != .fill ? contentSizeThatFits(size: containerFrame.size) : .zero
		if heightRatio > 0 {
			contentSize.height = contentSize.width * heightRatio
		}
		
		switch horizontalAlignment {
		case .left:
			if allowContentHorizontalGrowing {
				targetFrame.size.width = max(containerFrame.size.width, contentSize.width)
			}
			else if allowContentHorizontalShrinking {
				targetFrame.size.width = min(containerFrame.size.width, contentSize.width)
			}
			else {
				targetFrame.size.width = contentSize.width
			}
			
			targetFrame.origin.x = containerFrame.origin.x
			break
			
		case .right:
			if allowContentHorizontalGrowing {
				targetFrame.size.width = max(containerFrame.size.width, contentSize.width)
			}
			else if allowContentHorizontalShrinking {
				targetFrame.size.width = min(containerFrame.size.width, contentSize.width)
			}
			else {
				targetFrame.size.width = contentSize.width
			}
			
			targetFrame.origin.x = containerFrame.maxX - contentSize.width
			break
			
		case .center:
			if allowContentHorizontalGrowing {
				targetFrame.size.width = max(containerFrame.size.width, contentSize.width)
			}
			else if allowContentHorizontalShrinking {
				targetFrame.size.width = min(containerFrame.size.width, contentSize.width)
			}
			else {
				targetFrame.size.width = contentSize.width
			}
			
			targetFrame.origin.x = containerFrame.origin.x + (containerFrame.size.width - contentSize.width) / 2
			break
			
		case .fill:
			targetFrame.origin.x = containerFrame.origin.x
			targetFrame.size.width = containerFrame.size.width
			break
			
		case .fit:
			if allowContentHorizontalGrowing {
				targetFrame.size.width = max(containerFrame.size.width, contentSize.width)
			}
			else {
				targetFrame.size.width = min(containerFrame.size.width, contentSize.width)
			}
			
			targetFrame.origin.x = containerFrame.origin.x + (containerFrame.size.width - targetFrame.size.width) / 2
			break
			
		}
		
		switch verticalAlignment {
		case .top:
			if allowContentVerticalGrowing {
				targetFrame.size.height = max(containerFrame.size.height, contentSize.height)
			}
			else if allowContentVerticalShrinking {
				targetFrame.size.height = min(containerFrame.size.height, contentSize.height)
			}
			else {
				targetFrame.size.height = contentSize.height
			}
			
			targetFrame.origin.y = containerFrame.origin.y
			break
		
		case .bottom:
			if allowContentVerticalGrowing {
				targetFrame.size.height = max(containerFrame.size.height, contentSize.height)
			}
			else if allowContentVerticalShrinking {
				targetFrame.size.height = min(containerFrame.size.height, contentSize.height)
			}
			else {
				targetFrame.size.height = contentSize.height
			}
			
			targetFrame.origin.y = containerFrame.maxY - contentSize.height
			break
			
		case .center:
			if allowContentVerticalGrowing {
				targetFrame.size.height = max(containerFrame.size.height, contentSize.height)
			}
			else if allowContentVerticalShrinking {
				targetFrame.size.height = min(containerFrame.size.height, contentSize.height)
			}
			else {
				targetFrame.size.height = contentSize.height
			}
			
			targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - contentSize.height) / 2
			break
			
		case .fill:
			targetFrame.origin.y = containerFrame.origin.y
			targetFrame.size.height = containerFrame.size.height
			break
			
		case .fit:
			if allowContentVerticalGrowing {
				targetFrame.size.height = max(containerFrame.size.height, contentSize.height)
			}
			else {
				targetFrame.size.height = min(containerFrame.size.height, contentSize.height)
			}
			
			targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - targetFrame.size.height) / 2
			break
		}
	
		targetFrame = targetFrame.integral
		
		if targetView.superview == self {
			targetView.frame = targetFrame
		}
		else {
			if superview == nil || window == nil  {
				targetFrame.origin.x = frame.origin.x
				targetFrame.origin.y = frame.origin.y
				
				var superView: UIView? = superview
				while superView != nil && (superView is FrameLayout) {
					targetFrame.origin.x += superView!.frame.origin.x
					targetFrame.origin.y += superView!.frame.origin.y
					superView = superView!.superview
				}
				
				targetView.frame = targetFrame
			}
			else {
				targetView.frame = convert(targetFrame, to: targetView.superview)
			}
		}
	}
	
	open override func didMoveToWindow() {
		setNeedsLayout()
	}
	
	open override func didMoveToSuperview() {
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
		
		if contentSize.width > 0 && contentSize.height > 0 {
			return contentSize
		}
		
		var result: CGSize
		
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
		
		return result
	}
	
}
