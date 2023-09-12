//
//  FlowFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 11/18/20.
//

import UIKit

open class FlowFrameLayout: FrameLayout {
	public var axis: NKLayoutAxis = .horizontal {
		didSet {
			stackLayout.axis = axis == .horizontal ? .vertical : .horizontal
			setNeedsLayout()
		}
	}
	
	public var distribution: NKLayoutDistribution = .left {
		didSet { setNeedsLayout() }
	}
	
	public override var isIntrinsicSizeEnabled: Bool {
		get { stackLayout.isIntrinsicSizeEnabled }
		set {
			stackLayout.isIntrinsicSizeEnabled = newValue
			setNeedsLayout()
		}
	}
	
	override public var edgeInsets: UIEdgeInsets {
		get { stackLayout.edgeInsets }
		set {
			stackLayout.edgeInsets = newValue
			setNeedsLayout()
		}
	}
	
	override public var minSize: CGSize {
		didSet {
			stackLayout.minSize = minSize
			setNeedsLayout()
		}
	}
	
	override public var maxSize: CGSize {
		didSet {
			stackLayout.maxSize = minSize
			setNeedsLayout()
		}
	}
	
	override public var fixedSize: CGSize {
		didSet {
			stackLayout.fixedSize = fixedSize
			setNeedsLayout()
		}
	}
	
	override public var heightRatio: CGFloat {
		didSet {
			stackLayout.heightRatio = heightRatio
			setNeedsLayout()
		}
	}
	
	override public var debug: Bool {
		didSet { stackLayout.debug = debug }
	}
	
	override public var debugColor: UIColor? {
		didSet { stackLayout.debugColor = debugColor }
	}
	
	public var isJustified: Bool = false {
		didSet { setNeedsLayout() }
	}
	
	public var lineSpacing: CGFloat {
		get { stackLayout.spacing }
		set {
			stackLayout.spacing = newValue
			setNeedsLayout()
		}
	}
	
	public var interItemSpacing: CGFloat = 0 {
		didSet {
			stackLayout.frameLayouts.filter { $0 is StackFrameLayout }.forEach { ($0 as? StackFrameLayout)?.spacing = interItemSpacing }
			setNeedsLayout()
		}
	}
	
	/*
	public override var isUserInteractionEnabled: Bool {
		didSet {
			stackLayout.frameLayouts.forEach { $0.isUserInteractionEnabled = isUserInteractionEnabled }
		}
	}
	*/
	
	public var stackCount: Int { stackLayout.frameLayouts.count }
	public var stacks: [StackFrameLayout] { stackLayout.frameLayouts as? [StackFrameLayout] ?? [] }
	public var firstStack: StackFrameLayout? { stackLayout.firstFrameLayout as? StackFrameLayout }
	public var lastStack: StackFrameLayout? { stackLayout.lastFrameLayout as? StackFrameLayout }
	
	let stackLayout = ScrollStackView(axis: .vertical, distribution: .top)
	
	fileprivate var lastSize: CGSize = .zero
	public fileprivate(set) var viewCount: Int = 0
	
	/// Array of views that needs to be filled in this flow layout
	public var views: [UIView] = [] {
		didSet {
			lastSize = .zero
			viewCount = views.count
			setNeedsLayout()
		}
	}
	
	/// This block will be called when a new StackFrameLayout was added to a new row
	public var onNewStackBlock: ((FlowFrameLayout, StackFrameLayout) -> Void)? = nil
	
	/// This block will be called when a new StackFrameLayout was added to a new row
	public func onNewStackBlock(_ block: @escaping (_ flowLayout: FlowFrameLayout, _ addedStack: StackFrameLayout) -> Void) -> Self {
		onNewStackBlock = block
		return self
	}
	// MARK: -
	
	public convenience init(axis: NKLayoutAxis) {
		self.init()
		self.axis = axis
	}
	
	public required init() {
		super.init()
		
		axis = .horizontal
		isIntrinsicSizeEnabled = true
		stackLayout.scrollView.clipsToBounds = true
		
		addSubview(stackLayout)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	@discardableResult
	public func add(_ view: UIView) -> UIView {
		views.append(view)
		setNeedsLayout()
		return view
	}
	
	public func removeFirst() {
		views.removeFirst()
		setNeedsLayout()
	}
	
	public func removeLast() {
		views.removeLast()
		setNeedsLayout()
	}
	
	public func remove(at index: Int) {
		views.remove(at: index)
		setNeedsLayout()
	}
	
	public func removeAll() {
		views.removeAll()
		setNeedsLayout()
	}
	
	public func viewAt(row: Int, column: Int) -> UIView? {
		return frameLayout(row: row, column: column)?.targetView
	}
	
	public func viewsAt(stack: Int) -> [UIView]? {
		return stacks(at: stack)?.frameLayouts.compactMap( { return $0.targetView } )
	}
	
	public func stacks(at index: Int) -> StackFrameLayout? {
		guard index > -1, index < stackLayout.frameLayouts.count, let frameLayout = stackLayout.frameLayouts[index] as? StackFrameLayout else { return nil }
		return frameLayout
	}
	
	public func frameLayout(row: Int, column: Int) -> FrameLayout? {
		guard row > -1, row < stackLayout.frameLayouts.count else { return nil }
		guard let rowLayout = stackLayout.frameLayouts[row] as? StackFrameLayout else { return nil }
		return rowLayout.frameLayout(at: column)
	}
	
	public func allFrameLayouts() -> [FrameLayout] {
		return stackLayout.frameLayouts.compactMap { $0 as? StackFrameLayout }.flatMap { $0.frameLayouts }
	}
	
	public func lastFrameLayout(containsView: Bool = false) -> FrameLayout? {
		guard let lastStack = lastStack else { return nil }
		
		if containsView {
			return lastStack.frameLayouts.last(where: { $0.targetView != nil })
		}
		else {
			return lastStack.frameLayouts.last
		}
	}
	
	// MARK: -
	
	fileprivate func newStack() -> StackFrameLayout {
		let layout = StackFrameLayout(axis: axis, distribution: distribution)
		layout.spacing = axis == .horizontal ? interItemSpacing : lineSpacing
		layout.isJustified = isJustified
		layout.debug = debug
		
		return layout
	}
	
	/**
	Returns size that fits and map of number of items per row
	- parameter fitSize: Size that needs to be fit in
	- returns Size that fits all contents, and map of number of items per row, format: `[row: numberOfItems]`
	*/
	public func calculateSize(fitSize: CGSize) -> (size: CGSize, map: [Int: Int]) {
		var result = CGSize.zero
		var sizeMap = [Int: Int]()
		
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		let lastView = views.last
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			result = minSize
		}
		else if heightRatio > 0 && !isIntrinsicSizeEnabled {
			result.height = result.width * heightRatio
		}
		else {
			let fitSize = CGSize(width: max(fitSize.width - verticalEdgeValues, 0), height: max(fitSize.height - horizontalEdgeValues, 0))
			
			if axis == .horizontal {
				var rowHeight: CGFloat = 0.0
				var row = 1
				var col = 1
				var remainingSize = fitSize
				var previousRowHeight: CGFloat?
				
				for view in views {
					if view.isHidden && ignoreHiddenView { continue }
					
					if remainingSize.width > 0 {
						let contentSize = view.sizeThatFits(remainingSize)
						let space = contentSize.width > 0 ? contentSize.width + (view != lastView ? interItemSpacing : 0) : 0
						remainingSize.width -= space
						rowHeight = max(rowHeight, contentSize.height)
						
						if col > 1 && previousRowHeight != nil && contentSize.height > previousRowHeight! {
							remainingSize.width = -1 // to trigger the following block
						}
						
						if row == 1 {
							previousRowHeight = rowHeight
						}
					}
					else if remainingSize.width == 0 {
						rowHeight = 0
						remainingSize.width -= 1 // to trigger the following block
					}
					
					result.width = max(result.width, fitSize.width - remainingSize.width)
					
					if remainingSize.width < 0, col > 1 {
						remainingSize.width = fitSize.width
						remainingSize.height -= result.height
						
						let contentSize = view.sizeThatFits(remainingSize)
						let space = contentSize.width > 0 ? contentSize.width + (view != lastView ? interItemSpacing : 0) : 0
						remainingSize.width -= space
						
						rowHeight = max(contentSize.height, 0)
						if rowHeight > 0 {
							result.height += (lineSpacing + rowHeight)
							previousRowHeight = rowHeight
						}
						
						row += 1
						col = 1
					}
					
					sizeMap[row] = col
					result.height = max(result.height, rowHeight)
					
					col += 1
				}
			}
			else { // axis = .vertical
				let fitSize = CGSize(width: fitSize.width, height: maxHeight <= 0 ? 32_000 : maxHeight)
				var colWidth: CGFloat = 0.0
				var row = 1
				var col = 1
				var remainingSize = fitSize
				
				for view in views {
					if view.isHidden && ignoreHiddenView { continue }
					
					if remainingSize.height > 0 {
						let contentSize = view.sizeThatFits(remainingSize)
						let space = contentSize.height > 0 ? contentSize.height + (view != lastView ? lineSpacing : 0) : 0
						remainingSize.height -= space
						colWidth = max(colWidth, contentSize.width)
					}
					else if remainingSize.height == 0 {
						remainingSize.height -= 1 // to trigger the following block
					}
					
					result.height = max(result.height, fitSize.height - remainingSize.height)
					
					if remainingSize.height < 0, row > 1 {
						remainingSize.width -= result.width
						remainingSize.height = fitSize.height
						
						let contentSize = view.sizeThatFits(remainingSize)
						let space = contentSize.height > 0 ? contentSize.height + (view != lastView ? lineSpacing : 0) : 0
						remainingSize.height -= space
						
						colWidth = max(contentSize.width, 0)
						if colWidth > 0 { result.width += (interItemSpacing + colWidth) }
						
						col += 1
						row = 1
					}
					
					sizeMap[col] = row
					result.width = max(result.width, colWidth)
					
					row += 1
				}
			}
		}
		
		if result.width > 0 { result.width += verticalEdgeValues }
		if result.height > 0 { result.height += horizontalEdgeValues }
		
		if axis == .horizontal {
			result.width = min(result.width, fitSize.width)
		}
		else {
			result.height = min(result.height, fitSize.height)
		}
		
		return (result, sizeMap)
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		willSizeThatFitsBlock?(self, size)
		return calculateSize(fitSize: size).size.limitTo(minSize: minSize, maxSize: maxSize)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		defer {
			didLayoutSubviewsBlock?(self)
		}
		
		let boundSize = bounds.size
		let contentSize = calculateSize(fitSize: boundSize)
		
		if lastSize != bounds.size {
			lastSize = bounds.size
			
			let map = contentSize.map
			stackLayout.removeAll()
			
			var index = 0
			let numberOfStack = map.keys.count
			for i in 0..<numberOfStack {
				if index == viewCount { break }
				
				let stack = newStack()
				let numberOfItems = map[i+1] ?? 0
				for _ in 0..<numberOfItems {
					if index == viewCount { break }
					let view = views[index]
					stack + view
					index += 1
				}
				
				stackLayout + stack
				onNewStackBlock?(self, stack)
			}
		}
		
		stackLayout.frame = bounds
	}
	
}
