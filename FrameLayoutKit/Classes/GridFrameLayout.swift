//
//  GridFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 5/8/20.
//

import UIKit

open class GridFrameLayout: FrameLayout {
	public var axis: NKLayoutAxis = .horizontal {
		didSet {
			arrangeViews()
		}
	}
	
	public var autoSizing = false
	
	public override var isIntrinsicSizeEnabled: Bool {
		get {
			return stackLayout.isIntrinsicSizeEnabled
		}
		set {
			stackLayout.isIntrinsicSizeEnabled = newValue
			setNeedsLayout()
		}
	}
	
	override public var edgeInsets: UIEdgeInsets {
		get {
			return stackLayout.edgeInsets
		}
		set {
			stackLayout.edgeInsets = newValue
			setNeedsLayout()
		}
	}
	
	override public var minSize: CGSize {
		didSet {
			stackLayout.minSize = minSize
		}
	}
	
	override public var maxSize: CGSize {
		didSet {
			stackLayout.maxSize = minSize
		}
	}
	
	override public var fixSize: CGSize {
		didSet {
			stackLayout.fixSize = fixSize
		}
	}
	
	public var minRowHeight: CGFloat = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (frameLayout) in
				frameLayout.minSize = CGSize(width: frameLayout.minSize.width, height: minRowHeight)
			}
		}
	}
	
	public var maxRowHeight: CGFloat = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (frameLayout) in
				frameLayout.maxSize = CGSize(width: frameLayout.maxSize.width, height: maxRowHeight)
			}
		}
	}
	
	public var fixRowHeight: CGFloat = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (frameLayout) in
				frameLayout.fixSize = CGSize(width: frameLayout.fixSize.width, height: fixRowHeight)
			}
		}
	}
	
	public var minColumnWidth: CGFloat = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (frameLayout) in
				if let layout = frameLayout as? StackFrameLayout {
					layout.minSize = CGSize(width: minColumnWidth, height: layout.minSize.height)
				}
			}
		}
	}
	
	public var maxColumnWidth: CGFloat = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (frameLayout) in
				if let layout = frameLayout as? StackFrameLayout {
					layout.maxSize = CGSize(width: maxColumnWidth, height: layout.maxSize.height)
				}
			}
		}
	}
	
	public var fixColumnWidth: CGFloat = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (frameLayout) in
				if let layout = frameLayout as? StackFrameLayout {
					layout.fixSize = CGSize(width: fixColumnWidth, height: layout.fixSize.height)
				}
			}
		}
	}
	
	override public var heightRatio: CGFloat {
		didSet {
			stackLayout.heightRatio = heightRatio
		}
	}
	
	public var horizontalSpacing: CGFloat {
		get {
			stackLayout.spacing
		}
		set {
			stackLayout.spacing = newValue
			setNeedsLayout()
		}
	}
	
	public var verticalSpacing: CGFloat = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (frameLayout) in
				if let layout = frameLayout as? StackFrameLayout {
					layout.spacing = verticalSpacing
				}
			}
		}
	}
	
	public var rows: Int {
		get {
			return stackLayout.frameLayouts.count
		}
		set {
			let count = stackLayout.frameLayouts.count
			
			if newValue == 0 {
				removeAll()
				return
			}
			
			if newValue < count {
				while stackLayout.frameLayouts.count > newValue {
					removeRow(at: stackLayout.frameLayouts.count - 1)
				}
			}
			else if newValue > count {
				while stackLayout.frameLayouts.count < newValue {
					addRow()
				}
			}
		}
	}
	
	private var initColumns: Int = 0
	public var columns: Int = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (layout) in
				if let layout = layout as? StackFrameLayout {
					layout.numberOfFrameLayouts = columns
				}
			}
		}
	}
	
	public fileprivate(set) var viewCount: Int = 0
	public var views: [UIView] = [] {
		didSet {
			views.forEach { (view) in
				if view.superview == nil {
					addSubview(view)
				}
			}
			viewCount = views.count
			arrangeViews()
		}
	}
	
	public var firstRowLayout: StackFrameLayout? {
		return stackLayout.firstFrameLayout as? StackFrameLayout
	}
	
	public var lastRowLayout: StackFrameLayout? {
		return stackLayout.lastFrameLayout as? StackFrameLayout
	}
	
	let stackLayout = StackFrameLayout(axis: .vertical, distribution: .equal)
	
	convenience public init(axis: NKLayoutAxis, column: Int = 0, rows: Int = 0) {
		self.init()
		
		self.axis = axis
		defer {
			self.rows = rows
			self.columns = column
			self.initColumns = column
		}
	}
	
	override public init() {
		super.init()
		
		isIntrinsicSizeEnabled = true
		addSubview(stackLayout)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	open func frameLayout(row: Int, column: Int) -> FrameLayout? {
		guard row > -1, row < stackLayout.frameLayouts.count else { return nil }
		guard let rowLayout = stackLayout.frameLayouts[row] as? StackFrameLayout else { return nil }
		return rowLayout.frameLayout(at: column)
	}
	
	open func viewAt(row: Int, column: Int) -> UIView? {
		return frameLayout(row: row, column: column)?.targetView
	}
	
	open func viewsAt(row: Int) -> [UIView]? {
		return rows(at: row)?.frameLayouts.compactMap( { return $0 } )
	}
	
	open func viewsAt(column: Int) -> [UIView]? {
		var results = [UIView]()
		for r in 0..<rows {
			if let view = viewAt(row: r, column: column) {
				results.append(view)
			}
		}
		
		return results.isEmpty ? nil : results
	}
	
	open func rows(at index: Int) -> StackFrameLayout? {
		guard index > -1, index < stackLayout.frameLayouts.count, let frameLayout = stackLayout.frameLayouts[index] as? StackFrameLayout else { return nil }
		return frameLayout
	}
	
	public func allFrameLayouts() -> [FrameLayout] {
		var results = [FrameLayout]()
		for r in 0..<stackLayout.frameLayouts.count {
			guard let rowLayout = stackLayout.frameLayouts[r] as? StackFrameLayout else { continue }
			for c in 0..<rowLayout.frameLayouts.count {
				if let layout = frameLayout(row: r, column: c) {
					results.append(layout)
				}
			}
		}
		return results
	}
	
	@discardableResult
	open func addRow() -> StackFrameLayout {
		let layout = StackFrameLayout(axis: .horizontal, distribution: .equal)
		layout.numberOfFrameLayouts = columns
		layout.spacing = verticalSpacing
		stackLayout.add(layout)
		return layout
	}
	
	open func removeRow(at index: Int) {
		stackLayout.removeFrameLayout(at: index)
	}
	
	open func removeLastRow() {
		guard stackLayout.frameLayouts.count > 0 else { return }
		stackLayout.removeFrameLayout(at: stackLayout.frameLayouts.count - 1)
	}
	
	open func removeAll() {
		stackLayout.removeAll()
	}
	
	public func lastFrameLayout(containsView: Bool = false) -> FrameLayout? {
		guard let lastRows = lastRowLayout else { return nil }
		if containsView {
			let layouts = lastRows.frameLayouts.reversed()
			for layout in layouts {
				if layout.targetView != nil {
					return layout
				}
			}
			
			return nil
		}
		else {
			return lastRows.frameLayouts.last
		}
	}
	
	// MARK: -
	
	func arrangeViews(autoColumns: Bool = true) {
		guard viewCount > 0 else { return }
		
		var numberOfRows = stackLayout.frameLayouts.count
		if autoSizing {
			if axis == .horizontal, columns > 0 {
				let fitRows = max(Int(ceil(Double(viewCount) / Double(columns))), 1)
				if fitRows != rows {
					rows = fitRows
					numberOfRows = fitRows
				}
			}
			else if axis == .vertical, rows > 0 {
				let fitColumn = max(Int(ceil(Double(viewCount) / Double(rows))), 1)
				if fitColumn != columns {
					columns = fitColumn
				}
			}
		}
		
		var i: Int = 0
		
		if axis == .horizontal || axis == .auto {
			if autoColumns, maxColumnWidth > 0 {
				var viewSize = stackLayout.bounds.size
				if viewSize == .zero { viewSize = bounds.size }
				let fitColumns = max(Int(viewSize.width / maxColumnWidth), max(initColumns, 1))
				if columns != fitColumns {
					columns = fitColumns
					arrangeViews(autoColumns: false)
					return
				}
			}
			
			for r in 0..<numberOfRows {
				guard let rowLayout = stackLayout.frameLayouts[r] as? StackFrameLayout else { continue }
				for c in 0..<rowLayout.frameLayouts.count {
					frameLayout(row: r, column: c)?.targetView = views[i]
					i += 1
					if i == viewCount { break }
				}
				if i == viewCount { break }
			}
		}
		else {
			for c in 0..<columns {
				for r in 0..<numberOfRows {
					frameLayout(row: r, column: c)?.targetView = views[i]
					i += 1
					if i == viewCount { break }
				}
				if i == viewCount { break }
			}
		}
		
		setNeedsLayout()
		layoutIfNeeded()
	}
	
	// MARK: -
	
	private var lastSize: CGSize = .zero
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		if maxColumnWidth > 0, lastSize != bounds.size {
			lastSize = bounds.size
			arrangeViews()
		}
		
		if stackLayout.frame != bounds {
			stackLayout.frame = bounds
		}
	}
	
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return stackLayout.sizeThatFits(size)
	}
	
}
