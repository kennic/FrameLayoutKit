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
	let titleLabel = UILabel()
	let dateLabel = UILabel()
	let messageLabel = UILabel()
	let expandButton = UIButton(type: .contactAdd)
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
		
		titleLabel.textAlignment = .center
		titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
		titleLabel.text = "Admin"
		titleLabel.textColor = .white
		titleLabel.backgroundColor = .purple
		titleLabel.layer.cornerRadius = 4.0
		titleLabel.layer.masksToBounds = true
		
		dateLabel.font = .systemFont(ofSize: 15, weight: .thin)
		dateLabel.text = "\(Date())"
		
		messageLabel.font = .systemFont(ofSize: 18, weight: .regular)
		messageLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
		
		[nameLabel, dateLabel, messageLabel].forEach { (label) in
			label.numberOfLines = 0
			label.textColor = .black
		}
		
		[earthImageView, rocketImageView, nameLabel, titleLabel, dateLabel, messageLabel, expandButton].forEach { (view) in
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
				($0 + nameLabel)//.flexible(ratio: 0.8) // takes 80% of flexible width, uncomment to try it
				($0 + titleLabel).extendSize = CGSize(width: 10, height: 0)
				($0 + 0).flexible()
				$0 + expandButton
				$0.spacing = 10
			}
			$0 + dateLabel
//			$0 + 10.0
			$0 + messageLabel
			
			//--- Example of split(ratio) distribution ---
			($0 + 0.0).flexible()
			$0 + HStackLayout {
				$0.distribution = .split(ratio: [0.5, -1, -1, 0.3]) // -1 means auto
				$0.spacing = 10
				
				($0 + [Label(.yellow), Label(.green), Label(.brown), Label(.systemPink), Label(.blue)]).forEach {
					$0.willSizeThatFitsBlock = { (sender, size) in
						if let label = sender.targetView as? UILabel {
							label.text = "\(size.width) x \(size.height)"
						}
					}
					$0.willLayoutSubviewsBlock = { sender in
						if let label = sender.targetView as? UILabel {
							let size = sender.frame.size
							label.text = "\(size.width) x \(size.height)"
						}
					}
				}
			}
			//---
			
			$0.flexible()
			$0.spacing = 5.0
		}
		
		frameLayout.spacing = 15.0
		frameLayout.padding(top: 15, left: 15, bottom: 15, right: 15)
		frameLayout.debug = true
		addSubview(frameLayout)
	}
	
	func Label(_ color: UIColor) -> UILabel {
		let label = UILabel()
		label.textColor = .black
		label.backgroundColor = color
		return label
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
