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
	let label = UILabel()
	let imageView = UIImageView(image: #imageLiteral(resourceName: "earth_48x48"))
	var frameLayout: DoubleFrameLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .lightGray
		
		label.text = "Hello World"
		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = .red
		label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		
		frameLayout = DoubleFrameLayout(direction: .horizontal, alignment: .left, views: [imageView, label])
//		frameLayout.contentAlignment = (.center, .center)
		frameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		frameLayout.showFrameDebug = true
		frameLayout.spacing = 5
		frameLayout.isIntrinsicSizeEnabled = true
		frameLayout.heightRatio = 3/4
		
		view.addSubview(label)
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

