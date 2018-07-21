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
	let label1 = UILabel()
	let label2 = UILabel()
	let label3 = UILabel()
	let imageView = UIImageView(image: #imageLiteral(resourceName: "earth_48x48"))
	var frameLayout: StackFrameLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .lightGray
		
		label1.text = "Hello World 1"
		label1.textAlignment = .center
		label1.textColor = .white
		label1.backgroundColor = .red
		label1.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		
		label2.text = "Hello World 2"
		label2.textAlignment = .center
		label2.textColor = .white
		label2.backgroundColor = .green
		label2.numberOfLines = 1
		label2.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		
		label3.text = "Hello World 3"
		label3.textAlignment = .center
		label3.textColor = .white
		label3.backgroundColor = .blue
		label3.numberOfLines = 1
		label3.font = UIFont.systemFont(ofSize: 10, weight: .medium)
		
		frameLayout = StackFrameLayout(direction: .horizontal, alignment: .top, views: [label1, imageView, label2, label3])
//		frameLayout.append(view: imageView)
//		frameLayout.append(view: label)
		frameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		frameLayout.showFrameDebug = true
		frameLayout.spacing = 5
		frameLayout.isIntrinsicSizeEnabled = false
//		frameLayout.leftFrameLayout?.contentAlignment = (.center, .center)
//		frameLayout.rightFrameLayout?.contentAlignment = (.center, .center)
//		frameLayout.firstFrameLayout?.heightRatio = 1
//		frameLayout.rightFrameLayout?.heightRatio = 1
//		frameLayout.leftFrameLayout?.allowContentHorizontalGrowing = true
//		frameLayout.leftFrameLayout?.allowContentVerticalGrowing = true
		
		view.addSubview(label1)
		view.addSubview(label2)
		view.addSubview(label3)
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

