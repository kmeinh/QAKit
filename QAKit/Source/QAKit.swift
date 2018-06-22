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

		public static func start(mode: FingertipsMode = .onRecord) {

			FingertipsManager.shared = FingertipsManager(mode: mode)
		}

		public static func hide() {

			FingertipsManager.shared = nil
		}
	}
}
