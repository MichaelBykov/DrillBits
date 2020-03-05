//
//  ViewController.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/10/19.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit
import DrillBitsData

class ViewController: UIViewController {
	
	@IBOutlet weak var ScrollView: UICancelableScrollView!
	
	
	
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
	@IBOutlet weak var SizeSlider: UISnappingSlider!
	
	/// Are we using the Imperial (inches) or Metric (mm) system?
	@inline(__always) public var IsImperial: Bool { get { return Size.IsImperial!; } set { Size.IsImperial = newValue; } }
	public var Size: DrillBitsData.Unit = Unit(Inches: Fraction(w: 0));
	
	public var InchesStep: Int = 16;
	
	
	
	@IBOutlet weak var DrillBitPicker: UIDetailView!
	public var SelectedBit: DrillBit = .Twist;
	@IBOutlet weak var MaterialPicker: UIDetailView!
	public var SelectedMat: Material = .Softwood;
	
	
	
	@IBOutlet weak var Result: UILabel!
	@IBOutlet weak var ResultContainer: UIView!
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		// Make sure our scroll view has proper insets
		ScrollView.contentInsetAdjustmentBehavior = .always;
		// Make sure the scroll view doesn't start scrolling while the user is inputting
		ScrollView.RootCancels = [ DrillBitPicker.SelectionView, MaterialPicker.SelectionView, SizeSlider ];
		
		// Add data for drill bit picker
		let BitData: [DrillBitData] = LoadDrillBitData();
		DrillBitPicker.Data = BitData.map({ d in return (d.Image, d.Index, d.Name, d.Desc); });
		
		// Add handlers (because swift doesn't allow custom IBActions for views)
		// Selection changed
		DrillBitPicker.OnSelectionChanged += DrillBitSelectionChanged;
		MaterialPicker.OnSelectionChanged += MaterialSelectionChanged;
		// Selection ended (save values)
		DrillBitPicker.OnSelectionEnded += { self.SaveBit(); self.SaveMat(); self.SaveSize(); };
		MaterialPicker.OnSelectionEnded += { self.SaveMat(); self.SaveSize(); };
		SizeSlider.OnSelectionEnded = { self.SaveSize(); };
		
		
		// Load user prefrences for units, size, material, bit
		if (Defaults.Start) {
			let NewSize = Defaults.Size;
			let Mat = Defaults.Mat;
			
			IsImperial = !Defaults.Imperial;
			SizeUnitSelector.selectedSegmentIndex = IsImperial ? 1 : 0;
			SizeUnitSelectorValueChanged(SizeUnitSelector);
			
			SelectedBit = Defaults.Bit;
			
			DrillBitPicker.Select(Index: SelectedBit.rawValue);
			DrillBitSelectionChanged(SelectedBit.rawValue, Tag: SelectedBit.rawValue);
			
			MaterialPicker.Select(Index: MaterialPicker.Data.lastIndex(where: { m in return m.1 == Mat.rawValue; }) ?? 0);
			
			SizeSlider.value = NewSize;
			SizeValueChanged(SizeSlider);
		} else {
			// Setup user prefrences
			Defaults.Imperial = IsImperial;
			
			Defaults.Size = 0;
			
			Defaults.Bit = SelectedBit;
			Defaults.Mat = SelectedMat;
			
			DrillBitPicker.Select(Index: 0);
			DrillBitSelectionChanged(0, Tag: 0);
		}
		
		// For result view
		ScrollView.delegate = ScrollView;
		ScrollView.OnScroll += {
			var h: CGFloat = self.ResultContainer.frame.height - 44;
			h = h < 40 ? 40 : h > 60 ? 60 : h;
			
			self.Result.font = UIFont(descriptor: self.Result.font.fontDescriptor, size: h);
		};
	}
	
	
	
	// MARK: - Defaults
	
	
	/// Save what the currently selected drill bit is
	public func SaveBit() { Defaults.Bit = SelectedBit; }
	/// Save what the currently selected material is
	public func SaveMat() { Defaults.Mat = SelectedMat; }
	/// Save what the currently selected size is
	public func SaveSize() { Defaults.Size = SizeSlider.value; }
	/// Save what the currently selected unit system is
	public func SaveImperial() { Defaults.Imperial = IsImperial; }
	
	
	
	// MARK: - Size
	
	
	/// Update the size input size value
	public func SizeUpdateFraction() {
		if (IsImperial) {
			SizeWhole.text			= "\(Size.Inches.Whole)";
			SizeNumerator.text		= "\(Size.Inches.Numerator)";
			SizeDenominator.text	= "\(Size.Inches.Denominator)";
		} else {
			SizeWhole.text			= "\(Size.Millimeters)";
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
		
		// Preserve Size slider position & update values
		let val: CGFloat = CGFloat(SizeSlider.value - SizeSlider.minimumValue) / CGFloat(SizeSlider.maximumValue - SizeSlider.minimumValue);
		// "Bubble" event
		MaterialSelectionChanged(0, Tag: SelectedMat.rawValue);
		SizeSlider.value = Float(CGFloat(SizeSlider.maximumValue - SizeSlider.minimumValue) * val);
		SizeValueChanged(SizeSlider);
		
		
		updateViewConstraints();
		
		SaveImperial();
	}
	
	var LastSize: DrillBitsData.Unit = Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6);
	@IBAction func SizeValueChanged(_ sender: UISnappingSlider) {
		if (IsImperial) {
			// Derive new value
			let inches = Fraction(Normal: Int(sender.value), MaxDenominator: InchesStep);
			
			// Set values
			Size.Inches = inches;
			if (SetLastSize) {
				LastSize.Inches = inches;
			}
			
			// Update text
			SizeWhole.text = "\(inches.Whole == 0 ? "" : "\(inches.Whole)")";
			SizeNumerator.text = "\(inches.Numerator)";
			SizeDenominator.text = "\(inches.Denominator)";
			
			// Toggle the fraction
			if (inches.Numerator == 0) {
				// Remove fraction display
				SizeFractionWrapper.isHidden = true;
				SizeFractionLeading.priority = UILayoutPriority.defaultLow;
				SizeFractionTrailing.priority = UILayoutPriority.defaultLow;
				SizeUnitToWhole.priority = UILayoutPriority.defaultHigh;
			} else {
				// Add back fraction display
				SizeFractionWrapper.isHidden = false;
				SizeUnitToWhole.priority = UILayoutPriority.defaultLow;
				SizeFractionLeading.priority = UILayoutPriority.defaultHigh;
				SizeFractionTrailing.priority = UILayoutPriority.defaultHigh;
			}
		} else {
			// Derive new value
			let s = CGFloat(SizeSlider.value) / 2;
			
			// Set values
			Size.Millimeters = s;
			if (SetLastSize) {
				LastSize.Millimeters = s;
			}
			
			// Update text
			SizeWhole.text = "\(s)";
		}
		
		// Update results
		self.Result.text = "\(GetSpeed(Bit: SelectedBit, Mat: SelectedMat, Size: Size))"
	}
	
	
	
	// MARK: - Other
	
	
	var LastMaterial: Material = .Softwood;
	var SetLastMaterial: Bool = true;
	func DrillBitSelectionChanged(_: Int, Tag: Int) {
		// Update drill bit display
		let Bit = DrillBit(rawValue: Tag)!;
		self.SelectedBit = Bit;
		self.DrillBitPicker.SelectedImage.image = UIImage(named: "\(ToString(Bit: Bit)) Detail");
		
		// Add data for material picker
		let NewData = LoadMaterialData(For: Bit);
		let MatIndex = NewData.firstIndex(where: { item in return item.Mat == LastMaterial; });
		
		SetLastMaterial = false;
		self.MaterialPicker.Data = NewData.map({ m in return (m.Image, m.Index, m.Name, m.Desc); });
		
		if (MatIndex != nil) {
			// "Bubble" event
			self.MaterialPicker.Select(Index: MatIndex!);
		}
		SetLastMaterial = true;
	}
	
	var SetLastSize: Bool = true;
	func MaterialSelectionChanged(_: Int, Tag: Int) {
		// Update material display
		let Mat = Material(rawValue: Tag)!;
		self.SelectedMat = Mat;
		self.MaterialPicker.SelectedImage.image = GetImageFor(Mat: Mat);
		
		
		// Get the new size bound data for the bit + material
		let (LowerSize, UpperSize) = GetSize(Bit: self.SelectedBit, Mat: self.SelectedMat);
		
		SetLastSize = false;
		
		// Adjust size slider bounds
		if (IsImperial) {
			SizeSlider.minimumValue = Float(LowerSize.Inches.Normalize(MaxDenominator: InchesStep));
			SizeSlider.maximumValue = Float(UpperSize.Inches.Normalize(MaxDenominator: InchesStep));
		} else {
			SizeSlider.minimumValue = Float(LowerSize.Millimeters * 2);
			SizeSlider.maximumValue = Float(UpperSize.Millimeters * 2);
		}
		
		// keep old size value
		let last = Float(IsImperial ? LastSize.Inches.Normalize(MaxDenominator: InchesStep) : Int(LastSize.Millimeters * 2));
		
		if (last <= SizeSlider.minimumValue) {
			SizeSlider.value = SizeSlider.minimumValue;
		} else if (last >= SizeSlider.maximumValue) {
			SizeSlider.value = SizeSlider.maximumValue;
		} else {
			self.SizeSlider.value = last;
		}
		
		// "Bubble" event
		self.SizeValueChanged(self.SizeSlider);
		SetLastSize = true;
		
		if (SetLastMaterial) {
			LastMaterial = Mat;
		}
	}
}

