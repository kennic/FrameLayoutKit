//
//  TagListView.swift
//  FrameLayoutKit_Example
//
//  Created by Nam Kennic on 11/18/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FrameLayoutKit

class TagListView: UIView {
	let flowLayout = FlowFrameLayout(axis: .horizontal)
	let addButton = UIButton()
	let removeButton = UIButton()
	let frameLayout = StackFrameLayout(axis: .vertical)
	let colors: [UIColor] = [.red, .green, .blue, .brown, .yellow, .magenta, .black, .orange, .purple, .systemPink]
	
	var onChanged: ((TagListView) -> Void)?
	
	init() {
		super.init(frame: .zero)
		
		backgroundColor = .gray
		
		flowLayout.interItemSpacing = 4
		flowLayout.lineSpacing = 4
		flowLayout.padding(top: 4, left: 4, bottom: 4, right: 4)
		flowLayout.distribution = .left
		
		addButton.setTitle("Add Item", for: .normal)
		addButton.backgroundColor = .systemBlue
		addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
		addButton.showsTouchWhenHighlighted = true
		
		removeButton.setTitle("Remove Item", for: .normal)
		removeButton.backgroundColor = .systemPink
		removeButton.addTarget(self, action: #selector(removeLastItem), for: .touchUpInside)
		removeButton.showsTouchWhenHighlighted = true
		
		addSubview(flowLayout)
		addSubview(addButton)
		addSubview(removeButton)
		addSubview(frameLayout)
		
		// Disable justified last stack
		flowLayout.onNewStackBlock = { (sender, layout) in
			sender.stacks.forEach {
				$0.isJustified = $0 != sender.lastStack
			}
		}
		
		frameLayout + flowLayout
		frameLayout + HStackLayout {
			$0 + [removeButton, addButton]
			$0.distribution = .equal
			$0.fixSize = CGSize(width: 0, height: 50)
		}
		
		frameLayout.spacing = 4
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return frameLayout.sizeThatFits(size)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		frameLayout.frame = bounds
	}
	
	fileprivate func color(index: Int? = nil) -> UIColor {
		let finalIndex = (index ?? Int(arc4random())) % colors.count
		return colors[finalIndex].withAlphaComponent(0.4)
	}
	
	@objc func addItem() {
		let count = flowLayout.views.count
		let title = Int.random(in: 0..<3) > 1 ? Int.random(in: 0..<1_000_000_000_000) : Int.random(in: 0..<100)
		let tagButton = UIButton()
		tagButton.titleLabel?.font = .systemFont(ofSize: 20)
		tagButton.titleLabel?.adjustsFontSizeToFitWidth = false
		tagButton.titleLabel?.lineBreakMode = .byClipping
		tagButton.setTitle("  [\(count)]: \(title)  ", for: .normal)
		tagButton.setTitleColor(.white, for: .normal)
		tagButton.backgroundColor = color()
		tagButton.layer.cornerRadius = 5.0
		tagButton.layer.masksToBounds = true
		
		flowLayout.views.append(tagButton)
		onChanged?(self)
	}
	
	@objc func removeLastItem() {
		guard let item = flowLayout.views.last else { return }
		item.removeFromSuperview()
		flowLayout.views.removeLast()		
		onChanged?(self)
	}
	
}
