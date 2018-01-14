//
//  Fingertips.swift
//  QAKit-Swift
//
//  Created by Konstantin Deichmann on 14.10.17.
//  Copyright © 2017 Konstantin Deichmann. All rights reserved.
//

import UIKit

// MARK: - FingertipViewController

@available(iOS 11.0, *)
private class FingertipViewController							: UIViewController {

	// MARK: - Properties

	var fingertipsViews											= [FingertipView]()

	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = .clear
		NotificationCenter.default.addObserver(forName: Notification.Name.UIScreenCapturedDidChange, object: self, queue: nil, using: {_ in })
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Update

	fileprivate func update(for event: UIEvent) {

		if #available(iOS 11.0, *) {
			guard UIScreen.main.isCaptured == true else {
				self.removeAllTouches()
				return
			}
		}

		guard let allTouches = event.allTouches else {
			return
		}

		for touch in allTouches {

			switch touch.phase {
			case .began			:
				let frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
				let view = FingertipView(touch: touch, frame: frame)
				view.center = touch.location(in: self.view)
				view.updateTouch()
				self.fingertipsViews.append(view)
				self.view.addSubview(view)
			case .moved			:
				guard let view = self.fingertipView(for: touch) else {
					continue
				}

				view.center = touch.location(in: self.view)
				view.updateTouch()
			case .stationary	: continue
			case .cancelled,
				 .ended			:

				UIView.animate(withDuration: 0.2, animations: { [weak self] in
					self?.fingertipView(for: touch)?.alpha = 0
				}, completion: { [weak self] (success: Bool) in
					self?.fingertipView(for: touch)?.removeFromSuperview()
				})

			}
		}
	}

	private func removeAllTouches() {

		self.fingertipsViews.forEach { (view: FingertipView) in
			view.removeFromSuperview()
		}

		self.fingertipsViews = []
	}

	// MARK: - Helper

	private func fingertipView(for touch: UITouch) -> FingertipView? {

		return self.fingertipsViews.first(where: { (view: FingertipView) -> Bool in
			return view.touch == touch
		})
	}
}

// MARK: - FingertipView

@available(iOS 11.0, *)
private class FingertipView												: UIView {

	// MARK: - Properties

	var touch															: UITouch

	// MARK: - Init

	init(touch: UITouch, frame: CGRect) {
		self.touch = touch

		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Update Touch

	func updateTouch() {
		self.layer.cornerRadius = (self.frame.height / 2)
		self.layer.masksToBounds = true
		self.layer.borderWidth = 8
		self.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
	}
}

// MARK: - FingertipWindow

@available(iOS 11.0, *)
@objc
class FingertipWindow											: UIWindow {

	// MARK: - Private Properties

	fileprivate var swizzled									= false

	fileprivate static var current								: FingertipWindow?

	fileprivate var fingertipsViewController					: FingertipViewController? {
		return self.rootViewController as? FingertipViewController
	}

	// MARK: - Init

	init() {
		super.init(frame: UIScreen.main.bounds)
		self.rootViewController = FingertipViewController()

		self.swizzleSendEvent()

		FingertipWindow.current = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Hittest

	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return false
	}
}

// MARK: - FingertipWindow Swizzle

@available(iOS 11.0, *)
extension FingertipWindow {

	fileprivate func swizzleSendEvent() {

		guard self.swizzled == false else {
			return
		}

		self.swizzled = true
		let sendEvent = class_getInstanceMethod(object_getClass(self), #selector(UIApplication.sendEvent(_:)))
		let swizzledSendEvent = class_getInstanceMethod(object_getClass(self), #selector(UIWindow.__swizzled_sendEvent(_:)))
		method_exchangeImplementations(sendEvent!, swizzledSendEvent!)
	}
}

// MARK: - UIWindow Swizzle

@available(iOS 11.0, *)
extension UIWindow {

	// Important: Do not! call this function on your own.
	@objc public func __swizzled_sendEvent(_ event: UIEvent) {

		FingertipWindow.current?.fingertipsViewController?.update(for: event)
		__swizzled_sendEvent(event)
	}
}
