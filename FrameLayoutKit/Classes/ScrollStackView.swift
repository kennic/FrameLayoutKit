//
//  ScrollStackView.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 6/23/20.
//

import UIKit

open class ScrollStackView: UIView {
	
	public var views: [UIView] = [] {
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
	
	public var minContentSize: CGSize {
		get { frameLayout.minContentSize }
		set {
			frameLayout.minContentSize = newValue
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
	
	public var minSize: CGSize {
		get { frameLayout.minSize }
		set {
			frameLayout.minSize = newValue
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
	
	public var fixSize: CGSize {
		get { frameLayout.fixSize }
		set {
			frameLayout.fixSize = newValue
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
	
	public var contentFitSize: CGSize = CGSize(width: CGFloat.infinity, height: CGFloat.infinity) {
		didSet {
			setNeedsLayout()
		}
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
	
	public var heightRatio: CGFloat {
		get { frameLayout.heightRatio }
		set {
			frameLayout.heightRatio = newValue
			setNeedsLayout()
		}
	}
	
	/// Block will be called before calling sizeThatFits
	public var preSizeThatFitsConfigurationBlock: ((ScrollStackView, CGSize) -> Void)?
	/// Block will be called before calling layoutSubviews
	public var preLayoutConfigurationBlock: ((ScrollStackView) -> Void)?
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
			if let views = views, !views.isEmpty {
				self.views = views
			}
		}
	}
	
	@discardableResult
	public convenience init(_ block: (ScrollStackView) throws -> Void) rethrows {
		self.init()
		try block(self)
	}
	
	public init() {
		super.init(frame: .zero)
		
		scrollView.bounces = true
		scrollView.alwaysBounceHorizontal = false
		scrollView.alwaysBounceVertical = false
		scrollView.isDirectionalLockEnabled = true
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.clipsToBounds = false
		scrollView.delaysContentTouches = false
		
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
		preSizeThatFitsConfigurationBlock?(self, size)
		return frameLayout.sizeThatFits(size)
	}
	
	override open func layoutSubviews() {
		preLayoutConfigurationBlock?(self)
		super.layoutSubviews()
		
		let viewSize = bounds.size
		let sizeToFit = axis == .horizontal ? CGSize(width: contentFitSize.width, height: viewSize.height) : CGSize(width: viewSize.width, height: contentFitSize.height)
		let contentSize = frameLayout.sizeThatFits(sizeToFit, intrinsic: true)
		scrollView.contentSize = contentSize
		scrollView.frame = bounds
		
		var contentFrame = bounds
		if axis == .horizontal {
			contentFrame.size.width = max(viewSize.width, contentSize.width)
			scrollView.contentSize.height = min(viewSize.height, contentSize.height)
		}
		else {
			contentFrame.size.height = max(viewSize.height, contentSize.height)
			scrollView.contentSize.width = min(viewSize.width, contentSize.width)
		}
		frameLayout.frame = contentFrame
		didLayoutSubviewsBlock?(self)
	}
	
	// MARK: -
	
	public func view(at index: Int) -> UIView? {
		return frameLayout.frameLayout(at: index)?.targetView
	}
	
	public func frameLayout(at index: Int) -> FrameLayout? {
		return frameLayout.frameLayout(at: index)
	}
	
	public func frameLayout(with view: UIView) -> FrameLayout? {
		return frameLayout.frameLayout(with: view)
	}
	
	public func enumerate(_ block: ((FrameLayout, Int, inout Bool) -> Void)) {
		frameLayout.enumerate(block)
	}
	
	public func flexible(ratio: CGFloat = -1) {
		frameLayout.flexible(ratio: ratio)
	}
	
	@discardableResult
	open func add(_ view: UIView?) -> FrameLayout {
		if let view = view { scrollView.addSubview(view) }
		let layout = frameLayout.add(view)
		setNeedsLayout()
		return layout
	}
	
	@discardableResult
	open func add(_ views: [UIView]) -> [FrameLayout] {
		return views.map { add($0) }
	}
	
	@discardableResult
	open func insert(_ view: UIView?, at index: Int) -> FrameLayout {
		if let view = view { scrollView.addSubview(view) }
		let layout = frameLayout.insert(view, at: index)
		setNeedsLayout()
		return layout
	}
	
	@discardableResult
	open func addSpace(_ size: CGFloat = 0) -> FrameLayout {
		let layout = add(UIView())
		layout.minSize = CGSize(width: axis == .horizontal ? size : 0, height: axis == .vertical ? size : 0)
		return layout
	}
	
	open func replace(view: UIView, at index: Int) {
		self.view(at: index)?.removeFromSuperview()
		scrollView.addSubview(view)
		frameLayout.frameLayout(at: index)?.targetView = view
		setNeedsLayout()
	}
	
	open func removeView(at index: Int) {
		frameLayout.removeFrameLayout(at: index, autoRemoveTargetView: true)
		setNeedsLayout()
	}
	
	open func removeAll() {
		views = []
	}
	
	open func relayoutSubviews(animateDuration: TimeInterval = 0.35) {
		setNeedsLayout()
		UIView.animate(withDuration: animateDuration) {
			self.layoutIfNeeded()
		}
	}
	
	open func padding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
		edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
	
	open func addPadding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
		edgeInsets = UIEdgeInsets(top: edgeInsets.top + top, left: edgeInsets.left + left, bottom: edgeInsets.bottom + bottom, right: edgeInsets.right + right)
	}
	
	override open func setNeedsLayout() {
		super.setNeedsLayout()
		frameLayout.setNeedsLayout()
	}
	
	open override func layoutIfNeeded() {
		super.layoutIfNeeded()
		frameLayout.layoutIfNeeded()
	}
	
	// MARK: -
	
	fileprivate func updateLayout() {
		if views.isEmpty {
			frameLayout.removeAll(autoRemoveTargetView: true)
		}
		else {
			let total = views.count
			
			if frameLayout.frameLayouts.count > total {
				frameLayout.enumerate({ (layout, index, stop) in
					if Int(index) >= Int(total) {
						layout.targetView?.removeFromSuperview()
					}
				})
			}
			
			frameLayout.numberOfFrameLayouts = total
			
			frameLayout.enumerate({ (layout, idx, stop) in
				let view = views[idx]
				scrollView.addSubview(view)
				layout.targetView = view
			})
		}
		
		setNeedsLayout()
	}
	
}
