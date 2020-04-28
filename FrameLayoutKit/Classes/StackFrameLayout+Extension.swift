//
//  FrameLayout+Extension.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 4/28/20.
//  Copyright © 2020 Nam Kennic. All rights reserved.
//

import Foundation

infix operator ---
infix operator ++

public extension StackFrameLayout {
	
	@discardableResult
	static func ---(lhs: StackFrameLayout, _ size: CGFloat = 0) -> FrameLayout {
		return lhs.addSpace(size)
	}
	
	@discardableResult
	static func +=(lhs: StackFrameLayout, rhs: UIView? = nil) -> FrameLayout {
		return lhs.add(rhs)
	}
	
	static func ++(lhs: StackFrameLayout, rhs: [UIView]? = nil) {
		rhs?.forEach({ (view) in
			lhs.add(view)
		})
	}
	
}

infix operator <=
infix operator =>

public extension DoubleFrameLayout {
	
	static func <=(lhs: DoubleFrameLayout, rhs: UIView? = nil) {
		if let frameLayout = rhs as? FrameLayout, frameLayout.superview == nil {
			lhs.leftFrameLayout = frameLayout
		}
		else {
			lhs.leftFrameLayout.targetView = rhs
		}
	}
	
	static func =>(lhs: DoubleFrameLayout, rhs: UIView? = nil) {
		if let frameLayout = rhs as? FrameLayout, frameLayout.superview == nil {
			lhs.rightFrameLayout = frameLayout
		}
		else {
			lhs.rightFrameLayout.targetView = rhs
		}
	}
	
}

// MARK: -

open class Stack: StackFrameLayout {
	
	@discardableResult
	public init(_ block: (Stack) throws -> Void) rethrows {
		super.init()
		try block(self)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

open class HStackLayout: StackFrameLayout {
	
	@discardableResult
	public init(_ block: (HStackLayout) throws -> Void) rethrows {
		super.init()
		axis = .horizontal
		try block(self)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

open class VStackLayout: StackFrameLayout {
	
	@discardableResult
	public init(_ block: (VStackLayout) throws -> Void) rethrows {
		super.init()
		axis = .vertical
		try block(self)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
