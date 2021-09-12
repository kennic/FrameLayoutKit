//
//  FlowFrameLayout+Chainable.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 9/12/21.
//

import Foundation
import UIKit

extension FlowFrameLayout {
	
	@discardableResult public func axis(_ value: NKLayoutAxis) -> Self {
		axis = value
		return self
	}
	
	@discardableResult public func distribution(_ value: NKLayoutDistribution) -> Self {
		distribution = value
		return self
	}
	
}

