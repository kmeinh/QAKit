//
//  QAKit.swift
//  QAKit-Swift
//
//  Created by Konstantin Deichmann on 09.11.17.
//  Copyright © 2017 Konstantin Deichmann. All rights reserved.
//

import UIKit

public struct QAKit {

	// MARK: - Fingertips

	public struct Fingertips {

		static var window 		: FingertipWindow?

		public static func start(mode: FingertipsMode = .onRecord) {

			guard (self.window == nil) else {
				self.window?.isHidden = false
				return
			}

			let window = FingertipWindow(mode: mode)
			window.windowLevel = UIWindowLevelStatusBar
			window.makeKeyAndVisible()
			window.backgroundColor = UIColor.clear
			window.isHidden = false
			self.window = window
		}

		public static func hide() {

			self.window?.isHidden = true
		}
	}
}
