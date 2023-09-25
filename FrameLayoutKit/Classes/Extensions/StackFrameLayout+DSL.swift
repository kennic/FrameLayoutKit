//
//  StackFrameLayout+DSL.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 9/25/23.
//

import UIKit

@resultBuilder
public struct ViewBuilder {
	
	static public func buildBlock(_ views: UIView...) -> [UIView] { views }
	
}

/**
 Enable DSL syntax:
 
 ```
 let stack = HStackView {
 UILabel()
 UIButton()
 }
 */
open class HStackView: HStackLayout {
	
	public init(@ViewBuilder builder: () -> [UIView]) {
		super.init()
		add(builder())
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	required public init() {
		fatalError("init() has not been implemented")
	}
	
}

/**
 Enable DSL syntax:
 
 ```
 let stack = VStackView {
 UILabel()
 UIButton()
 }
 */
open class VStackView: VStackLayout {
	
	public init(@ViewBuilder builder: () -> [UIView]) {
		super.init()
		add(builder())
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	required public init() {
		fatalError("init() has not been implemented")
	}
	
}

// MARK: -

open class StackItem<T: UIView>: FrameLayout {
	
	public required init(_ view: T?) {
		super.init()
		targetView = view
	}
	
	public required init() {
		super.init()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Spacing

open class SpaceItem: FrameLayout {
	
	public required init(_ value: CGFloat = 0) {
		super.init()
		minSize = CGSize(width: value, height: value)
	}
	
	public required init() {
		super.init()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

open class FlexibleSpace: FrameLayout {
	
	public required init(_ value: CGFloat = 0) {
		super.init()
		minSize = CGSize(width: value, height: value)
		flexible()
	}
	
	public required init() {
		super.init()
		flexible()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
