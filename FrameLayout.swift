//
//  FrameLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/12/18.
//

import UIKit

public enum NKContentVerticalAlignment : Int {
	case center
	case top
	case bottom
	case fill
	case fit
}

public enum NKContentHorizontalAlignment : Int {
	case center
	case left
	case right
	case fill
	case fit
}

public class FrameLayout: UIView {
	
	public var targetView: UIView? = nil
	public var ignoreHiddenView: Bool = true
	public var edgeInsets: UIEdgeInsets = .zero
	public var minSize: CGSize = .zero
	public var maxSize: CGSize = .zero
	public var contentVerticalAlignment: NKContentVerticalAlignment = .fill
	public var contentHorizontalAlignment: NKContentHorizontalAlignment = .fill
	public var allowContentVerticalGrowing: Bool = false
	public var allowContentVerticalShrinking: Bool = false
	public var allowContentHorizontalGrowing: Bool = false
	public var allowContentHorizontalShrinking: Bool = false
	public var showFrameDebug: Bool = false
	public var debugColor: UIColor? = nil
	
	// MARK: -
	
	convenience init(targetView: UIView) {
		self.init()
		self.targetView = targetView
	}
	
	init() {
		super.init(frame: .zero)
		
		self.backgroundColor = .clear
		self.isUserInteractionEnabled = false
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	#if DEBUG
	override public func draw(_ rect: CGRect) {
		guard showFrameDebug else {
			super.draw(rect)
			return
		}
		
	}
	#endif
	
	override public func layoutSubviews() {
		super.layoutSubviews()
	}
	
	override public func sizeThatFits(_ size: CGSize) -> CGSize {
		return super.sizeThatFits(size)
	}

}
