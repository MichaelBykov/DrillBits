//
//  UISnappingSlider.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/13/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

/// A wrapper for `UISlider` that allows for snapping the value to whole numbers
class UISnappingSlider: UISlider {
	
	private var snap: Bool = false;
	/// Should the slider snap?
	@IBInspectable public var Snap: Bool {
		get { return snap; }
		set { snap = newValue; value = round(value); }
	}
	
	private var LastValue: Float = 0;
	/// The value of the slider
	override var value: Float {
		didSet {
			if (value != LastValue) {
				let Selector = UISelectionFeedbackGenerator();
				Selector.prepare();
				Selector.selectionChanged();
				
				LastValue = value;
			}
		}
	}
	
	override func setValue(_ value: Float, animated: Bool) {
		if (!snap) {
			super.setValue(value, animated: animated);
			return;
		}
		
		if (value != round(value)) {
			self.value = round(value);
		} else if (value != LastValue) {
			super.setValue(value, animated: animated);
		}
	}
}
