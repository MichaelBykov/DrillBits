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
	
	/// Get the normalized value for the unit
	/// - Parameter Imperial: Should inches or millimeters be used? (If nil then `IsImperial` or `true` will be used)
	/// - Returns: The normalized unit
	public func Normalize(Imperial: Bool? = nil) -> Float {
		let imp = Imperial == nil ? (IsImperial == nil ? true : IsImperial!) : Imperial!;
		return imp ? Float(Inches.Normalize(MaxDenominator: 16)) : Float(Millimeters * 2);
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
	
	/// Initialize a new fraction
	/// - Parameter MaxDenominator: The maximum value a denominator can be (should be a power of 2)
	public init(Normal: Int, MaxDenominator: Int) {
		Whole = Int(floor(Float(Normal) / Float(MaxDenominator)));
		Numerator = Normal - (Whole * MaxDenominator);
		Denominator = MaxDenominator;
		while (Numerator != 0 && Numerator % 2 == 0) {
			Numerator /= 2;
			Denominator /= 2;
		}
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
	
	
	
	/// Convert the fraction into a number single number (whole * 16 + numerator)
	/// - Parameter MaxDenominator: The maximum value a denominator can be (should be a power of 2)
	public func Normalize(MaxDenominator: Int) -> Int {
		return (Whole * MaxDenominator) + (Numerator * MaxDenominator / Denominator);
	}
	
	/// Convert the fraction into a CGFloat
	public func ToCGFloat() -> CGFloat {
		return CGFloat(Whole) + (CGFloat(Numerator) / CGFloat(Denominator));
	}
	
	/// Convert the fraction into a float
	public func ToFloat() -> Float {
		return Float(Whole) + (Float(Numerator) / Float(Denominator));
	}
}
