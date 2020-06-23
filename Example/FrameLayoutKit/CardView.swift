//
//  CardView.swift
//  FrameLayoutKit_Example
//
//  Created by Nam Kennic on 5/8/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FrameLayoutKit

class CardView: UIView {
	let earthImageView = UIImageView(image: UIImage(named: "earth_48x48"))
	let rocketImageView = UIImageView(image: UIImage(named: "rocket_32x32"))
	let nameLabel = UILabel()
	let dateLabel = UILabel()
	let messageLabel = UILabel()
	let expandButton = UIButton(type: .detailDisclosure)
	let frameLayout = StackFrameLayout(axis: .horizontal)
	
	var onSizeChanged: ((CardView) -> Void)?
	
	init() {
		super.init(frame: .zero)
		
		layer.backgroundColor = UIColor.white.cgColor
		layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
		layer.shadowOffset = .zero
		layer.shadowRadius = 5
		layer.shadowOpacity = 0.6
		layer.masksToBounds = false
		
		expandButton.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
		
		nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
		nameLabel.text = "John Appleseed"
		
		dateLabel.font = .systemFont(ofSize: 15, weight: .thin)
		dateLabel.text = "01/01/2020"
		
		messageLabel.font = .systemFont(ofSize: 18, weight: .regular)
		messageLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
		
		[nameLabel, dateLabel, messageLabel].forEach { (label) in
			label.numberOfLines = 0
			label.textColor = .black
		}
		
		[earthImageView, rocketImageView, nameLabel, dateLabel, messageLabel, expandButton].forEach { (view) in
			addSubview(view)
		}
		
		// Standard syntax:
		
		/*
		frameLayout.add(VStackLayout {
		$0.add(earthImageView).alignment = (.top, .center)
		$0.addSpace().flexible()
		$0.add(rocketImageView).alignment = (.center, .center)
		})
		
		frameLayout.add(VStackLayout {
		$0.add([nameLabel, dateLabel])
		$0.addSpace(10)
		$0.add(messageLabel)
		$0.spacing = 5.0
		})
		*/
		
		// Operand syntax:
		
		frameLayout + VStackLayout {
			($0 + earthImageView).alignment = (.top, .center)
			($0 + 0).flexible()
			($0 + rocketImageView).alignment = (.center, .center)
		}
		frameLayout + VStackLayout {
			$0 + HStackLayout {
				($0 + nameLabel).flexible()
				$0 + expandButton
				$0.distribution = .right
			}
			$0 + dateLabel
			$0 + 10.0
			$0 + messageLabel
			
			$0.flexible()
			$0.spacing = 5.0
		}
		
		frameLayout.spacing = 15.0
		frameLayout.padding(top: 15, left: 15, bottom: 15, right: 15)
//		frameLayout.debug = true
		addSubview(frameLayout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return frameLayout.sizeThatFits(size)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		frameLayout.frame = bounds
	}
	
	@objc func onButtonTap() {
		messageLabel.isHidden = !messageLabel.isHidden
		setNeedsLayout()
		onSizeChanged?(self)
	}
	
}
