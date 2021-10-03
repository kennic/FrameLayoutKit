//
//  StackFrameLayout+Chainable.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 9/12/21.
//

import Foundation
import UIKit

extension StackFrameLayout {
	
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
	
	@discardableResult public func justified(_ value: Bool) -> Self {
		isJustified = value
		return self
	}
	
	@discardableResult public func justifyThreshold(_ value: CGFloat) -> Self {
		justifyThreshold = value
		return self
	}
	
	@discardableResult public func minItemSize(_ value: CGSize) -> Self {
		minItemSize = value
		return self
	}
	
	@discardableResult public func maxItemSize(_ value: CGSize) -> Self {
		maxItemSize = value
		return self
	}
	
	@discardableResult public func fixItemSize(_ value: CGSize) -> Self {
		fixItemSize = value
		return self
	}
	
	@discardableResult public func clipToBounds(_ value: Bool) -> Self {
		clipsToBounds = value
		return self
	}
	
}
