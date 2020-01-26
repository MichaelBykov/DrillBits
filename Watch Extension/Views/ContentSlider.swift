//
//  ContentSlider.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/19/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI
import Combine

/// A slider that allows for content to be embedded in it
struct ContentSlider<C>: View where C : View {
	/// The main background color of the control
	private let BackgroundColor = Color(red: 31.0 / 255, green: 31.0 / 255, blue: 31.0 / 255);
	
	/// The control's content
	var Content: () -> C;
	
	/// The actual main value
	@Binding var Value: Float;
	
	/// The minimum value the slider can go to
	var Min: Float;
	/// The maximum value the slider can go to
	var Max: Float;
	
	/// Controls minus button bouncing
	@State private var MinusDown: Bool = false;
	/// Controls plus button bouncing
	@State private var PlusDown: Bool = false;
	
	/// Current crown rotation
	@Binding var Crown: Float;
	/// The last crown rotation (for removing duplicates)
	@Binding var LastCrown: Float;
	/// Controls showing the glow around the control
	@State var Scrolling: Bool = false;
	
	private class Counter { var i: Int = 0; }
	/// For droppping only the very first 4 results
	private var FirstRecieved = Counter();
	
	init (value: Binding<Float>, crown: Binding<Float>, lastCrown: Binding<Float>, min: Int, max: Int, @ViewBuilder content: @escaping () -> C) {
		_Value = value;
		_Crown = crown;
		_LastCrown = lastCrown;
		
		Content = content;
		Min = Float(min);
		Max = Float(max);
	}
	
    var body: some View {
		return HStack {
			GeometryReader { g in
				Button(action: {
					self.Crown -= 1;
					self.LastCrown = self.Crown;
					if (self.Value - 1 != self.Crown) {
						self.Value = self.Crown - 1;
					} else {
						self.Value -= 1;
					}
					
					withAnimation(Animation.linear(duration: 0.1)) {
						self.MinusDown = true;
					}
					
					withAnimation(Animation.linear(duration: 0.1).delay(0.1)) {
						self.MinusDown = false;
					}
				}) {
					ZStack() {
						Rectangle()
							.frame(width: 15, height: 2)
					}
						// This all allows the button to have a larger tap area
						.aspectRatio(1, contentMode: .fit)
						.frame(width: g.size.height, height: g.size.height)
						.background(self.BackgroundColor)
				}
					.aspectRatio(1, contentMode: .fit)
					.buttonStyle(PlainButtonStyle())
					.scaleEffect(self.MinusDown ? 0.8 : 1)
					.frame(width: g.size.height, height: g.size.height)
					.disabled(self.Value <= self.Min)
			}
				.aspectRatio(1, contentMode: .fit)
			
			Spacer()
				.frame(width: 0)
			
			Content()
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
			
			Spacer()
				.frame(width: 0);
			
			GeometryReader { g in
				Button(action: {
					self.Crown += 1;
					self.LastCrown = self.Crown;
					if (self.Value + 1 != self.Crown) {
						self.Value = self.Crown + 1;
					} else {
						self.Value += 1;
					}
					
					withAnimation(Animation.linear(duration: 0.1)) {
						self.PlusDown = true;
					}
					
					withAnimation(Animation.linear(duration: 0.1).delay(0.1)) {
						self.PlusDown = false;
					}
				}) {
					ZStack {
						Rectangle()
							.frame(width: 15, height: 2)
						VStack() {
							Rectangle()
								.frame(width: 2, height: 6.5)
							Spacer()
								.frame(height: 2)
							Rectangle()
								.frame(width: 2, height: 6.5)
						}
					}
						// This all allows the button to have a larger tap area
						.aspectRatio(1, contentMode: .fit)
						.frame(width: g.size.height, height: g.size.height)
						.background(self.BackgroundColor)
				}
					.aspectRatio(1, contentMode: .fit)
					.buttonStyle(PlainButtonStyle())
					.scaleEffect(self.PlusDown ? 0.8 : 1)
					.frame(width: g.size.height, height: g.size.height)
					.disabled(self.Value >= self.Max)
			}
				.aspectRatio(1, contentMode: .fit)
		}
			.overlay(
				// Glow when crown is rotating to show focus / what's being changed
				RoundedRectangle(cornerRadius: 8)
					.stroke(Scrolling ? Color(red: 100.0 / 255, green: 218.0 / 255, blue: 124.0 / 255) : Color.clear, lineWidth: 4)
			)
			.frame(height: 42)
			.background(BackgroundColor)
			.cornerRadius(8)
			// Handle crown rotation
			.focusable()
			.digitalCrownRotation($Crown, from: Float(self.Min), through: Float(self.Max), by: 1, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
			.onReceive(Just(Crown).removeDuplicates()) { out in
				// First 4 results are from initialization, we don't want to touch anything during that time
				if (self.FirstRecieved.i < 4) {
					self.FirstRecieved.i += 1;
					return;
				}
				
				// Simply setting `Value` on crown rotation doesn't work, it needs its own state and listener
				self.Value = round(out);
				
				// Ignore initialization and duplicates for border glow
				if (out > 0 && self.LastCrown != out) {
					self.LastCrown = out;
					
					withAnimation(Animation.easeInOut(duration: 0.2)) {
						self.Scrolling = true;
					}
					
					withAnimation(Animation.easeInOut(duration: 0.5).delay(0.5)) {
						self.Scrolling = false;
					}
				}
			}
	}
}

struct ContentSlider_Previews: PreviewProvider {
    static var previews: some View {
		ContentSlider(value: .constant(0), crown: .constant(0), lastCrown: .constant(0), min: 0, max: 10) { Text("Hello World!"); }
    }
}
