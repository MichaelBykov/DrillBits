//
//  ItemView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/18/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI

struct ItemView<D>: View where D : View {
	var _Label: String;
	var _Image: UIImage;
	var _Destination: D;
	
	@State var Push: Bool;
	
	@EnvironmentObject var Shared: SharedData;
	
	init(label: String, image: UIImage, destination: D, autoSelect: Bool = false) {
		_Label = label;
		_Image = image;
		_Destination = destination;
		
		_Push = State(initialValue: autoSelect);
	}
	
    var body: some View {
		NavigationLink(destination: _Destination, isActive: self.$Push) {
			HStack {
				GeometryReader { Metrics in
					Image(uiImage: self._Image)
						.resizable()
						.aspectRatio(1, contentMode: .fit)
						.frame(width: Metrics.size.height, height: nil, alignment: .leading)
						.alignmentGuide(.leading, computeValue: { d in d[explicit: .leading]! })
				}.scaledToFit()
				Spacer()
				Text(_Label)
					.multilineTextAlignment(.trailing)
			}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
		}
			.onTapGesture {
				self.Push = true;
			}
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			ItemView(label: "Twist Bit", image: UIImage(named: "Twist Bit")!, destination: DrillBitView())
			ItemView(label: "Twist Bit", image: UIImage(named: "Twist Bit")!, destination: DrillBitView())
				.previewLayout(.fixed(width: 200, height: 200 / 3))
		}
    }
}
