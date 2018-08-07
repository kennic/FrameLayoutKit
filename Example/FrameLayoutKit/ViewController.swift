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
	var frameLayout: StackFrameLayout!
	
	func createLabel(text: String, backgroundColor: UIColor) -> UILabel {
		let label = UILabel()
		label.text = text
//		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = backgroundColor
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
		return label
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .lightGray
		
		let imageView = UIImageView(image: #imageLiteral(resourceName: "earth_48x48"))
		
		let label1 = createLabel(text: "Hello World 1", backgroundColor: .red)
		let label2 = createLabel(text: "Hello World 2", backgroundColor: .green)
		let label3 = createLabel(text: "Hello World 3", backgroundColor: .blue)
		let label4 = createLabel(text: "Hello World 4", backgroundColor: .black)
		let label5 = createLabel(text: "Hello World 5", backgroundColor: .purple)
		
//		let loremText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
//		label3.text = loremText
		
		let label4_5 = DoubleFrameLayout(direction: .vertical, alignment: .left, views: [label4, label5])
		label4_5.spacing = 5
		
		let labels3_4_5 = DoubleFrameLayout(direction: .horizontal, alignment: .right, views: [label3, label4_5])
		labels3_4_5.spacing = 5
		
		frameLayout = StackFrameLayout(direction: .vertical, alignment: .top) // views: [label1, label2, imageView, labels3_4_5]
		
		frameLayout.append(view: label1)
		frameLayout.append(view: label2)
		frameLayout.append(view: imageView).contentAlignment = (.center, .center)
		frameLayout.appendEmptySpace(size: 20).debugColor = .yellow
		frameLayout.append(frameLayout: labels3_4_5)
		
		frameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		frameLayout.showFrameDebug = true
		frameLayout.isIntrinsicSizeEnabled = true
		frameLayout.spacing = 5
		
		view.addSubview(label1)
		view.addSubview(label2)
		view.addSubview(label3)
		view.addSubview(label4)
		view.addSubview(label5)
		view.addSubview(imageView)
		view.addSubview(frameLayout)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let viewSize = self.view.bounds.size
		let fitSize = CGSize(width: viewSize.width * 0.8, height: viewSize.height * 0.8)
		let contentSize = frameLayout.sizeThatFits(fitSize)
		frameLayout.frame = CGRect(x: (viewSize.width - contentSize.width)/2, y: (viewSize.height - contentSize.height)/2, width: contentSize.width, height: contentSize.height)
	}

}

