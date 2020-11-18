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
	let colors: [UIColor] = [.red, .green, .blue, .brown, .gray, .yellow, .magenta, .black, .orange, .purple]
	
	var onChanged: ((TagListView) -> Void)?
	
	init() {
		super.init(frame: .zero)
		
		backgroundColor = .gray
		
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
		
		frameLayout + flowLayout
		frameLayout + HStackLayout {
			$0 + [removeButton, addButton]
			$0.distribution = .equal
			$0.fixSize = CGSize(width: 0, height: 50)
		}
		
//		frameLayout.spacing = 20
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
		let title = Int.random(in: 0..<3) > 1 ? Int.random(in: 0..<1_000_000_000) : Int.random(in: 0..<1_000)
		let tagButton = UIButton()
		tagButton.titleLabel?.font = .systemFont(ofSize: 10)
		tagButton.titleLabel?.adjustsFontSizeToFitWidth = false
		tagButton.titleLabel?.lineBreakMode = .byClipping
		tagButton.setTitle("  [\(count)]: \(title)  ", for: .normal)
		tagButton.setTitleColor(.white, for: .normal)
		tagButton.backgroundColor = color()
		
		flowLayout.views.append(tagButton)
		print("\(count + 1) items")
		onChanged?(self)
	}
	
	@objc func removeLastItem() {
		guard let item = flowLayout.views.last else { return }
		item.removeFromSuperview()
		flowLayout.views.removeLast()
		print("\(flowLayout.views.count) items")
		onChanged?(self)
	}
	
}
