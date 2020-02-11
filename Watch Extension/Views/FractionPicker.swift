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
	/// The maximum value of the fraction picker
	var Max: Fraction;
	
	@State var wIndex: Int = 0;
	@State var wRot: Double = 0;
	
	@State var Selected = 0;
	
	init(min: Fraction, max: Fraction) {
		Min = min;
		Max = max;
	}
	
    var body: some View {
		HStack {
			ContentPicker(index: $wIndex, rotation: $wRot, length: 3) {
				CarouselView(rot: self.$wRot, index: self.$wIndex, data: [ "A", "B", "C" ])
			}
			
			Picker(selection: $Selected, label: Text("")) {
				Text("A")
				Text("B")
				Text("C")
			}
		}
    }
}

struct FractionPicker_Previews: PreviewProvider {
    static var previews: some View {
		FractionPicker(min: Fraction(w: 0, n: 1, d: 8), max: Fraction(w: 2, n: 1, d: 2))
    }
}
