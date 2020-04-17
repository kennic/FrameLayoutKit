//
//  ViewController.swift
//  FrameLayoutKit
//
//  Created by Nam Kennic on 07/12/2018.
//  Copyright (c) 2018 Nam Kennic. All rights reserved.
//

import UIKit
import FrameLayoutKit

class ViewController: UIViewController {
	let frameLayout = StackFrameLayout(axis: .vertical)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .lightGray
		
		#if targetEnvironment(macCatalyst)
		for _ in 0..<3 {
			let cardView = CardView()
			view.addSubview(cardView)
			frameLayout.append(view: cardView)
		}
		#else
		let cardView = CardView()
		view.addSubview(cardView)
		frameLayout.append(view: cardView)
		#endif
		
		frameLayout.spacing = 20
		frameLayout.edgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
		frameLayout.distribution = .center
		view.addSubview(frameLayout)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		frameLayout.frame = view.bounds
	}

}

class CardView: UIView {
	let earthImageView = UIImageView(image: UIImage(named: "earth_48x48"))
	let rocketImageView = UIImageView(image: UIImage(named: "rocket_32x32"))
	let nameLabel = UILabel()
	let dateLabel = UILabel()
	let messageLabel = UILabel()
	let frameLayout = StackFrameLayout(axis: .horizontal)
	
	init() {
		super.init(frame: .zero)
		
		layer.backgroundColor = UIColor.white.cgColor
		layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
		layer.shadowOffset = .zero
		layer.shadowRadius = 5
		layer.shadowOpacity = 0.6
		layer.masksToBounds = false
		
		nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
		nameLabel.text = "FrameLayoutKit"
		
		dateLabel.font = .systemFont(ofSize: 15, weight: .thin)
		dateLabel.text = "Example"
		
		messageLabel.font = .systemFont(ofSize: 18, weight: .regular)
		messageLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
		
		[nameLabel, dateLabel, messageLabel].forEach { (label) in
			label.numberOfLines = 0
			label.textColor = .black
		}
		
		[earthImageView, rocketImageView, nameLabel, dateLabel, messageLabel].forEach { (view) in
			addSubview(view)
		}
		
		let imageLayout = StackFrameLayout(axis: .vertical)
		imageLayout.append(view: earthImageView).contentAlignment = (.top, .center)
		imageLayout.appendSpace(size: 10).isFlexible = true
		imageLayout.append(view: rocketImageView).contentAlignment = (.center, .center)
		
		let labelLayout = StackFrameLayout(axis: .vertical, distribution: .top)
		labelLayout.append(view: nameLabel)
		labelLayout.append(view: dateLabel)
		labelLayout.appendSpace(size: 10.0)
		labelLayout.append(view: messageLabel)
		labelLayout.spacing = 5.0
		
		frameLayout.append(frameLayout: imageLayout)
		frameLayout.append(frameLayout: labelLayout)
		frameLayout.spacing = 15.0
		frameLayout.edgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
		frameLayout.showFrameDebug = true
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
	
}
