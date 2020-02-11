//
//  ContentPicker.swift
//  Watch Extension
//
//  Created by Michael Bykov on 2/5/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI
import Combine

struct ContentPicker<C>: View where C : View {
	/// The main background color of the control
	private let BackgroundColor = Color(red: 31.0 / 255, green: 31.0 / 255, blue: 31.0 / 255);

	/// The control's content
	var Content: () -> C;
	
	/// The actual main value
	@Binding var Index: Int;
	/// The last value
	@State var LastIndex: Int;
	
	/// The maximum value the picker can go to
	var Max: Float;
	
	/// Current crown rotation
	@State var Crown: Float;
	/// Used to show a glow around the focused picker
	@State var Focused: Bool = false;
	
	/// Current drag rotation
	@Binding var Rotation: Double;
	
	
	
	init(index: Binding<Int>, rotation: Binding<Double>, length: Int, @ViewBuilder content: @escaping () -> C) {
		_Index = index;
		_LastIndex = State(initialValue: index.wrappedValue);
		_Rotation = rotation;
		_Crown = State(initialValue: Float(index.wrappedValue));
		
		Content = content;
		Max = Float(length - 1);
	}
	
    var body: some View {
		VStack {
			Content()
		}
			.frame(height: 56 + 16)
			.frame(minWidth: 0, maxWidth: .infinity)
			.overlay(
				// Glow when the picker is focused
				RoundedRectangle(cornerRadius: 8)
					.stroke(Focused ? Color(red: 100.0 / 255, green: 218.0 / 255, blue: 124.0 / 255) : Color.clear, lineWidth: 4)
			)
			.background(BackgroundColor)
			.cornerRadius(8)
			// Handle crown rotation
			.focusable { f in
				withAnimation(.easeOut(duration: 0.15)) {
					self.Focused = f;
				}
			}
			.digitalCrownRotation($Crown, from: 0, through: Max, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
			.onReceive(Just(Crown).removeDuplicates()) { out in
				let Last = self.Index;
				self.Index = Int(round(out));
				
				// Throw away duplicates
				if (Last == self.Index) {
					return;
				}
				
				// Update the drag too
				self.LastIndex = self.Index;
				
				// Animate the picker going to the next value
				self.Rotation = Last > self.Index ? 45 : -45;
				let sign: Double = self.Rotation < 0 ? -1 : 1;
				var rot = abs(self.Rotation);
				// We need to have a custom animation loop because the SwiftUI standard `withAnimation` doesn't work for the custom carousel view
				Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
					// If user interaction occours or the animation is at its end, stop the loop
					if (self.Rotation != sign * rot || rot * 0.7 < 1) {
						self.Rotation = 0;
						timer.invalidate();
						return;
					}
					rot *= 0.7;
					self.Rotation = sign * rot;
				}
			}
			// Handle drag rotation
			.gesture(DragGesture()
				.onChanged { value in
					/// The drag rotation
					let rot = -Double(value.translation.height);
					
					let i = Float(self.LastIndex + Int(round(rot / 45)));
					self.Index = Int(i <= 0 ? 0 : i >= self.Max ? self.Max : i);
					
					// Update the crown too
					self.Crown = Float(self.Index);
					
					var mod = rot.mod(45);
					// Account for the offset created by changing index
					if (mod >= 22.5) {
						mod -= 45;
					} else if (mod <= -22.5) {
						mod += 45;
					}
					
					if ((i > 0 || (i == 0 && mod >= 0)) && (i < self.Max || (i == self.Max && mod <= 0))) {
						self.Rotation = mod;
					} else {
						self.Rotation = ((rot + Double(self.LastIndex * 45)) - Double(self.Index * 45)) * 0.3;
					}
				}
				.onEnded { _ in
					// Animate the picker bouncing back
					let sign: Double = self.Rotation < 0 ? -1 : 1;
					var rot = abs(self.Rotation);
					// We need to have a custom animation loop because the SwiftUI standard `withAnimation` doesn't work for the custom carousel view
					Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
						// If user interaction occours or the animation is at its end, stop the loop
						if (self.Rotation != sign * rot || rot * 0.7 < 1) {
							self.Rotation = 0;
							timer.invalidate();
							return;
						}
						rot *= 0.7;
						self.Rotation = sign * rot;
					}
					
					// Update the selected index
					self.LastIndex = self.Index;
				})
    }
}

extension Double {
	public func mod(_ x: Double) -> Double {
		let sign: Double = self < 0 ? -1 : 1;
		let _mod = abs(self).remainder(dividingBy: x);
		return sign * (_mod > 0 ? _mod : x + _mod)
	}
}

struct ContentPicker_Previews: PreviewProvider {
    static var previews: some View {
		ContentPicker(index: .constant(0), rotation: .constant(0), length: 10) {
			Text("Hello World")
		}
    }
}
