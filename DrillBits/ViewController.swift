//
//  ViewController.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/10/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var ScrollView: UIScrollView!
	
	
	
	@IBOutlet weak var SizeWhole: UILabel!
	@IBOutlet weak var SizeNumerator: UILabel!
	@IBOutlet weak var SizeDenominator: UILabel!
	// We will remove this when unit type = mm
	@IBOutlet weak var SizeFractionWrapper: UIView!
	@IBOutlet weak var SizeFractionLeading: NSLayoutConstraint!
	@IBOutlet weak var SizeFractionTrailing: NSLayoutConstraint!
	@IBOutlet weak var SizeUnitToWhole: NSLayoutConstraint!
	@IBOutlet weak var SizeUnit: UILabel!
	@IBOutlet weak var SizeUnitSelector: UISegmentedControl!
	
	public var WholeValue: CGFloat = 3;
	public var NumeratorValue: CGFloat = 0;
	public var DenominatorValue: CGFloat = 16;
	
	/// Are we using the Imperial (inches) or Metric (mm) system?
	public var IsImperial: Bool = true;
	
	
	
	@IBOutlet weak var DrillBitPicker: UIDetailView!
	@IBOutlet weak var MaterialPicker: UIDetailView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		// Make sure our scroll view has proper insets
		ScrollView.contentInsetAdjustmentBehavior = .always;
		
		// Add handlers (because swift doesn't allow custom IBActions for views)
		DrillBitPicker.OnSelectionChanged += DrillBitSelectionChanged;
		MaterialPicker.OnSelectionChanged += MaterialSelectionChanged;
	}
	
	
	
	//
	// Size
	//
	
	/// Update the size input size value
	public func SizeUpdateFraction() {
		if (IsImperial) {
			// Floor `WholeValue` so we won't have decimals in the fraction
			SizeWhole.text			= "\(floor(WholeValue))";
			SizeNumerator.text		= "\(NumeratorValue)";
			SizeDenominator.text	= "\(DenominatorValue)";
		} else {
			SizeWhole.text			= "\(WholeValue)";
		}
	}
	
	@IBAction func SizeUnitSelectorValueChanged(_ sender: UISegmentedControl) {
		// What the last selected value was
		let LastIsImperial = IsImperial
		
		// What was selected?
		IsImperial = sender.selectedSegmentIndex == 0;
		
		// Just in case
		if (LastIsImperial == IsImperial) {
			return;
		}
		
		// Update unit text
		SizeUnit.text = IsImperial ? "in" :
									 "mm";
		
		// Remove or add back fraction
		if (IsImperial) {
			// Reposition
			SizeFractionWrapper.isHidden = false;
			SizeUnitToWhole.priority = UILayoutPriority.defaultLow;
			SizeFractionLeading.priority = UILayoutPriority.defaultHigh;
			SizeFractionTrailing.priority = UILayoutPriority.defaultHigh;
		} else {
			SizeFractionWrapper.isHidden = true;
			SizeFractionLeading.priority = UILayoutPriority.defaultLow;
			SizeFractionTrailing.priority = UILayoutPriority.defaultLow;
			SizeUnitToWhole.priority = UILayoutPriority.defaultHigh;
		}
		
		// TODO: Update values
		
		updateViewConstraints();
	}
	
	@IBAction func SizeValueChanged(_ sender: UISnappingSlider) {
		// TODO: Add ability to choose the drill bit's size
	}
	
	
	
	//
	// Other
	//
	
	func DrillBitSelectionChanged(Index: Int, Tag: Int) {
		// TODO: Implement
	}
	
	func MaterialSelectionChanged(Index: Int, Tag: Int) {
		// TODO: Implement
	}
}

