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
	@EnvironmentObject var Shared: SharedData;
	
	let Bits = LoadDrillBitData();
	
    var body: some View {
		let autoSelect: Bool;
		if (Shared.LoadedViews == 0 && Shared.CurrentView > 0) {
			autoSelect = true;
		} else {
			autoSelect = false;
		}
		
		return VStack {
			List(Bits) { Bit in
				ItemView(label: Bit.Name, image: Bit.Image, destination: MaterialView(For: Bit.Bit), autoSelect: autoSelect ? Bit.Bit == self.Shared.LastBit : false)
					.aspectRatio(3, contentMode: .fit)
			}
		}.navigationBarTitle("Drill Bits")
			.onAppear {
				if (self.Shared.LoadedViews == self.Shared.CurrentView) {
					self.Shared.CurrentView = 0;
					self.Shared.LoadedViews = 0;
				} else {
				   self.Shared.LoadedViews += 1;
			   }
			}
    }
}

#if DEBUG
struct DrillBitView_Previews: PreviewProvider {
    static var previews: some View {
        DrillBitView()
			.environmentObject(SharedData())
    }
}
#endif
