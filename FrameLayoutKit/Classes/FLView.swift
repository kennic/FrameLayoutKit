//
//  FLView.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 10/16/21.
//

import UIKit

open class FLView<T: FrameLayout>: UIView {
	public let frameLayout = T()
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		return frameLayout.sizeThatFits(size)
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		frameLayout.frame = bounds
	}
	
}
