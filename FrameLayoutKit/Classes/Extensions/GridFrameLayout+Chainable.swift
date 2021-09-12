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
	
}
