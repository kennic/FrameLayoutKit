//
//  ScrollStackView.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 6/23/20.
//

import UIKit

open class ScrollStackView: UIView {
	
	open var views: [UIView] {
		get { frameLayouts.compactMap { $0.targetView } }
		set { _views = newValue }
	}
	
	fileprivate var _views: [UIView] = [] {
		didSet {
			updateLayout()
			setNeedsLayout()
		}
	}
	
	open var spacing: CGFloat {
		get { frameLayout.spacing }
		set {
			frameLayout.spacing = newValue
			setNeedsLayout()
		}
	}
	
	open var edgeInsets: UIEdgeInsets {
		get { frameLayout.edgeInsets }
		set {
			frameLayout.edgeInsets = newValue
			setNeedsLayout()
		}
	}
	
	open var isDirectionalLockEnabled: Bool {
		get { scrollView.isDirectionalLockEnabled }
		set {
			scrollView.isDirectionalLockEnabled = newValue
			setNeedsLayout()
		}
	}
	
	override open var frame: CGRect {
		didSet { setNeedsLayout() }
	}
	
	override open var bounds: CGRect {
		didSet { setNeedsLayout() }
	}
	
	public var axis: NKLayoutAxis {
		get { frameLayout.axis }
		set {
			frameLayout.axis = newValue
			setNeedsLayout()
		}
	}
	
	public var distribution: NKLayoutDistribution {
		get { frameLayout.distribution }
		set {
			frameLayout.distribution = newValue
			setNeedsLayout()
		}
	}
	
	public var debug: Bool {
		get { frameLayout.debug }
		set { frameLayout.debug = newValue }
	}
	
	public var debugColor: UIColor? {
		get { frameLayout.debugColor }
		set { frameLayout.debugColor = newValue }
	}
	
	public var isOverlapped: Bool {
		get { frameLayout.isOverlapped }
		set { frameLayout.isOverlapped = newValue }
	}
	
	public var fixedContentSize: CGSize {
		get { frameLayout.fixedContentSize }
		set {
			frameLayout.fixedContentSize = newValue
			setNeedsLayout()
		}
	}
	
	public var fixedContentWidth: CGFloat {
		get { frameLayout.fixedContentWidth }
		set {
			frameLayout.fixedContentWidth = newValue
			setNeedsLayout()
		}
	}
	
	public var fixedContentHeight: CGFloat {
		get { frameLayout.fixedContentHeight }
		set {
			frameLayout.fixedContentHeight = newValue
			setNeedsLayout()
		}
	}
	
	public var minContentSize: CGSize {
		get { frameLayout.minContentSize }
		set {
			frameLayout.minContentSize = newValue
			setNeedsLayout()
		}
	}
	
	public var minContentWidth: CGFloat {
		get { frameLayout.minContentWidth }
		set {
			frameLayout.minContentWidth = newValue
			setNeedsLayout()
		}
	}
	
	public var minContentHeight: CGFloat {
		get { frameLayout.minContentHeight }
		set {
			frameLayout.minContentHeight = newValue
			setNeedsLayout()
		}
	}
	
	public var maxContentSize: CGSize {
		get { frameLayout.maxContentSize }
		set {
			frameLayout.maxContentSize = newValue
			setNeedsLayout()
		}
	}
	
	public var maxContentWidth: CGFloat {
		get { frameLayout.maxContentWidth }
		set {
			frameLayout.maxContentWidth = newValue
			setNeedsLayout()
		}
	}
	
	public var maxContentHeight: CGFloat {
		get { frameLayout.maxContentHeight }
		set {
			frameLayout.maxContentHeight = newValue
			setNeedsLayout()
		}
	}
	
	public var minSize: CGSize {
		get { frameLayout.minSize }
		set {
			frameLayout.minSize = newValue
			setNeedsLayout()
		}
	}
	
	public var minWidth: CGFloat {
		get { frameLayout.minWidth }
		set {
			frameLayout.minWidth = newValue
			setNeedsLayout()
		}
	}
	
	public var minHeight: CGFloat {
		get { frameLayout.minHeight }
		set {
			frameLayout.minHeight = newValue
			setNeedsLayout()
		}
	}
	
	public var maxSize: CGSize {
		get { frameLayout.maxSize }
		set {
			frameLayout.maxSize = newValue
			setNeedsLayout()
		}
	}
	
	public var maxWidth: CGFloat {
		get { frameLayout.maxWidth }
		set {
			frameLayout.maxWidth = newValue
			setNeedsLayout()
		}
	}
	
	public var maxHeight: CGFloat {
		get { frameLayout.maxHeight }
		set {
			frameLayout.maxHeight = newValue
			setNeedsLayout()
		}
	}
	
	public var fixedSize: CGSize {
		get { frameLayout.fixedSize }
		set {
			frameLayout.fixedSize = newValue
			setNeedsLayout()
		}
	}
	
	public var fixedWidth: CGFloat {
		get { frameLayout.fixedWidth }
		set {
			frameLayout.fixedWidth = newValue
			setNeedsLayout()
		}
	}
	
	public var fixedHeight: CGFloat {
		get { frameLayout.fixedHeight }
		set {
			frameLayout.fixedHeight = newValue
			setNeedsLayout()
		}
	}
	
	/// Set minContentSize for every FrameLayout inside
	open var minItemSize: CGSize {
		get { frameLayout.minItemSize }
		set {
			frameLayout.minItemSize = newValue
			setNeedsLayout()
		}
	}
	
	/// Set maxContentSize for every FrameLayout inside
	open var maxItemSize: CGSize {
		get { frameLayout.maxItemSize }
		set {
			frameLayout.maxItemSize = newValue
			setNeedsLayout()
		}
	}
	
	/// Set fixedContentSize for every FrameLayout inside
	open var fixedItemSize: CGSize {
		get { frameLayout.fixedItemSize }
		set {
			frameLayout.fixedItemSize = newValue
			setNeedsLayout()
		}
	}
	
	public var extendSize: CGSize {
		get { frameLayout.extendSize }
		set {
			frameLayout.extendSize = newValue
			setNeedsLayout()
		}
	}
	
	public var extendWidth: CGFloat {
		get { frameLayout.extendWidth }
		set {
			frameLayout.extendWidth = newValue
			setNeedsLayout()
		}
	}
	
	public var extendHeight: CGFloat {
		get { frameLayout.extendHeight }
		set {
			frameLayout.extendHeight = newValue
			setNeedsLayout()
		}
	}
	
	public var contentFitSize: CGSize = CGSize(width: CGFloat.infinity, height: CGFloat.infinity) {
		didSet { setNeedsLayout() }
	}
	
	public var ignoreHiddenView: Bool {
		get { frameLayout.ignoreHiddenView }
		set {
			frameLayout.ignoreHiddenView = newValue
			setNeedsLayout()
		}
	}
	
	public var isIntrinsicSizeEnabled: Bool {
		get { frameLayout.isIntrinsicSizeEnabled }
		set {
			frameLayout.isIntrinsicSizeEnabled = newValue
			setNeedsLayout()
		}
	}
	
	public var isFlexible: Bool {
		get { frameLayout.isFlexible }
		set {
			frameLayout.isFlexible = newValue
			setNeedsLayout()
		}
	}
	
	public var isEnabled = true
	
	public var heightRatio: CGFloat {
		get { frameLayout.heightRatio }
		set {
			frameLayout.heightRatio = newValue
			setNeedsLayout()
		}
	}
	
	// Skeleton
	
	/// set color for skeleton mode
	public var skeletonColor: UIColor {
		get { frameLayout.skeletonColor }
		set {
			frameLayout.skeletonColor = newValue
			setNeedsLayout()
		}
	}
	public var skeletonMinSize: CGSize {
		get { frameLayout.skeletonMinSize }
		set {
			frameLayout.skeletonMinSize = newValue
			setNeedsLayout()
		}
	}
	public var skeletonMaxSize: CGSize {
		get { frameLayout.skeletonMaxSize }
		set {
			frameLayout.skeletonMaxSize = newValue
			setNeedsLayout()
		}
	}
	public var isSkeletonMode: Bool {
		get { frameLayout.isSkeletonMode }
		set {
			frameLayout.isSkeletonMode = newValue
			setNeedsLayout()
		}
	}
	
	public var frameLayouts: [FrameLayout] {
		get { frameLayout.frameLayouts }
		set { frameLayout.frameLayouts = newValue }
	}
	
	public var firstFrameLayout: FrameLayout? { frameLayout.firstFrameLayout }
	public var lastFrameLayout: FrameLayout? { frameLayout.lastFrameLayout }
	
	/// Block will be called before calling sizeThatFits
	@available(*, deprecated, renamed: "willSizeThatFitsBlock")
	public var preSizeThatFitsConfigurationBlock: ((ScrollStackView, CGSize) -> Void)? {
		get { willSizeThatFitsBlock }
		set { willSizeThatFitsBlock = newValue }
	}
	
	@available(*, deprecated, renamed: "willLayoutSubviewsBlock")
	public var preLayoutConfigurationBlock: ((ScrollStackView) -> Void)? {
		get { willLayoutSubviewsBlock }
		set { willLayoutSubviewsBlock = newValue }
	}
	
	/// Block will be called before calling sizeThatFits
	public var willSizeThatFitsBlock: ((ScrollStackView, CGSize) -> Void)?
	/// Block will be called before calling layoutSubviews
	public var willLayoutSubviewsBlock: ((ScrollStackView) -> Void)?
	/// Block will be called at the end of layoutSubviews function
	public var didLayoutSubviewsBlock: ((ScrollStackView) -> Void)?
	
	public let scrollView = UIScrollView()
	public let frameLayout = StackFrameLayout(axis: .vertical, distribution: .top)
	
	// MARK: -
	
	convenience public init(axis: NKLayoutAxis = .vertical, distribution: NKLayoutDistribution = .top, views: [UIView]? = nil) {
		self.init()
		
		self.axis = axis
		self.distribution = distribution
		
		defer {
			if let views, !views.isEmpty {
				self.views = views
			}
		}
	}
	
	@discardableResult
	public convenience init(_ block: (ScrollStackView) throws -> Void) rethrows {
		self.init()
		try block(self)
	}
	
	public required init() {
		super.init(frame: .zero)
		
		scrollView.bounces = true
		scrollView.alwaysBounceHorizontal = false
		scrollView.alwaysBounceVertical = false
		scrollView.isDirectionalLockEnabled = true
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.clipsToBounds = false
		scrollView.delaysContentTouches = false
		
		#if os(iOS)
		if #available(iOS 11.0, *) { scrollView.contentInsetAdjustmentBehavior = .never }
		if #available(iOS 13.0, *) { scrollView.automaticallyAdjustsScrollIndicatorInsets = false }
		#endif
		
		frameLayout.spacing = 0.0
		frameLayout.isIntrinsicSizeEnabled = true
		frameLayout.shouldCacheSize = false
		scrollView.addSubview(frameLayout)
		addSubview(scrollView)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		if !isEnabled { return .zero }
		willSizeThatFitsBlock?(self, size)
		return frameLayout.sizeThatFits(size)
	}
	
	override open func layoutSubviews() {
		if !isEnabled { return }
		
		willLayoutSubviewsBlock?(self)
		super.layoutSubviews()
		
		let viewSize = bounds.size
		let sizeToFit = !isDirectionalLockEnabled ? contentFitSize : (axis == .horizontal ? CGSize(width: contentFitSize.width, height: viewSize.height) : CGSize(width: viewSize.width, height: contentFitSize.height))
		let contentSize = frameLayout.sizeThatFits(sizeToFit, intrinsic: true)
		scrollView.contentSize = contentSize
		scrollView.frame = bounds
		
		var contentFrame = bounds
		if axis == .horizontal {
			contentFrame.size.width = max(viewSize.width, contentSize.width)
			if isDirectionalLockEnabled {
				scrollView.contentSize.height = min(viewSize.height, contentSize.height)
			}
			else {
				contentFrame.size.height = max(viewSize.height, contentSize.height)
			}
		}
		else {
			contentFrame.size.height = max(viewSize.height, contentSize.height)
			if isDirectionalLockEnabled {
				scrollView.contentSize.width = min(viewSize.width, contentSize.width)
			}
			else {
				contentFrame.size.width = max(viewSize.width, contentSize.width)
			}
		}
		
		frameLayout.frame = contentFrame
		didLayoutSubviewsBlock?(self)
	}
	
	// MARK: -
	
	public func view(at index: Int) -> UIView? { frameLayout.frameLayout(at: index)?.targetView }
	public func frameLayout(at index: Int) -> FrameLayout? { frameLayout.frameLayout(at: index) }
	public func frameLayout(with view: UIView) -> FrameLayout? { frameLayout.frameLayout(with: view) }
	public func enumerate(_ block: (FrameLayout, Int, inout Bool) -> Void) { frameLayout.enumerate(block) }

	@discardableResult
	public func flexible(ratio: CGFloat = -1) -> Self {
		frameLayout.flexible(ratio: ratio)
		return self
	}
	
	@discardableResult
	public func invert() -> Self {
		frameLayout.invert()
		return self
	}
	
	@discardableResult
	open func add(_ view: UIView?) -> FrameLayout {
		let layout = frameLayout.add(view)
		if let view { scrollView.addSubview(view) }
		setNeedsLayout()
		return layout
	}
	
	@discardableResult
	open func add(_ views: [UIView]) -> [FrameLayout] {
		return views.map { add($0) }
	}
	
	@discardableResult
	open func insert(_ view: UIView?, at index: Int, invert: Bool = false) -> FrameLayout {
		let targetIndex = invert ? max(frameLayouts.count - index, 0) : index
		let layout = frameLayout.insert(view, at: targetIndex)
		if let view { scrollView.insertSubview(view, at: targetIndex) }
		setNeedsLayout()
		return layout
	}
	
	@discardableResult
	open func addSpace(_ size: CGFloat = 0) -> FrameLayout {
		let layout = add(UIView())
		layout.minSize = CGSize(width: axis == .horizontal ? size : 0, height: axis == .vertical ? size : 0)
		return layout
	}
	
	@discardableResult
	open func replace(view: UIView, at index: Int) -> Self {
		self.view(at: index)?.removeFromSuperview()
		scrollView.addSubview(view)
		frameLayout.frameLayout(at: index)?.targetView = view
		setNeedsLayout()
		return self
	}

	@discardableResult
	open func removeView(at index: Int) -> Self {
		frameLayout.removeFrameLayout(at: index, autoRemoveTargetView: true)
		setNeedsLayout()
		return self
	}
	
	@discardableResult
	open func removeAll() -> Self {
		frameLayout.removeAll(autoRemoveTargetView: true)
		setNeedsLayout()
		return self
	}
	
	open func relayoutSubviews(animateDuration: TimeInterval = 0.35, options: UIView.AnimationOptions = .curveEaseInOut, completion: ((Bool) -> Void)? = nil) {
		setNeedsLayout()
		
		UIView.animate(withDuration: animateDuration, delay: 0.0, options: options, animations: {
			self.layoutIfNeeded()
		}, completion: completion)
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
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		frameLayout.setNeedsLayout()
	}
	
	open override func layoutIfNeeded() {
		super.layoutIfNeeded()
		frameLayout.layoutIfNeeded()
	}
	
	/**
	 This will set `isUserInteractionEnabled` as well as all sub-frameLayouts to the same value.
	 - parameter enabled: The name says it all
	 */
	@discardableResult
	public func setUserInteraction(enabled: Bool) -> Self {
		isUserInteractionEnabled = enabled
		frameLayouts.forEach { $0.isUserInteractionEnabled = enabled }
		return self
	}
	
	// MARK: -
	
	fileprivate func updateLayout() {
		if _views.isEmpty {
			frameLayout.removeAll(autoRemoveTargetView: true)
		}
		else {
			let total = _views.count
			
			if frameLayout.frameLayouts.count > total {
				frameLayout.enumerate { layout, index, _ in
					if Int(index) >= Int(total) {
						layout.targetView?.removeFromSuperview()
					}
				}
			}
			
			frameLayout.numberOfFrameLayouts = total
			
			frameLayout.enumerate { layout, idx, _ in
				let view = views[idx]
				scrollView.addSubview(view)
				layout.targetView = view
			}
		}
		
		setNeedsLayout()
	}
	
}
