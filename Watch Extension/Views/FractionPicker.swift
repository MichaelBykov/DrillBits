//
//  FractionPicker.swift
//  Watch Extension
//
//  Created by Michael Bykov on 2/9/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI
import DrillBitsDataWatch

struct FractionPicker: View {
	/// The minimum value of the fraction picker
	var Min: Fraction;
	/// The normalized minimum value of the fraction picker
	var nMin: Int;
	/// The maximum value of the fraction picker
	var Max: Fraction;
	
	/// All the possible whole values
	var Wholes: [String] = [];
	var Whole: Int { Min.Whole + wIndex }
	
	/// All the possible fraction values
	var Fracs: [Fraction] = [];
	/// All the possible numerator values
	var Numerators: [String];
	/// All the possible denominator values
	var Denominators: [String];
	
	@Binding var Value: Float;
	
	@State var wIndex: Int;
	@State var wRot: Double = 0;
	@State var wCrown: Float;
	
	@State var fIndex: Int;
	@State var LastFIndex: Int = -1;
	@State var fRot: Double = 0;
	@State var fCrown: Float;
	
	init(value: Binding<Float>, min: Fraction, max: Fraction) {
		func clamp(x: Int, min: Int, max: Int) -> Int { return x <= min ? min : x >= max ? max : x; }
		
		Min = min;
		let nMin = min.Normalize(MaxDenominator: 16);
		self.nMin = nMin;
		Max = max;
		let nMax = max.Normalize(MaxDenominator: 16);
		
		let InitValue = clamp(x: Int(value.wrappedValue), min: nMin, max: nMax);
		
		_Value = value;
		
		
		// Load all data
		
		for i in Min.Whole...Max.Whole {
			Wholes.append("\(i)");
		}
		
		let fMin = nMin;
		let fMax = max.Normalize(MaxDenominator: 16);
		for i in fMin...fMax {
			Fracs.append(Fraction(Normal: i, MaxDenominator: 16))
		}
		
		Numerators = Fracs.map({ f in "\(f.Numerator)" });
		Denominators = Fracs.map({ f in "\(f.Denominator)" });
		
		// Set initial values
		let wIndex = Fraction(Normal: Int(InitValue), MaxDenominator: 16).Whole - min.Whole;
		self._wIndex = State(initialValue: wIndex);
		self._wCrown = State(initialValue: Float(wIndex));
		
		let fIndex = Int(InitValue) - nMin;
		self._fIndex = State(initialValue: fIndex);
		self._fCrown = State(initialValue: Float(fIndex));
	}
	
    var body: some View {
		let bwIndex = Binding<Int>(get: { self.wIndex }, set: { newValue in
			// Set new value
			self.wIndex = newValue;
			
			// Update numerator
			let f = self.Fracs[self.fIndex];
			if (self.Fracs[0].Whole == self.Whole && f.GetFrac() <= self.Fracs[0].GetFrac() &&
				// Check last fraction as well
				(self.LastFIndex == -1 || self.Fracs[self.LastFIndex].GetFrac() <= self.Fracs[0].GetFrac())) {
				if (self.LastFIndex == -1) {
					self.LastFIndex = self.fIndex;
				}
				self.fIndex = 0;
			} else if (self.Fracs.last!.Whole == self.Whole && f.GetFrac() >= self.Fracs.last!.GetFrac() &&
				// Check last fraction as well
				(self.LastFIndex == -1 || self.Fracs[self.LastFIndex].GetFrac() >= self.Fracs.last!.GetFrac())) {
				if (self.LastFIndex == -1) {
					self.LastFIndex = self.fIndex;
				}
				self.fIndex = self.Fracs.count - 1;
			} else if (self.LastFIndex != -1) {
				self.fIndex = self.LastFIndex;
				self.LastFIndex = -1;
			} else {
				self.fIndex = Fraction(w: self.Whole, n: f.Numerator, d: f.Denominator).Normalize(MaxDenominator: 16) - self.nMin;
			}
			self.fCrown = Float(self.fIndex);
			
			// Update output
			self.Value = Float(self.fIndex + self.nMin);
		});
		
		let bfIndex = Binding<Int>(get: { self.fIndex }, set: { newValue in
			self.fIndex = newValue;
			self.LastFIndex = -1;
			self.wIndex = self.Fracs[newValue].Whole - self.Min.Whole;
			self.wCrown = Float(self.wIndex);
			
			// Update output
			self.Value = Float(self.fIndex + self.nMin);
		});
		
		return HStack {
			ContentPicker(index: bwIndex, rotation: $wRot, crown: self.$wCrown, length: self.Wholes.count) {
				CarouselView(rot: self.$wRot, index: self.$wIndex, data: self.Wholes)
			}

			ContentPicker(index: bfIndex, rotation: $fRot, crown: self.$fCrown, length: Fracs.count) {
				FractionView(n: CubeView(rot: self.$fRot, index: self.$fIndex, data: self.Numerators).padding(.bottom, 2), d: Text(self.Denominators[self.fIndex]).padding(.top, 2))
					.frame(width: 26)
			}
		}
    }
}

extension Fraction {
	/// Get the fraction part as a float (whole ignored)
	func GetFrac() -> Float {
		return Float(self.Numerator) / Float(self.Denominator);
	}
}

struct FractionPicker_Previews: PreviewProvider {
    static var previews: some View {
		FractionPicker(value: .constant(0), min: Fraction(w: 0, n: 1, d: 8), max: Fraction(w: 2, n: 1, d: 2))
    }
}
