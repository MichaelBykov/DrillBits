//
//  ResultView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/18/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI
import DrillBitsDataWatch

struct ResultView: View {
	var Bit: DrillBit;
	var Mat: Material;
	let LowerSize: DrillBitsDataWatch.Unit, UpperSize: DrillBitsDataWatch.Unit;
	@EnvironmentObject var Shared: SharedData;
	
	init(ForBit: DrillBit, AndMat: Material) {
		Bit = ForBit;
		Mat = AndMat;
		(LowerSize, UpperSize) = GetSize(Bit: Bit, Mat: Mat);
	}
	
	/// Update stored size values (state)
	func UpdateSize() {
		if (Shared.Imperial) {
			Shared.Size.Inches = Fraction(Normal: Int(self.Shared.Slider), MaxDenominator: 16);
		} else {
			Shared.Size.Millimeters = CGFloat(round(self.Shared.Slider) / 2);
		}
	}
	
    var body: some View {
		let MinValue: Float = LowerSize.Normalize(Imperial: Shared.Imperial);
		let MaxValue: Float = UpperSize.Normalize(Imperial: Shared.Imperial);
		
		// Create custom binding for updating values
		let SizeBinding = Binding(get: { return self.Shared.Slider; }, set: { newValue in
			if (newValue == 0 || self.Shared.Slider == round(newValue)) {
				// Discard, useless value
				return;
			}
			
			self.Shared.Slider = round(newValue);
			self.UpdateSize();
			
			// Save the size value
			Defaults.Size = round(newValue);
		});
		
		return VStack {
			// SwiftUI doesn't account for the navigation bar
			Spacer()
				.frame(height: 10)
			
			VStack() {
				Text("Drill Bit Size")
					.opacity(0.85)
				
				Spacer()
				
				if (self.Shared.Imperial) {
					HStack {
						FractionPicker(value: SizeBinding, min: LowerSize.Inches, max: UpperSize.Inches)
						
						Text("in")
							.padding(.horizontal)
					}
				} else {
					ContentSlider(value: SizeBinding, min: Int(MinValue), max: Int(MaxValue)) {
						Text(self.Shared.Size.Millimeters.description + " mm")
					}
				}
				
				Spacer()
				
				Image("Chevron Apple Watch")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(height: 30)
				
				Spacer()
					.frame(height: -20)
				
				Spacer()
				
				HStack(alignment: .firstTextBaseline) {
					Text("\(GetSpeed(Bit: self.Bit, Mat: self.Mat, Size: self.Shared.Size))")
						.font(.system(.title))
					Spacer()
						.frame(width: 2)
					Text("RPM")
						.font(.system(size: 12, weight: .semibold, design: .default))
				}
			}
		}
			.onAppear {
				// Check if we need to set an inital value
				let val: Float;
				if (self.Shared.Slider == 0) {
					let Initial = (MaxValue - MinValue) * 0.5;
					self.Shared.Slider = Initial;
					val = Initial;
				} else {
					let s = self.Shared.Slider;
					val = s > MaxValue ? MaxValue : s < MinValue ? MinValue : s;
				}

				self.Shared.Slider = val;
				self.UpdateSize();
				
				self.Shared.CurrentView = 2;
				self.Shared.LoadedViews = 2;
				self.Shared.LastMat = self.Mat;
			}
			.navigationBarTitle(ToString(Mat: Mat))
			.contextMenu {
				// Unit system switcher
				Button(action: {
					// Toggle system
					self.Shared.Imperial.toggle();
					
					// Update slider too
					let val: Float = (self.Shared.Slider - MinValue) / (MaxValue - MinValue);
					
					let _MinValue: Float = self.LowerSize.Normalize(Imperial: self.Shared.Imperial);
					let _MaxValue: Float = self.UpperSize.Normalize(Imperial: self.Shared.Imperial);
					
					self.Shared.Slider = round((_MaxValue - _MinValue) * val + _MinValue);
					self.UpdateSize();
				}) {
					VStack {
						Image(self.Shared.Imperial ? "Inches" : "Millimeters")
						Text("Units")
					}
				}
			}
    }
}

#if DEBUG
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
		ResultView(ForBit: .Twist, AndMat: .Softwood)
			.environmentObject(SharedData())
    }
}
#endif
