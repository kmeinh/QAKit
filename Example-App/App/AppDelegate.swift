//
//  AppDelegate.swift
//  QAKit-Swift
//
//  Created by Konstantin Deichmann on 14.10.17.
//  Copyright © 2017 Konstantin Deichmann. All rights reserved.
//

import UIKit
import QAKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func applicationDidFinishLaunching(_ application: UIApplication) {
		if #available(iOS 11.0, *) {
			QAKit.Fingertips.start(mode: .onRecord)
		}
	}
}
