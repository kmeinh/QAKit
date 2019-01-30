//
//  Fingertips.swift
//  QAKit-Swift
//
//  Created by Konstantin Deichmann on 14.10.17.
//  Copyright © 2017 Konstantin Deichmann. All rights reserved.
//

import UIKit

public enum FingertipsMode {

	case always
	case onRecord
}

class FingertipsManager {

	static var shared				: FingertipsManager?

	static var swizzled 			= false

	private var fingertipsViews		= [FingertipView]()
	private var mode				: FingertipsMode

	init(mode: FingertipsMode) {

		self.mode = mode
		self.keyWindow?.swizzleSendEvent()

		if #available(iOS 11.0, *) {
			NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: self, queue: nil, using: {_ in })
		}

		NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
	}

	@objc
	private func applicationDidBecomeActive() {
		self.keyWindow?.swizzleSendEvent()
	}

	var keyWindow: UIWindow? {
		return UIApplication.shared.keyWindow
	}

	var topWindow: UIWindow? {
		guard let keyWindow = self.keyWindow else {
			return nil
		}

		return UIApplication.shared.windows.reduce(keyWindow, { (currentWindow, nextWindow) -> UIWindow in
			return (nextWindow.isHidden == false && nextWindow.windowLevel > currentWindow.windowLevel) ? nextWindow : currentWindow
		})
	}

	deinit {
		self.removeAllTouches()
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Touches

	func update(for event: UIEvent) {

		if #available(iOS 11.0, *) {
			guard UIScreen.main.isCaptured == true || self.mode == .always else {
				self.removeAllTouches()
				return
			}
		} else {
			guard (self.mode == .always) else {
				self.removeAllTouches()
				return
			}
		}

		guard
			let allTouches = event.allTouches,
			let topWindow = self.topWindow else {
				self.removeAllTouches()
				return
		}

		for touch in allTouches {

			switch touch.phase {
			case .began			:
				let frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
				let view = FingertipView(touch: touch, frame: frame)
				view.center = touch.location(in: topWindow)
				view.updateTouch()
				self.fingertipsViews.append(view)
				topWindow.addSubview(view)
			case .moved			:
				guard let view = self.fingertipView(for: touch) else {
					continue
				}

				view.center = touch.location(in: topWindow)
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

	private func fingertipView(for touch: UITouch) -> FingertipView? {

		return self.fingertipsViews.first(where: { (view: FingertipView) -> Bool in
			return view.touch == touch
		})
	}
}

// MARK: - FingertipView

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
		self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
	}
}
