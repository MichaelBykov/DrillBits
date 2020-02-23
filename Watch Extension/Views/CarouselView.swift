//
//  CarouselView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 2/9/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI

struct CarouselView: View {
	/// The control's content
	var Data: [String];
	
	/// The rotation (in degrees) of the carousel (should be between -45 and 45, exclusive)
	@Binding var Rotation: Double;
	/// The currently selected Index of the carousel
	@Binding var Index: Int;
	
	init(rot: Binding<Double>, index: Binding<Int>, data: [String]) {
		Data = data;
		
		_Rotation = rot;
		_Index = index;
	}
	
	/// Get the element at the specified Index;
	private func Get(_ index: Int) -> String { return index < 0 ? " " : index >= Data.count ? " " : Data[index] }
	
	/// Get a clamped rotation
	private func r(_ Offset: Double) -> Double {
		let r = Rotation + Offset;
		return r < -90 ? -90 : r > 90 ? 90 : r
	}
	private var r90: Double { r(90) }
	private var cr90: CGFloat { CGFloat(r(90)) }
	private var r45: Double { r(45) }
	private var cr45: CGFloat { CGFloat(r(45)) }
	private var r: Double { Rotation }
	private var cr: CGFloat { CGFloat(Rotation) }
	private var rn45: Double { r(-45) }
	private var crn45: CGFloat { CGFloat(r(-45)) }
	private var rn90: Double { r(-90) }
	private var crn90: CGFloat { CGFloat(r(-90)) }
	
	private func Scale(_ r: CGFloat) -> CGFloat { return 1.0 - abs(r) / 260 }
	
    var body: some View {
		VStack {
			Text(Get(Index - 2))
				.frame(height: 20)
				.rotation3DEffect(Angle(degrees: r90), axis: (x: 1, y: 0, z: 0))
				.scaleEffect(Scale(cr90))
				.transformEffect(CGAffineTransform(translationX: 0, y: 22 + 3.0 * cr / -45))
			Text(Get(Index - 1))
				.frame(height: 20)
				.rotation3DEffect(Angle(degrees: r45), axis: (x: 1, y: 0, z: 0))
				.scaleEffect(Scale(cr45))
				.transformEffect(CGAffineTransform(translationX: 0, y: 5 + (r < 0 ? 15.0 : 3.0) * cr / -45))
			Text(Get(Index))
				.bold()
				.frame(height: 20)
				.rotation3DEffect(Angle(degrees: r), axis: (x: 1, y: 0, z: 0))
				.scaleEffect(Scale(cr))
				.transformEffect(CGAffineTransform(translationX: 0, y: 15.0 * cr / -45))
			Text(Get(Index + 1))
				.frame(height: 20)
				.rotation3DEffect(Angle(degrees: rn45), axis: (x: 1, y: 0, z: 0))
				.scaleEffect(Scale(crn45))
				.transformEffect(CGAffineTransform(translationX: 0, y: -5 + (r > 0 ? 15.0 : 3.0) * cr / -45))
			Text(Get(Index + 2))
				.frame(height: 20)
				.rotation3DEffect(Angle(degrees: rn90), axis: (x: 1, y: 0, z: 0))
				.scaleEffect(Scale(crn90))
				.transformEffect(CGAffineTransform(translationX: 0, y: -22 + 3.0 * cr / -45))
		}
			.frame(height: 45)
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
		CarouselView(rot: .constant(0), index: .constant(3), data: [ "A", "B", "C", "D", "E", "F", "G", "H" ])
    }
}
