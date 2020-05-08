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
	let frameLayout = StackFrameLayout(axis: .vertical)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .lightGray
		
		#if targetEnvironment(macCatalyst)
		for _ in 0..<1 {
			let cardView = CardView()
			view.addSubview(cardView)
			frameLayout.add(cardView)
		}
		#else
		let cardView = CardView()
		view.addSubview(cardView)
		frameLayout.add(cardView)
		#endif
		
		let numberPadView = NumberPadView()
		view.addSubview(numberPadView)
		frameLayout.add(numberPadView).minSize = CGSize(width: 300, height: 300)
		
		frameLayout.spacing = 20
		frameLayout.edgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
		frameLayout.distribution = .center
		view.addSubview(frameLayout)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		frameLayout.frame = view.bounds
	}

}
