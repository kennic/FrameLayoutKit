//
//  GridFrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 5/8/20.
//

import UIKit

open class GridFrameLayout: FrameLayout {
	public var axis: NKLayoutAxis = .horizontal
	
	public override var isIntrinsicSizeEnabled: Bool {
		get {
			return stackLayout.isIntrinsicSizeEnabled
		}
		set {
			stackLayout.isIntrinsicSizeEnabled = newValue
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
	
	public var columns: Int = 0 {
		didSet {
			stackLayout.frameLayouts.forEach { (layout) in
				if let layout = layout as? StackFrameLayout {
					layout.numberOfFrameLayouts = columns
				}
			}
		}
	}
	
	public var views: [UIView] = [] {
		didSet {
			views.forEach { (view) in
				addSubview(view)
			}
			arrangeViews()
		}
	}
	
	let stackLayout = StackFrameLayout(axis: .vertical, distribution: .equal)
	
	convenience public init(axis: NKLayoutAxis, rows: Int = 0, column: Int = 0) {
		self.init()
		
		self.axis = axis
		defer {
			self.rows = rows
			self.columns = column
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
		if let rowLayout = stackLayout.frameLayouts[row] as? StackFrameLayout {
			return rowLayout.frameLayout(at: column)
		}
		return nil
	}
	
	@discardableResult
	open func addRow() -> StackFrameLayout {
		let layout = StackFrameLayout(axis: .horizontal, distribution: .equal)
		layout.numberOfFrameLayouts = columns
		stackLayout.add(layout)
		return layout
	}
	
	open func removeRow(at index: Int) {
		stackLayout.removeFrameLayout(at: index)
	}
	
	open func removeAll() {
		stackLayout.removeAll()
	}
	
	open func arrangeViews() {
		let counts = views.count
		guard counts > 0 else { return }
		var i: Int = 0
		
		if axis == .horizontal || axis == .auto {
			for r in 0..<rows {
				for c in 0..<columns {
					frameLayout(row: r, column: c)?.targetView = views[i]
					i += 1
					if i == counts { break }
				}
				if i == counts { break }
			}
		}
		else {
			for c in 0..<columns {
				for r in 0..<rows {
					frameLayout(row: r, column: c)?.targetView = views[i]
					i += 1
					if i == counts { break }
				}
				if i == counts { break }
			}
		}
		
		setNeedsLayout()
	}
	
	// MARK: -
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		stackLayout.frame = bounds
	}
	
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return stackLayout.sizeThatFits(size)
	}
	
}
