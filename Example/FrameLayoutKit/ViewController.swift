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
	let imageView = UIImageView(image: #imageLiteral(resourceName: "earth_48x48"))
	var frameLayout: StackFrameLayout!
	
	func createLabel(text: String, backgroundColor: UIColor) -> UILabel {
		let label = UILabel()
		label.text = text
		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = backgroundColor
		label.numberOfLines = 1
		label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
		return label
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .lightGray
		
		let label1 = createLabel(text: "Hello World 1", backgroundColor: .red)
		let label2 = createLabel(text: "Hello World 2", backgroundColor: .green)
		let label3 = createLabel(text: "Hello World 3", backgroundColor: .blue)
		let label4 = createLabel(text: "Hello World 4", backgroundColor: .black)
		let label5 = createLabel(text: "Hello World 5", backgroundColor: .purple)
		
		let labels = DoubleFrameLayout(direction: .vertical, alignment: .left, views: [label4, label5])
		labels.spacing = 5
		labels.isIntrinsicSizeEnabled = true
//		view.addSubview(labels)
		
		let labelsLayout = DoubleFrameLayout(direction: .horizontal, alignment: .left, views: [label3, labels])
		labelsLayout.spacing = 5
		labelsLayout.isIntrinsicSizeEnabled = true
		
		frameLayout = StackFrameLayout(direction: .vertical, alignment: .top, views: [label1, label2, imageView, labelsLayout])
		frameLayout.frameLayout(at: 2)?.contentAlignment = (.center, .center)
		frameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		frameLayout.showFrameDebug = true
		frameLayout.spacing = 5
		frameLayout.isIntrinsicSizeEnabled = true
		
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
		let contentSize = frameLayout.sizeThatFits(viewSize)
		frameLayout.frame = CGRect(x: (viewSize.width - contentSize.width)/2, y: (viewSize.height - contentSize.height)/2, width: contentSize.width, height: contentSize.height)
	}

}

