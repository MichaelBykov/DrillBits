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
	@EnvironmentObject var Shared: SharedData;
	
	var Bit: DrillBit;
	var Mats: [MaterialData];
	
	init(For: DrillBit) {
		Bit = For;
		Mats = LoadMaterialData(For: For);
	}
	
    var body: some View {
		let autoSelect: Bool;
		if (Shared.LoadedViews == 1 && Shared.CurrentView > 1) {
			autoSelect = true;
		} else {
			autoSelect = false;
		}
		
		return List(Mats) { Mat in
			ItemView(label: Mat.Name, image: Mat.Image, destination: ResultView(ForBit: self.Bit, AndMat: Mat.Mat), autoSelect: autoSelect ? Mat.Mat == self.Shared.LastMat : false)
				.aspectRatio(3, contentMode: .fit)
		}.navigationBarTitle(ToString(Bit: Bit))
			.onAppear {
				if (self.Shared.LoadedViews == self.Shared.CurrentView) {
					self.Shared.CurrentView = 1;
					self.Shared.LoadedViews = 1;
					self.Shared.LastBit = self.Bit;
				} else {
					self.Shared.LoadedViews += 1;
				}
			}
    }
}

#if DEBUG
struct MaterialView_Previews: PreviewProvider {
    static var previews: some View {
		MaterialView(For: .Twist)
			.environmentObject(SharedData())
    }
}
#endif
