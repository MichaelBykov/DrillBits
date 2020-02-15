//
//  FractionView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/23/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI

struct FractionView<N, D>: View where N: View, D: View {
	var Numerator: N;
	var Denominator: D;
	
	init (n: N, d: D) {
		Numerator = n;
		Denominator = d;
	}
	
    var body: some View {
        VStack {
			Numerator
			Spacer()
				.frame(height: 0)
			Rectangle()
				.frame(height: 1)
				.padding(.horizontal, -4)
			Spacer()
				.frame(height: 0)
			Denominator
		}
			.scaledToFit()
    }
}

struct FractionView_Previews: PreviewProvider {
    static var previews: some View {
		FractionView(n: Text("1"), d: Text("2"))
    }
}
