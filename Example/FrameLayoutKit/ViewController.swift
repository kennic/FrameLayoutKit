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
	let scrollStackView = ScrollStackView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .lightGray
		
		for _ in 0..<5 {
			scrollStackView.add(CardView())
		}
		
		scrollStackView.add(NumberPadView())
		
		scrollStackView.spacing = 20
		scrollStackView.edgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
		scrollStackView.distribution = .center
		view.addSubview(scrollStackView)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		scrollStackView.frame = view.bounds
	}

}
