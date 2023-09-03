//
//  FLSkeletonView.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 9/3/23.
//

import UIKit

public class FLSkeletonView: UIView {
	let gradient = CAGradientLayer()
	let lightLayer = CAShapeLayer()
	let animation = CABasicAnimation(keyPath: "locations")
	
	public override var backgroundColor: UIColor? {
		didSet {
			lightLayer.fillColor = UIColor.lightText.cgColor
		}
	}
	
	init() {
		super.init(frame: .zero)
		
		layer.cornerRadius = 5
		layer.masksToBounds = true
		layer.addSublayer(lightLayer)
		
		let light = UIColor.clear.cgColor
		let dark = UIColor.black.cgColor
		
		gradient.colors = [dark, light, dark]
		gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
		gradient.locations = [0.4, 0.5, 0.6]
		lightLayer.mask = gradient
		
		animation.fromValue = [0.0, 0.1, 0.2]
		animation.toValue = [0.8, 0.9, 1.0]
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func didMoveToSuperview() {
		if superview != nil {
			startShimmering()
		}
		else {
			stopShimmering()
		}
	}
	
	func startShimmering(duration: TimeInterval = 1.0, repeatCount: Float = HUGE, repeatDuration: TimeInterval = 0) {
		animation.duration = duration
		animation.repeatCount = repeatCount
		animation.repeatDuration = repeatDuration
		gradient.add(animation, forKey: "shimmer")
	}
	
	func stopShimmering() {
		layer.mask?.removeAllAnimations()
		layer.mask = nil
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		lightLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
		lightLayer.frame = bounds
		gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
	}
	
	deinit {
		stopShimmering()
	}

}
