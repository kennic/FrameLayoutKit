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
		didSet {
			setNeedsLayout()
		}
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
	
	override public var fixSize: CGSize {
		didSet {
			stackLayout.fixSize = fixSize
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
		didSet {
			stackLayout.debug = debug
			stackLayout.frameLayouts.forEach { $0.debug = debug }
			setNeedsLayout()
		}
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
	
	public var rows: Int {
		get { stackLayout.frameLayouts.count }
	}
	
	public fileprivate(set) var viewCount: Int = 0
	public var views: [UIView] = [] {
		didSet {
			views.forEach { if $0.superview == nil { addSubview($0) } }
			
			lastSize = .zero
			viewCount = views.count
			setNeedsLayout()
		}
	}
	
	public var firstRowLayout: StackFrameLayout? {
		return stackLayout.firstFrameLayout as? StackFrameLayout
	}
	
	public var lastRowLayout: StackFrameLayout? {
		return stackLayout.lastFrameLayout as? StackFrameLayout
	}
	
	let stackLayout = StackFrameLayout(axis: .vertical, distribution: .top)
	
	// MARK: -
	
	public convenience init(axis: NKLayoutAxis) {
		self.init()
		self.axis = axis
	}
	
	override public init() {
		super.init()
		
		axis = .horizontal
		isIntrinsicSizeEnabled = true
		addSubview(stackLayout)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	public func viewAt(row: Int, column: Int) -> UIView? {
		return frameLayout(row: row, column: column)?.targetView
	}
	
	public func viewsAt(row: Int) -> [UIView]? {
		return rows(at: row)?.frameLayouts.compactMap( { return $0 } )
	}
	
	public func viewsAt(column: Int) -> [UIView]? {
		var results = [UIView]()
		for r in 0..<rows {
			if let view = viewAt(row: r, column: column) {
				results.append(view)
			}
		}
		
		return results.isEmpty ? nil : results
	}
	
	public func rows(at index: Int) -> StackFrameLayout? {
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
		guard let lastRows = lastRowLayout else { return nil }
		
		if containsView {
			return lastRows.frameLayouts.last(where: { $0.targetView != nil })
		}
		else {
			return lastRows.frameLayouts.last
		}
	}
	
	// MARK: -
	
	fileprivate func newStack() -> StackFrameLayout {
		let layout = StackFrameLayout(axis: axis, distribution: distribution)
		layout.spacing = axis == .horizontal ? interItemSpacing : lineSpacing
		layout.debug = debug
		
		return layout
	}
	
	fileprivate func calculateSize(fitSize: CGSize) -> (size: CGSize, map: [Int: Int]) {
		var result: CGSize = .zero
		var rowColMap: [Int: Int] = [:]
		
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		let lastView = views.last
		
		if axis == .horizontal {
			var rowHeight: CGFloat = 0.0
			var row = 1
			var col = 0
			var remainingSize = fitSize
			var index = 0
			
			while index < viewCount {
				let view = views[index]
				if view.isHidden && ignoreHiddenView { continue }
				col += 1
				
				let contentSize = view.sizeThatFits(remainingSize)
				let space = contentSize.width > 0 ? contentSize.width + (view != lastView ? interItemSpacing : 0) : 0
				remainingSize.width -= space
				rowHeight = max(rowHeight, contentSize.height)
				
				index += 1
				
				if remainingSize.width < 0 {
					index -= 1
					result.height += rowHeight
					
					if viewCount > 1 {
						result.width = max(result.width, fitSize.width - remainingSize.width)
						result.height += lineSpacing
						
						rowHeight = 0
						
						row += 1
						col = 0
					}
					
					remainingSize.width = fitSize.width
					remainingSize.height -= result.height
				}
				
				rowColMap[row] = col
				result.height = max(result.height, rowHeight)
			}
		}
		else {
			var colWidth: CGFloat = 0.0
			var row = 0
			var col = 1
			var remainingSize = fitSize
			var index = 0
			
			while index < viewCount {
				let view = views[index]
				if view.isHidden && ignoreHiddenView { continue }
				row += 1
				
				let contentSize = view.sizeThatFits(remainingSize)
				let space = contentSize.height > 0 ? contentSize.height + (view != lastView ? lineSpacing : 0) : 0
				remainingSize.height -= space
				colWidth = max(colWidth, contentSize.width)
				rowColMap[col] = row
				
				index += 1
				
				if remainingSize.height < 0 {
					index -= 1
					result.width += colWidth
					remainingSize.width -= (colWidth + interItemSpacing)
					
					if viewCount > 1 {
						result.height = max(result.height, fitSize.height - remainingSize.height)
						result.width += interItemSpacing
						
						colWidth = 0
						col += 1
						row = 0
					}
				}
				
				result.width = max(result.width, colWidth)
			}
		}
		
		if result.width > 0 {
			result.width += verticalEdgeValues
		}
		
		if result.height > 0 {
			result.height += horizontalEdgeValues
		}
		
		result.width = min(result.width, fitSize.width)
		result.height = min(result.height, fitSize.height)
		
		return (result, rowColMap)
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		preSizeThatFitsConfigurationBlock?(self, size)
		return calculateSize(fitSize: size).size
	}
	
	var lastSize: CGSize = .zero
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		defer {
			didLayoutSubviewsBlock?(self)
		}
		
		if lastSize != bounds.size {
			lastSize = bounds.size
			
			let boundSize = bounds.size
			let map = calculateSize(fitSize: boundSize).map
			
			stackLayout.removeAll()
			
			var index = 0
			let numberOfStack = map.keys.count
			print("MAP: \(map)")
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
			}
		}
		
		stackLayout.frame = bounds
	}
	
}
