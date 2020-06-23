//
//  ScrollStackView.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 6/23/20.
//

import UIKit

open class ScrollStackView<T: UIView>: UIView {
	
	public var views: [T] = [] {
		didSet {
			updateLayout()
			setNeedsLayout()
		}
	}
	
	public var firstView: T? {
		return frameLayout.firstFrameLayout?.targetView as? T
	}
	
	public var lastView: T? {
		return frameLayout.lastFrameLayout?.targetView as? T
	}
	
	open var spacing: CGFloat {
		get {
			return frameLayout.spacing
		}
		set {
			frameLayout.spacing = newValue
			setNeedsLayout()
		}
	}
	
	open var edgeInsets: UIEdgeInsets {
		get {
			return frameLayout.edgeInsets
		}
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
		get {
			return frameLayout.axis
		}
		set {
			frameLayout.axis = newValue
			setNeedsLayout()
		}
	}
	
	public var distribution: NKLayoutDistribution {
		get {
			return frameLayout.distribution
		}
		set {
			frameLayout.distribution = newValue
			setNeedsLayout()
		}
	}
	
	public let scrollView = UIScrollView()
	public let frameLayout = StackFrameLayout(axis: .vertical, distribution: .top)
	
	// MARK: -
	
	convenience public init(views: [T], axis: NKLayoutAxis = .vertical) {
		self.init()
		
		self.axis = axis
		defer {
			self.views = views
		}
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
		return frameLayout.sizeThatFits(size)
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		let viewSize = bounds.size
		let sizeToFit = axis == .horizontal ? CGSize(width: CGFloat.infinity, height: viewSize.height) : CGSize(width: viewSize.width, height: CGFloat.infinity)
		scrollView.contentSize = frameLayout.sizeThatFits(sizeToFit)
		scrollView.frame = bounds
		
		var contentFrame = bounds
		if axis == .horizontal {
			contentFrame.size.width = max(viewSize.width, scrollView.contentSize.width)
			scrollView.contentSize.height = min(viewSize.height, scrollView.contentSize.height)
		}
		else {
			contentFrame.size.height = max(viewSize.height, scrollView.contentSize.height)
			scrollView.contentSize.width = min(viewSize.width, scrollView.contentSize.width)
		}
		frameLayout.frame = contentFrame
	}
	
	// MARK: -
	
	public func view(at index: Int) -> T? {
		return frameLayout.frameLayout(at: index)?.targetView as? T
	}
	
	@discardableResult
	open func add(_ view: T?) -> FrameLayout {
		if let view = view { scrollView.addSubview(view) }
		let layout = frameLayout.add(view)
		setNeedsLayout()
		return layout
	}
	
	@discardableResult
	open func add(_ views: [T]) -> [FrameLayout] {
		var results = [FrameLayout]()
		views.forEach { (view) in
			results.append(add(view))
		}
		
		return results
	}
	
	@discardableResult
	open func insert(_ view: T?, at index: Int) -> FrameLayout {
		if let view = view { scrollView.addSubview(view) }
		let layout = frameLayout.insert(view, at: index)
		setNeedsLayout()
		return layout
	}
	
	@discardableResult
	open func addSpace(_ size: CGFloat = 0) -> FrameLayout {
		let layout = add(T())
		layout.fixSize = CGSize(width: axis == .horizontal ? size : 0, height: axis == .vertical ? size : 0)
		return layout
	}
	
	open func replace(view: T, at index: Int) {
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
	
	// MARK: -
	
	fileprivate func updateLayout() {
		if views.isEmpty {
			frameLayout.enumerate({ (layout, index, stop) in
				layout.targetView?.removeFromSuperview()
			})
			
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
