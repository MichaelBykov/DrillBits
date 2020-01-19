//
//  MaterialView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/18/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI
import DrillBitsDataWatch

struct MaterialView: View {
	var Bit: DrillBit;
	var Mats: [MaterialData];
	
	init(For: DrillBit) {
		Bit = For;
		Mats = LoadMaterialData(For: For);
	}
	
    var body: some View {
		List(Mats) { Mat in
			NavigationLink(destination: ResultView(ForBit: self.Bit, AndMat: Mat.Mat)) {
				HStack {
					VStack {
						Image(Mat.Name)
						Text(Mat.Name)
					}
					Text(">")
				}
			}
		}
    }
}

struct MaterialView_Previews: PreviewProvider {
    static var previews: some View {
		MaterialView(For: .Twist)
    }
}
