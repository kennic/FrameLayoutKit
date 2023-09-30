//
//  StackFrameLayout+DSL.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 9/25/23.
//

import UIKit

@resultBuilder
public struct FLViewBuilder {
	
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
	
	public init(@FLViewBuilder builder: () -> [UIView]) {
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
	
	public init(@FLViewBuilder builder: () -> [UIView]) {
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
 let stack = ZStackView {
   UILabel()
   UIButton()
 }
 */
open class ZStackView: ZStackLayout {
	
	public init(@FLViewBuilder builder: () -> [UIView]) {
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

/**
 Enable DSL syntax:
 
 ```
 let stack = VStackView {
   StackItem(label).padding(12)
   StackItem(button).aligns(.center, .center).padding(4)
 }
 */
open class StackItem<T: UIView>: FrameLayout {
	public var content: T?
	
	public required init(_ view: T?) {
		super.init()
		
		targetView = view
		content = view
	}
	
	public required init() {
		super.init()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Spacing

/**
 Enable DSL syntax:
 
 ```
 let stack = VStackView {
   StackItem(label).padding(12)
   SpaceItem(10)
   StackItem(button).aligns(.center, .center).padding(4)
 }
 */
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

/**
 Enable DSL syntax:
 
 ```
 let stack = VStackView {
   StackItem(label).padding(12)
   FlexibleSpace()
   StackItem(button).aligns(.center, .center).padding(4)
 }
 */
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
