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
				NavigationLink(destination: MaterialView(For: Bit.Bit)) {
					HStack {
						VStack {
							Image(Bit.Name);
							Text(Bit.Name)
						}
						Text(">")
					}
				}
			}
		}
    }
}

struct DrillBitView_Previews: PreviewProvider {
    static var previews: some View {
        DrillBitView()
    }
}
