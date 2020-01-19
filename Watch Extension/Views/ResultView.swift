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
	
	init(ForBit: DrillBit, AndMat: Material) {
		Bit = ForBit;
		Mat = AndMat;
	}
	
    var body: some View {
		Text("Hello, World!\nBit: \(ToString(Bit: Bit))\nMat: \(ToString(Mat: Mat))")
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
		ResultView(ForBit: .Twist, AndMat: .Softwood)
    }
}
