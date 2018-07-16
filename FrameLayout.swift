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
	public var showFrameDebug: Bool = false {
		didSet {
			self.setNeedsDisplay()
		}
	}
	public var debugColor: UIColor? = nil
	
	public var fixSize: CGSize = .zero {
		didSet {
			minSize = fixSize
			maxSize = fixSize
		}
	}
	
	public var contentAlignment: (NKContentVerticalAlignment, NKContentHorizontalAlignment) = (.fill, .fill) {
		didSet {
			contentVerticalAlignment = contentAlignment.0
			contentHorizontalAlignment = contentAlignment.1
			
			setNeedsLayout()
		}
	}
	
	public var configurationBlock: ((_ frameLayout:FrameLayout) -> Void)? = nil {
		didSet {
			configurationBlock?(self)
		}
	}
	
	public override var frame: CGRect {
		get {
			return super.frame
		}
		set {
			if frame.isInfinite || frame.isNull || frame.origin.x.isNaN || frame.origin.y.isNaN || frame.size.width.isNaN || frame.size.height.isNaN {
				return
			}
			
			super.frame = frame
			self.setNeedsLayout()
			self.setNeedsDisplay()
			
			if self.superview == nil {
				self.layoutIfNeeded()
			}
		}
	}
	
	public override var bounds: CGRect {
		get {
			return super.bounds
		}
		set {
			if bounds.isInfinite || bounds.isNull || bounds.origin.x.isNaN || bounds.origin.y.isNaN || bounds.size.width.isNaN || bounds.size.height.isNaN {
				return
			}
			
			super.bounds = bounds
			self.setNeedsLayout()
			self.setNeedsDisplay()
			
			if self.superview == nil {
				self.layoutIfNeeded()
			}
		}
	}
	
	public override var description: String {
		return "[\(super.description)]-targetView: \(String(describing: targetView))"
	}
	
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
		
		if debugColor == nil {
			debugColor = randomColor()
		}
		
		if let context = UIGraphicsGetCurrentContext() {
			context.saveGState()
			context.setStrokeColor(debugColor!.cgColor)
			context.setLineDash(phase: 0, lengths: [4.0, 2.0])
			context.stroke(self.bounds)
			context.restoreGState()
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
	
	override public func setNeedsLayout() {
		super.setNeedsLayout()
		targetView?.setNeedsLayout()
	}
	
	// MARK: -
	
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
	
	fileprivate func randomColor() -> UIColor {
		let colors: [UIColor] = [.red, .green, .blue, .brown, .gray, .yellow, .magenta, .black, .orange, .purple]
		let randomIndex = Int(arc4random()) % colors.count
		return colors[randomIndex]
	}
	
}
