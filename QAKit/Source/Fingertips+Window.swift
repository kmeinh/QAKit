//
//  Fingertips+Window.swift
//  QAKit
//
//  Created by Konstantin Deichmann on 22.06.18.
//  Copyright © 2018 Konstantin Deichmann. All rights reserved.
//

import UIKit

// MARK: - UIWindow Swizzle

private var swizzled = false

public extension UIWindow {

	func swizzleSendEvent() {

		guard swizzled == false else {
			return
		}

		swizzled = true
		let sendEvent = class_getInstanceMethod(object_getClass(self), #selector(UIApplication.sendEvent(_:)))
		let swizzledSendEvent = class_getInstanceMethod(object_getClass(self), #selector(UIWindow.__swizzled_sendEvent(_:)))
		method_exchangeImplementations(sendEvent!, swizzledSendEvent!)
	}

	// Important: Do not! call this function on your own.
	@objc func __swizzled_sendEvent(_ event: UIEvent) {

		FingertipsManager.shared?.update(for: event)
		__swizzled_sendEvent(event)
	}
}
