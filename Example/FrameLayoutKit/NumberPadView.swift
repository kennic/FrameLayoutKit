//
//  NumberPadView.swift
//  FrameLayoutKit_Example
//
//  Created by Nam Kennic on 5/8/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FrameLayoutKit

class NumberPadView: UIView {
	let frameLayout = GridFrameLayout(axis: .horizontal, column: 3, rows: 4)
	let titleMap = "1 2 3 4 5 6 7 8 9 * 0 #"
	let colors: [UIColor] = [.red, .green, .blue, .brown, .gray, .yellow, .magenta, .black, .orange, .purple]
	
	fileprivate func color(index: Int? = nil) -> UIColor {
		let finalIndex = (index ?? Int(arc4random())) % colors.count
		return colors[finalIndex].withAlphaComponent(0.4)
	}
	
	init() {
		super.init(frame: .zero)
		let titles = titleMap.components(separatedBy: " ")
		var i = 0
		let buttons = titles.map { (title) -> UIButton in
			let button = UIButton()
			button.setTitle(title, for: .normal)
			button.backgroundColor = color(index: i)
			button.showsTouchWhenHighlighted = true
			i += 1
			return button
		}
		
		frameLayout.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		frameLayout.horizontalSpacing = 5
		frameLayout.verticalSpacing = 5
		frameLayout.isAutoSize = false
		frameLayout.views = buttons
		frameLayout.isUserInteractionEnabled = true
		backgroundColor = UIColor.black.withAlphaComponent(0.1)
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
