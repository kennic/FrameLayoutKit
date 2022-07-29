//
//  GridFrameLayout+Chainable.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 9/12/21.
//

import Foundation
import UIKit

extension GridFrameLayout {
	
	@discardableResult public func axis(_ value: NKLayoutAxis) -> Self {
		axis = value
		return self
	}
	
	@discardableResult public func minRowHeight(_ value: CGFloat) -> Self {
		minRowHeight = value
		return self
	}
	
	@discardableResult public func maxRowHeight(_ value: CGFloat) -> Self {
		maxRowHeight = value
		return self
	}
	
	@discardableResult public func minColumnWidth(_ value: CGFloat) -> Self {
		minColumnWidth = value
		return self
	}
	
	@discardableResult public func maxColumnWidth(_ value: CGFloat) -> Self {
		maxColumnWidth = value
		return self
	}
	
	@discardableResult public func fixedRowHeight(_ value: CGFloat) -> Self {
		fixedRowHeight = value
		return self
	}
	
	@discardableResult public func fixedColumnWidth(_ value: CGFloat) -> Self {
		fixedColumnWidth = value
		return self
	}
	
	@discardableResult public func interitemSpacing(_ value: CGFloat) -> Self {
		verticalSpacing = value
		return self
	}
	
	@discardableResult public func lineSpacing(_ value: CGFloat) -> Self {
		horizontalSpacing = value
		return self
	}
	
}
