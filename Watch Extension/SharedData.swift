//
//  SharedData.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/31/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI
import DrillBitsDataWatch

public class SharedData: ObservableObject {
	private var _LastBit: DrillBit = .Twist;
	/// The last selected drill bit
	public var LastBit: DrillBit { get { return _LastBit } set { Defaults.Bit = newValue; _LastBit = newValue } }
	
	private var _LastMat: Material = .Hardwood;
	/// The last selected material
	public var LastMat: Material { get { return _LastMat } set { Defaults.Mat = newValue; _LastMat = newValue } }
	
	
	private var _CurrentView: Int = 0;
	/// Declares what the last viewed view was
	/// # Valid Values:
	///
	/// 0: `DrillBitView`
	///
	/// 1: `MaterialView`
	///
	/// 2: `ResultView`
	public var CurrentView: Int {
		get { return _CurrentView; }
		set { _CurrentView = newValue; Defaults.CurrentView = newValue; }
	}
	
	/// The number of loaded views, for use in selecting the last viewwed view upon startup
	public var LoadedViews: Int = 0;
	
	
	// If you put semicolons at the end of this get/set the swift compiler complains
	public var Imperial: Bool { get { return self.Size.IsImperial! } set { Defaults.Imperial = newValue; return self.Size.IsImperial = newValue } }
	@Published public var Slider: Float = 0;
	@Published public var Size: DrillBitsDataWatch.Unit = DrillBitsDataWatch.Unit(Inches: Fraction(w: 0, n: 0, d: 1));
	
	init() {
		// Load all values
		if (Defaults.Start) {
			_LastBit = Defaults.Bit;
			_LastMat = Defaults.Mat;
			_CurrentView = Defaults.CurrentView;
			
			Imperial = Defaults.Imperial;
			Slider = Defaults.Size;
			if (Imperial) {
				Size.Inches = Fraction(Normal: Int(Slider), MaxDenominator: 16);
			} else {
				Size.Millimeters = CGFloat(Slider * 2);
			}
		} else {
			// Setup initial values
			Defaults.Bit = .Twist;
			Defaults.Mat = .Softwood;
			Defaults.CurrentView = 0;
			
			Defaults.Imperial = true;
			Defaults.Size = 0;
		}
	}
}
