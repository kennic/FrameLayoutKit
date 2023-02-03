//
//  DoubleFrameLayout+Chainable.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 9/12/21.
//

import Foundation
import UIKit

extension DoubleFrameLayout {
	
	@discardableResult public func axis(_ value: NKLayoutAxis) -> Self {
		axis = value
		return self
	}
	
	@discardableResult public func spacing(_ value: CGFloat) -> Self {
		spacing = value
		return self
	}
	
	@discardableResult public func distribution(_ value: NKLayoutDistribution) -> Self {
		distribution = value
		return self
	}
	
	@discardableResult public func overlapped(_ value: Bool) -> Self {
		isOverlapped = value
		return self
	}
	
	@discardableResult public func leftView(_ view: UIView?) -> Self {
		setLeft(view)
		return self
	}
	
	@discardableResult public func rightView(_ view: UIView?) -> Self {
		setRight(view)
		return self
	}
	
}
