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
	public var heightRatio: CGFloat = 0
	public var contentVerticalAlignment: NKContentVerticalAlignment = .fill
	public var contentHorizontalAlignment: NKContentHorizontalAlignment = .fill
	public var allowContentVerticalGrowing: Bool = false
	public var allowContentVerticalShrinking: Bool = false
	public var allowContentHorizontalGrowing: Bool = false
	public var allowContentHorizontalShrinking: Bool = false
	public var shouldCacheSize: Bool = false
	public var showFrameDebug: Bool = false
	public var debugColor: UIColor? = nil
	
	lazy fileprivate var sizeCacheData: [String: CGSize] = {
		return [:]
	}()
	
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
	
	override public func sizeThatFits(_ size: CGSize) -> CGSize {
		let isHiddenView: Bool = targetView == nil || (targetView!.isHidden && ignoreHiddenView) || self.isHidden
		guard isHiddenView == false else {
			return .zero
		}
		
		
		
		if minSize == maxSize && minSize.width > 0 && minSize.height > 0 {
			return minSize
		}
		
		var result: CGSize
		let verticalEdgeValues = edgeInsets.left + edgeInsets.right
		let horizontalEdgeValues = edgeInsets.top + edgeInsets.bottom
		let contentSize = CGSize(width: max(size.width - verticalEdgeValues, 0), height: max(size.height - horizontalEdgeValues, 0))
		
		if heightRatio > 0.0 {
			result = contentSize
			result.height = contentSize.width * heightRatio
		}
		else {
			result = targetSizeThatFits(size: contentSize)
		}
		
		result.width = max(minSize.width, result.width)
		result.height = max(minSize.height, result.height)
		
		if maxSize.width > 0 && maxSize.width >= minSize.width {
			result.width = min(maxSize.width, result.width)
		}
		if maxSize.height > 0 && maxSize.height >= minSize.height {
			result.height = min(maxSize.height, result.height)
		}
		
		if result.width > 0 {
			result.width += verticalEdgeValues
		}
		if result.height > 0 {
			result.height += horizontalEdgeValues
		}
		
		result.width = min(result.width, size.width)
		result.height = min(result.height, size.height)
		
		return result
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
	}
	
	// MARK: -
	
	fileprivate func targetSizeThatFits(size: CGSize) -> CGSize {
		var result: CGSize
		
		if minSize.equalTo(maxSize) && minSize.width > 0 && minSize.height > 0 {
			result = minSize // fixSize
		}
		else {
			if let targetView = targetView {
				if shouldCacheSize {
					let key = "\(targetView)\(size)"
					if let value = sizeCacheData[key] {
						return value
					}
					else {
						result = targetView.sizeThatFits(size)
						sizeCacheData[key] = result
					}
				}
				else {
					result = targetView.sizeThatFits(size)
				}
			}
			else {
				result = .zero
			}
			
			result.width = max(minSize.width, result.width)
			result.height = max(minSize.height, result.height)
			
			if maxSize.width > 0 && maxSize.width >= minSize.width {
				result.width = min(maxSize.width, result.width)
			}
			if maxSize.height > 0 && maxSize.height >= minSize.height {
				result.height = min(maxSize.height, result.height)
			}
		}
		
		return result
	}
	
}
