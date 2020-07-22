//
//  FrameLayout+Extension.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 4/28/20.
//  Copyright © 2020 Nam Kennic. All rights reserved.
//

import Foundation
import UIKit

public extension FrameLayout {
	
	@discardableResult
	static func +(lhs: FrameLayout, rhs: UIView? = nil) -> FrameLayout {
		lhs.targetView = rhs
		return lhs
	}
}

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
		rhs?.forEach { results.append(lhs.add($0)) }
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

public extension ScrollStackView {
	
	@discardableResult
	static func ---(lhs: ScrollStackView, _ size: CGFloat = 0) -> FrameLayout {
		return lhs.addSpace(size)
	}
	
	@discardableResult
	static func +(lhs: ScrollStackView, rhs: UIView? = nil) -> FrameLayout {
		return lhs.add(rhs)
	}
	
	@discardableResult
	static func +(lhs: ScrollStackView, rhs: [UIView]? = nil) -> [FrameLayout] {
		var results = [FrameLayout]()
		rhs?.forEach { results.append(lhs.add($0)) }
		return results
	}
	
	@discardableResult
	static func +(lhs: ScrollStackView, rhs: CGFloat = 0) -> FrameLayout {
		return lhs.addSpace(rhs)
	}
	
	@discardableResult
	static func +(lhs: ScrollStackView, rhs: Double = 0) -> FrameLayout {
		return lhs.addSpace(CGFloat(rhs))
	}
	
	@discardableResult
	static func +(lhs: ScrollStackView, rhs: Int = 0) -> FrameLayout {
		return lhs.addSpace(CGFloat(rhs))
	}
	
}

infix operator <+
infix operator +>

public extension DoubleFrameLayout {
	
	@discardableResult
	static func <+(lhs: DoubleFrameLayout, rhs: UIView? = nil) -> FrameLayout {
		if let frameLayout = rhs as? FrameLayout, frameLayout.superview == nil {
			lhs.leftFrameLayout = frameLayout
		}
		else {
			lhs.leftFrameLayout.targetView = rhs
		}
		
		return lhs.leftFrameLayout
	}
	
	@discardableResult
	static func +>(lhs: DoubleFrameLayout, rhs: UIView? = nil) -> FrameLayout {
		if let frameLayout = rhs as? FrameLayout, frameLayout.superview == nil {
			lhs.rightFrameLayout = frameLayout
		}
		else {
			lhs.rightFrameLayout.targetView = rhs
		}
		
		return lhs.rightFrameLayout
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
	
	override public init() {
		super.init()
		axis = .horizontal
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
	
	override public init() {
		super.init()
		axis = .vertical
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

extension CGSize {
	
	mutating func limitedTo(minSize: CGSize, maxSize: CGSize) {
		self = self.limitTo(minSize: minSize, maxSize: maxSize)
	}
	
	func limitTo(minSize: CGSize, maxSize: CGSize) -> CGSize {
		var result = self
		
		result.width = max(minSize.width, result.width)
		result.height = max(minSize.height, result.height)
		
		if maxSize.width > 0 && maxSize.width >= minSize.width {
			result.width = min(maxSize.width, result.width)
		}
		if maxSize.height > 0 && maxSize.height >= minSize.height {
			result.height = min(maxSize.height, result.height)
		}
		
		return result
	}
	
}

internal extension Array where Element: Equatable {
	
	func replacingMultipleOccurrences(using array: (of: Element, with: Element)...) -> Array {
		return map { elem in array.first(where: { $0.of == elem })?.with ?? elem }
	}
	
}
