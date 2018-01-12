//
//  ViewController.swift
//  QAKit-Swift
//
//  Created by Konstantin Deichmann on 14.10.17.
//  Copyright © 2017 Konstantin Deichmann. All rights reserved.
//

import UIKit

class MainViewController								: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
	}

	@objc
	func backgroundTapped() {
		self.view.endEditing(true)
	}
}
