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
	let frameLayout = FrameLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		label.text = "This is a label"
		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = .red
		label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		
		frameLayout.targetView = label
		frameLayout.contentAlignment = (.center, .center)
		frameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		frameLayout.showFrameDebug = true
		frameLayout.heightRatio = 9/16
		
		view.addSubview(label)
		view.addSubview(frameLayout)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let viewSize = self.view.bounds.size
		let contentSize = frameLayout.sizeThatFits(viewSize)
		frameLayout.frame = CGRect(x: (viewSize.width - contentSize.width)/2, y: (viewSize.height - contentSize.height)/2, width: contentSize.width, height: contentSize.height)
	}

}

