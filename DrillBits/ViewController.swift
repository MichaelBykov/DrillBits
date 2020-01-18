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
	public var UpperSize: DrillBitsData.Unit = Unit(Inches: Fraction(w: 0)), LowerSize: DrillBitsData.Unit = Unit(Inches: Fraction(w: 0));
	public var SizeDistance: (Int, Int) = (0, 0);
	
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
		
		// Add data for pickers
		let BitData: [DrillBitData] = LoadDrillBitData();
		DrillBitPicker.Data = BitData.map({ d in return (d.Image, d.Index, d.Name, d.Desc); });
		
		// Add handlers (because swift doesn't allow custom IBActions for views)
		DrillBitPicker.OnSelectionChanged += DrillBitSelectionChanged;
		DrillBitPicker.OnSelectionEnded += { UserDefaults.standard.set(self.SelectedBit.rawValue as Int, forKey: "Bit"); UserDefaults.standard.set(self.SelectedMat.rawValue as Int, forKey: "Mat"); UserDefaults.standard.set(self.SizeSlider.value, forKey: "Size"); };
		MaterialPicker.OnSelectionChanged += MaterialSelectionChanged;
		MaterialPicker.OnSelectionEnded += { UserDefaults.standard.set(self.SelectedMat.rawValue as Int, forKey: "Mat"); UserDefaults.standard.set(self.SizeSlider.value, forKey: "Size"); };
		SizeSlider.OnSelectionEnded = { UserDefaults.standard.set(self.SizeSlider.value, forKey: "Size"); };
		
		// Load user prefrences for units, size, material, bit
		if (UserDefaults.standard.object(forKey: "Start") != nil) {
			let NewSize = UserDefaults.standard.float(forKey: "Size");
			let Mat = Material(rawValue: UserDefaults.standard.integer(forKey: "Mat"))!;
			
			IsImperial = !UserDefaults.standard.bool(forKey: "Imperial");
			SizeUnitSelector.selectedSegmentIndex = IsImperial ? 1 : 0;
			SizeUnitSelectorValueChanged(SizeUnitSelector);
			
			SelectedBit = DrillBit(rawValue: UserDefaults.standard.integer(forKey: "Bit"))!;
			
			DrillBitPicker.Select(Index: SelectedBit.rawValue);
			DrillBitSelectionChanged(SelectedBit.rawValue, Tag: SelectedBit.rawValue);
			
			MaterialPicker.Select(Index: MaterialPicker.Data.lastIndex(where: { m in return m.1 == Mat.rawValue; })!);
			
			SizeSlider.value = NewSize;
			SizeValueChanged(SizeSlider);
		} else {
			// Setup user prefrences
			UserDefaults.standard.set(true, forKey: "Start");
			
			UserDefaults.standard.set(IsImperial, forKey: "Imperial");
			
			UserDefaults.standard.set(Float(0), forKey: "Size");
			
			UserDefaults.standard.set(SelectedBit.rawValue as Int, forKey: "Bit");
			UserDefaults.standard.set(SelectedMat.rawValue as Int, forKey: "Mat");
			
			DrillBitPicker.Select(Index: 0);
			DrillBitSelectionChanged(0, Tag: 0);
		}
		
		// For result view
		ScrollView.delegate = ScrollView;
		ScrollView.OnScroll += {
			var h: CGFloat = self.ResultContainer.frame.height - 44;
			h = h < 40 ? 40 : h > 60 ? 60 : h;
			
			self.Result.font = UIFont(descriptor: self.Result.font.fontDescriptor, size: h);
			
			print(h);
		};
	}
	
	
	
	//
	// Size
	//
	
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
		
		let val: CGFloat = CGFloat(SizeSlider.value) / CGFloat(SizeSlider.maximumValue - SizeSlider.minimumValue);
		MaterialSelectionChanged(0, Tag: SelectedMat.rawValue);
		SizeSlider.value = Float(CGFloat(SizeSlider.maximumValue - SizeSlider.minimumValue) * val);
		SizeValueChanged(SizeSlider);
		
		
		updateViewConstraints();
		
		UserDefaults.standard.set(IsImperial, forKey: "Imperial");
	}
	
	var LastSize: DrillBitsData.Unit = Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6);
	@IBAction func SizeValueChanged(_ sender: UISnappingSlider) {
		if (IsImperial) {
			let div = InchesStep / LowerSize.Inches.Denominator;
			var min = Fraction(w: LowerSize.Inches.Whole, n: LowerSize.Inches.Numerator * div, d: InchesStep);
			min.Numerator += Int(sender.value);
			while (min.Numerator >= InchesStep) {
				min.Numerator -= InchesStep;
				let _ = min.Whole++;
			}
			
			if (min.Numerator == 0) {
				// Remove fraction
				SizeFractionWrapper.isHidden = true;
				SizeFractionLeading.priority = UILayoutPriority.defaultLow;
				SizeFractionTrailing.priority = UILayoutPriority.defaultLow;
				SizeUnitToWhole.priority = UILayoutPriority.defaultHigh;
			} else {
				SizeFractionWrapper.isHidden = false;
				SizeUnitToWhole.priority = UILayoutPriority.defaultLow;
				SizeFractionLeading.priority = UILayoutPriority.defaultHigh;
				SizeFractionTrailing.priority = UILayoutPriority.defaultHigh;
			}
			
			while (min.Numerator % 2 == 0 && min.Denominator > 2) {
				min.Numerator /= 2;
				min.Denominator /= 2;
			}
			
			Size.Inches = min;
			if (SetLastSize) {
				LastSize.Inches = min;
			}
			SizeWhole.text = "\(min.Whole == 0 ? "" : "\(min.Whole)")";
			SizeNumerator.text = "\(min.Numerator)";
			SizeDenominator.text = "\(min.Denominator)";
		} else {
			let s = LowerSize.Millimeters + (CGFloat(SizeSlider.value) / 2);
			Size.Millimeters = s;
			if (SetLastSize) {
				LastSize.Millimeters = s;
			}
			SizeWhole.text = "\(s)";
		}
		
		self.Result.text = "\(GetSpeed(Bit: SelectedBit, Mat: SelectedMat, Size: Size))"
	}
	
	
	
	//
	// Result View
	//
	
	
	
	
	
	//
	// Other
	//
	
	var LastMaterial: Material = .Softwood;
	var SetLastMaterial: Bool = true;
	func DrillBitSelectionChanged(_: Int, Tag: Int) {
		// Set materials
		let Bit = DrillBit(rawValue: Tag)!;
		self.SelectedBit = Bit;
		self.DrillBitPicker.SelectedImage.image = UIImage(named: "\(ToString(Bit: Bit)) Detail");
		let NewData = Materials(For: Bit).map({ m in return (GetImageFor(Mat: m), m.rawValue, ToString(Mat: m), GetDescFor(Mat: m)); });
		let MatIndex = NewData.firstIndex(where: { item in return item.1 == LastMaterial.rawValue; });
		SetLastMaterial = false;
		
		self.MaterialPicker.Data = NewData;
		
		if (MatIndex != nil) {
			self.MaterialPicker.Select(Index: MatIndex!);
		}
		SetLastMaterial = true;
	}
	
	var SetLastSize: Bool = true;
	func MaterialSelectionChanged(_: Int, Tag: Int) {
		// Set upper and lower size boundry
		let Mat = Material.init(rawValue: Tag)!;
		self.SelectedMat = Mat;
		self.MaterialPicker.SelectedImage.image = GetImageFor(Mat: Mat);
		
		(self.LowerSize, self.UpperSize) = GetSize(Bit: self.SelectedBit, Mat: self.SelectedMat);
		self.SizeDistance.1 = Int(floor((self.UpperSize.Millimeters - self.LowerSize.Millimeters) * 2));
		// Inches
		let sMin = self.LowerSize.Inches, sMax = self.UpperSize.Inches;
		let Min = Fraction(w: sMin.Whole, n: sMin.Numerator * sMax.Denominator, d: sMin.Denominator * sMax.Denominator), Max = Fraction(w: sMax.Whole, n: sMax.Numerator * sMin.Denominator, d: sMax.Denominator * sMin.Denominator);
		var Distance = Fraction(w: Max.Whole - Min.Whole, n: Max.Numerator - Min.Numerator, d: Min.Denominator);
		if (Distance.Numerator < 0) {
			Distance.Numerator += Distance.Denominator;
			let _ = Distance.Whole--;
		}
		
		let div = CGFloat(InchesStep) / CGFloat(Distance.Denominator);
		self.SizeDistance.0 = Distance.Whole * InchesStep + Int(CGFloat(Distance.Numerator) * div);
		
		SetLastSize = false;
		self.SizeSlider.maximumValue = Float(self.IsImperial ? self.SizeDistance.0 : self.SizeDistance.1);
		
		// Keep old size value
		if (self.IsImperial) {
			let _s = self.LastSize.Inches, _a = self.LowerSize.Inches, _b = self.UpperSize.Inches;
			let s = CGFloat(_s.Whole) + (CGFloat(_s.Numerator) / CGFloat(_s.Denominator)),
				a = CGFloat(_a.Whole) + (CGFloat(_a.Numerator) / CGFloat(_a.Denominator)),
				b = CGFloat(_b.Whole) + (CGFloat(_b.Numerator) / CGFloat(_b.Denominator));
			
			if (s <= a) {
				self.SizeSlider.value = 0;
			} else if (s >= b) {
				self.SizeSlider.value = self.SizeSlider.maximumValue;
			} else {
				let sMin = self.LowerSize.Inches, sMax = self.LastSize.Inches;
				let Min = Fraction(w: sMin.Whole, n: sMin.Numerator * sMax.Denominator, d: sMin.Denominator * sMax.Denominator), Max = Fraction(w: sMax.Whole, n: sMax.Numerator * sMin.Denominator, d: sMax.Denominator * sMin.Denominator);
				var Distance = Fraction(w: Max.Whole - Min.Whole, n: Max.Numerator - Min.Numerator, d: Min.Denominator);
				if (Distance.Numerator < 0) {
					Distance.Numerator += Distance.Denominator;
					let _ = Distance.Whole--;
				}
				
				let div = CGFloat(InchesStep) / CGFloat(Distance.Denominator);
				self.SizeSlider.value = Float(Distance.Whole * InchesStep + Int(CGFloat(Distance.Numerator) * div));
			}

		} else {
			let s = self.LastSize.Millimeters, a = self.LowerSize.Millimeters, b = self.UpperSize.Millimeters;
			
			if (s <= a) {
				self.SizeSlider.value = 0;
			} else if (s >= b) {
				self.SizeSlider.value = self.SizeSlider.maximumValue;
			} else {
				self.SizeSlider.value = Float(floor((self.LastSize.Millimeters - self.LowerSize.Millimeters) * 2));
			}
		}
		
		self.SizeValueChanged(self.SizeSlider);
		SetLastSize = true;
		
		if (SetLastMaterial) {
			LastMaterial = Mat;
		}
	}
}

