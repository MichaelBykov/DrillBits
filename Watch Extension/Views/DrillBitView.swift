//
//  DrillBitView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/17/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI
import DrillBitsDataWatch

struct DrillBitView: View {
	let Bits = LoadDrillBitData();
	
    var body: some View {
		VStack {
			List(Bits) { Bit in
				ItemView(label: Bit.Name, image: Bit.Image, destination: MaterialView(For: Bit.Bit))
					.aspectRatio(3, contentMode: .fit)
			}
		}.navigationBarTitle("Drill Bits")
    }
}

struct DrillBitView_Previews: PreviewProvider {
    static var previews: some View {
        DrillBitView()
    }
}
