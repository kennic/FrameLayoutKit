//
//  StackLayout.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 7/19/18.
//

import UIKit

public class StackLayout: FrameLayout {
	
	public var layoutAlignment: LayoutAlignment = .top
	public var layoutDirection: LayoutDirection = .auto
	public var isIntrinsicSizeEnabled: Bool = true
	public var spacing: CGFloat = 0 {
		didSet {
			if spacing != oldValue {
				setNeedsLayout()
			}
		}
	}
	public var splitRatio: CGFloat = 0.5
	
	override public var ignoreHiddenView: Bool {
		didSet {
			for layout in frameLayouts {
				layout.ignoreHiddenView = ignoreHiddenView
			}
		}
	}
	
	override public var shouldCacheSize: Bool {
		didSet {
			for layout in frameLayouts {
				layout.shouldCacheSize = shouldCacheSize
			}
		}
	}
	
	override public var showFrameDebug: Bool {
		didSet {
			for layout in frameLayouts {
				layout.showFrameDebug = showFrameDebug
			}
		}
	}
	
	override public var allowContentVerticalGrowing: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentVerticalGrowing = allowContentVerticalGrowing
			}
		}
	}
	
	override public var allowContentVerticalShrinking: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentVerticalShrinking = allowContentVerticalShrinking
			}
		}
	}
	
	override public var allowContentHorizontalGrowing: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentHorizontalGrowing = allowContentHorizontalGrowing
			}
		}
	}
	
	override public var allowContentHorizontalShrinking: Bool {
		didSet {
			for layout in frameLayouts {
				layout.allowContentHorizontalShrinking = allowContentHorizontalShrinking
			}
		}
	}
	
	override public var frame: CGRect {
		didSet {
			self.setNeedsLayout()
		}
	}
	
	override public var bounds: CGRect {
		didSet {
			self.setNeedsLayout()
		}
	}
	
	public fileprivate(set) var frameLayouts: [FrameLayout]! = [] {
		didSet {
			
		}
	}
	
	// MARK: -
	
	convenience public init(direction: LayoutDirection, alignment: LayoutAlignment = .top, views: [UIView]? = nil) {
		self.init()
		
		self.layoutDirection = direction
		self.layoutAlignment = alignment
		
		
	}
	
	override public init() {
		super.init()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: -
	
	@discardableResult
	public func append(frameLayout: FrameLayout) -> FrameLayout {
		if frameLayouts.contains(frameLayout) == false {
			frameLayouts.append(frameLayout)
		}
		
		self.addSubview(frameLayout)
		return frameLayout
	}
	
	@discardableResult
	public func insert(frameLayout: FrameLayout, at index: Int) -> FrameLayout {
		frameLayouts.insert(frameLayout, at: index)
		return frameLayout
	}
	
	public func removeFrameLayout(at index: Int, autoRemoveTargetView: Bool = false) {
		guard index >= 0 && index < frameLayouts.count else {
			return
		}
		
		let frameLayout = frameLayouts[index]
		if frameLayout.superview == self {
			frameLayout.removeFromSuperview()
		}
		
		if autoRemoveTargetView {
			frameLayout.targetView?.removeFromSuperview()
		}
		
		frameLayout.targetView = nil
		frameLayouts.remove(at: index)
	}
	
	public func removeAll(autoRemoveTargetView: Bool = false) {
		for layout in frameLayouts {
			if autoRemoveTargetView {
				layout.targetView?.removeFromSuperview()
			}
			
			layout.targetView = nil
			if layout.superview == self {
				layout.removeFromSuperview()
			}
		}
		
		frameLayouts.removeAll()
	}
	
	@discardableResult
	public func addFrameLayout(targetView: UIView? = nil) -> FrameLayout {
		let frameLayout = FrameLayout(targetView: targetView)
		frameLayout.showFrameDebug = showFrameDebug
		frameLayouts.append(frameLayout)
		self.addSubview(frameLayout)
		return frameLayout
	}
	
	@discardableResult
	public func addEmptySpace(size: CGSize) -> FrameLayout {
		let frameLayout = addFrameLayout()
		frameLayout.fixSize = size
		return frameLayout
	}
	
	// MARK: -
	
	override public func setNeedsLayout() {
		super.setNeedsLayout()
		
		for layout in frameLayouts {
			layout.setNeedsLayout()
		}
	}
	
}
