//
//  Unit.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/26/19.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

/// A struct for describing units
public struct Unit {
	/// Is the unit system based on inches (Imperial / US Customary)
	public var IsImperial: Bool?;
	
	/// The inches part of the unit if the unit system is Imperial / US Customary
	public var Inches: Fraction = Fraction(w: 0, n: 0, d: 64);
	/// The millimeters part of the unit if the unit system is Metric
	public var Millimeters: CGFloat = 0;
	
	public init(Inches: Fraction) {
		self.IsImperial = true;
		self.Inches = Inches;
	}
	
	public init(Millimeters: CGFloat) {
		self.IsImperial = false;
		self.Millimeters = Millimeters;
	}
	
	public init(Inches: Fraction, Millimeters: CGFloat) {
		self.IsImperial = nil;
		self.Inches = Inches;
		self.Millimeters = Millimeters;
		
	}
	
	/// Compare 2 units
	/// - Parameter to: The unit to comapre to
	/// - Parameter Comparison: How to compare the two units
	/// - Returns: Which side was greater or that they are equal
	public func Compare(to: Unit, Comparison: ComparisonResult) -> Bool {
		if (IsImperial!) {
			return Inches.Compare(to: to.Inches, Comparison: Comparison);
		} else {
			return Millimeters > to.Millimeters ? Comparison == .LeftGreater || Comparison == .LeftGreaterEqual :
				   Millimeters < to.Millimeters ? Comparison == .RightGreater || Comparison == .RightGreaterEqual :
												  Comparison == .LeftGreaterEqual || Comparison == .Equal || Comparison == .RightGreaterEqual;
		}
	}
}

// Self explanatory
public enum ComparisonResult {
	case LeftGreater
	case LeftGreaterEqual
	case Equal
	case RightGreater
	case RightGreaterEqual
}

public struct Fraction {
	public var Whole: Int;
	public var Numerator: Int;
	public var Denominator: Int;
	
	public enum FractionErrors: Error {
		case DenominatorZero
	}
	
	/// Initialize a new fraction
	public init(w: Int) {
		Whole = w;
		Numerator = 0;
		Denominator = 1;
	}
	
	/// Initialize a new fraction
	public init(w: Int, n: Int, d: Int) {
		Whole = w;
		Numerator = n;
		Denominator = d;
	}
	
	/// Compare 2 fractions
	/// - Parameter to: The fraction to comapre to
	/// - Parameter Comparison: How to compare the two fractions
	/// - Returns: Which side was greater or that they are equal
	public func Compare(to: Fraction, Comparison: ComparisonResult) -> Bool {
		if (Whole > to.Whole)
		{ return Comparison == .LeftGreater || Comparison == .LeftGreaterEqual; }
		
		if (Whole < to.Whole)
		{ return Comparison == .RightGreater || Comparison == .RightGreaterEqual; }
		
		let Size: CGFloat = CGFloat(Numerator) / CGFloat(Denominator), toSize = CGFloat(to.Numerator) / CGFloat(to.Denominator);
		
		if (Size > toSize)
		{ return Comparison == .LeftGreater || Comparison == .LeftGreaterEqual; }
		
		if (Size < toSize)
		{ return Comparison == .RightGreater || Comparison == .RightGreaterEqual; }
		
		return Comparison == .LeftGreaterEqual || Comparison == .Equal || Comparison == .RightGreaterEqual;
	}
}
