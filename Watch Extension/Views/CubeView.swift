//
//  CubeView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 2/11/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI

struct CubeView: View {
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
		let r = (Rotation + Offset) * 2;
		return r <= -90 ? -90 : r >= 90 ? 90 : r
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
			Text(Get(Index - 1))
				.frame(height: 20)
				.rotation3DEffect(Angle(degrees: r45), axis: (x: 1, y: 0, z: 0))
				.scaleEffect(Scale(cr90))
				.transformEffect(CGAffineTransform(translationX: 0, y: 12 + 4.5 * cr / -45))
			Text(Get(Index))
				.bold()
				.frame(height: 20)
				.rotation3DEffect(Angle(degrees: r), axis: (x: 1, y: 0, z: 0))
				.scaleEffect(Scale(cr))
				.transformEffect(CGAffineTransform(translationX: 0, y: 9.0 * cr / -45))
			Text(Get(Index + 1))
				.frame(height: 20)
				.rotation3DEffect(Angle(degrees: rn45), axis: (x: 1, y: 0, z: 0))
				.scaleEffect(Scale(cr90))
				.transformEffect(CGAffineTransform(translationX: 0, y: -12 + 4.5 * cr / -45))
		}
			.frame(height: 27)
    }
}

struct CubeView_Previews: PreviewProvider {
	
    static var previews: some View {
		let Data = [ "A", "B", "C", "D", "E", "F", "G", "H" ];
		
		return HStack {
			CubeView(rot: .constant(0), index: .constant(3), data: Data)
			CubeView(rot: .constant(90), index: .constant(3), data: Data)
			
			CubeView(rot: .constant(45), index: .constant(3), data: Data)
			CubeView(rot: .constant(-45), index: .constant(4), data: Data)
		}
    }
}
