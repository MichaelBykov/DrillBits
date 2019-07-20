//
//  UIViewWatcher.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/19/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

/// A wrapper around `UIView` that allows for size changed listening
class UIViewWatcher: UIView {

	/// An event that fires whenever the view's bounds change
	public var OnBoundsChanged: Event<CGRect> = Event<CGRect>();
	override var bounds: CGRect {
		didSet {
			OnBoundsChanged <- bounds;
		}
	}
}
