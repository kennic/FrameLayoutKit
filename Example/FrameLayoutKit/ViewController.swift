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
	var frameLayout: StackFrameLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .lightGray
		
		label.text = "Hello World"
		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = .red
		label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		
		frameLayout = StackFrameLayout(direction: .vertical, alignment: .top, views: [imageView, label])
		frameLayout.append(view: imageView)
		frameLayout.append(view: label)
		frameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		frameLayout.showFrameDebug = true
		frameLayout.spacing = 5
		frameLayout.isIntrinsicSizeEnabled = true
//		frameLayout.leftFrameLayout?.contentAlignment = (.center, .center)
//		frameLayout.rightFrameLayout?.contentAlignment = (.center, .center)
//		frameLayout.leftFrameLayout?.heightRatio = 1
//		frameLayout.rightFrameLayout?.heightRatio = 1
//		frameLayout.leftFrameLayout?.allowContentHorizontalGrowing = true
//		frameLayout.leftFrameLayout?.allowContentVerticalGrowing = true
		
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

