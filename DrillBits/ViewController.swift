//
//  ViewController.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/10/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

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
	public var Size: Unit = Unit(Inches: Fraction(w: 0));
	public var UpperSize: Unit = Unit(Inches: Fraction(w: 0)), LowerSize: Unit = Unit(Inches: Fraction(w: 0));
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
		ScrollView.RootCancels = [ DrillBitPicker.SelectionView, MaterialPicker.SelectionView, SizeSlider ];
		
		// Add data for pickers
		var BitData: [(UIImage, Int, String, String)] = [ ];
		for i in 0...10 {
			let Bit = DrillBit(rawValue: i)!;
			BitData.append((GetImageFor(Bit: Bit), i, ToString(Bit: Bit), GetDescFor(Bit: Bit)));
		}
		
		DrillBitPicker.Data = BitData;
		
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
			SizeWhole.text = "\(min.Whole == 0 ? "" : "\(min.Whole)")";
			SizeNumerator.text = "\(min.Numerator)";
			SizeDenominator.text = "\(min.Denominator)";
		} else {
			let s = LowerSize.Millimeters + (CGFloat(SizeSlider.value) / 2);
			Size.Millimeters = s;
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
		
		self.SizeSlider.maximumValue = Float(self.IsImperial ? self.SizeDistance.0 : self.SizeDistance.1);
		self.SizeSlider.value = self.SizeSlider.maximumValue * 0.2;
		self.SizeValueChanged(self.SizeSlider);
		
		if (SetLastMaterial) {
			LastMaterial = Mat;
		}
	}
}

