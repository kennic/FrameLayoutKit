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
		
		view.addSubview(label)
		view.addSubview(frameLayout)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		frameLayout.frame = self.view.bounds
		print("LAYOUT \(frameLayout.frame)")
	}

}

