//
//  FrameLayout+Extension.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 4/28/20.
//  Copyright © 2020 Nam Kennic. All rights reserved.
//

import Foundation
import UIKit

infix operator ---

public extension StackFrameLayout {
	
	@discardableResult
	static func ---(lhs: StackFrameLayout, _ size: CGFloat = 0) -> FrameLayout {
		return lhs.addSpace(size)
	}
	
	@discardableResult
	static func +(lhs: StackFrameLayout, rhs: UIView? = nil) -> FrameLayout {
		return lhs.add(rhs)
	}
	
	@discardableResult
	static func +(lhs: StackFrameLayout, rhs: [UIView]? = nil) -> [FrameLayout] {
		var results = [FrameLayout]()
		rhs?.forEach({ (view) in
			results.append(lhs.add(view))
		})
		return results
	}
	
	@discardableResult
	static func +(lhs: StackFrameLayout, rhs: CGFloat = 0) -> FrameLayout {
		return lhs.addSpace(rhs)
	}
	
	@discardableResult
	static func +(lhs: StackFrameLayout, rhs: Double = 0) -> FrameLayout {
		return lhs.addSpace(CGFloat(rhs))
	}
	
	@discardableResult
	static func +(lhs: StackFrameLayout, rhs: Int = 0) -> FrameLayout {
		return lhs.addSpace(CGFloat(rhs))
	}
	
}

infix operator <+
infix operator +>

public extension DoubleFrameLayout {
	
	static func <+(lhs: DoubleFrameLayout, rhs: UIView? = nil) {
		if let frameLayout = rhs as? FrameLayout, frameLayout.superview == nil {
			lhs.leftFrameLayout = frameLayout
		}
		else {
			lhs.leftFrameLayout.targetView = rhs
		}
	}
	
	static func +>(lhs: DoubleFrameLayout, rhs: UIView? = nil) {
		if let frameLayout = rhs as? FrameLayout, frameLayout.superview == nil {
			lhs.rightFrameLayout = frameLayout
		}
		else {
			lhs.rightFrameLayout.targetView = rhs
		}
	}
	
}

// MARK: -

open class StackLayout: StackFrameLayout {
	
	@discardableResult
	public init(_ block: (StackLayout) throws -> Void) rethrows {
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

public protocol With {}
extension With where Self: FrameLayout {
	
	/// Add ability to set properties with closures just after initializing.
	///
	///     let frameLayout = FrameLayout().with {
	///       $0.alignment = (.top, .center)
	///       $0.padding(top: 5, left: 5, bottom: 5, right: 5)
	///     }
	///
	/// So you can also nest a block of FrameLayout into another by:
	///
	///		let stack = StackFrameLayout(axis: .vertical)
	///		stack.add(StackFrameLayout(.horizontal).with {
	///			$0.add(label)
	///			$0.add(imageView)
	///		})
	///		stack.add(textField)
	///
	///
	@discardableResult
	public func with(_ block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
		return self
	}
	
}

extension FrameLayout: With {}
