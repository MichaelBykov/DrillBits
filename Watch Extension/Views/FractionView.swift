//
//  FractionView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/23/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI

struct FractionView: View {
	var Numerator: Int;
	var Denominator: Int;
	
	init (n: Int, d: Int) {
		Numerator = n;
		Denominator = d;
	}
	
    var body: some View {
        VStack {
			Text("\(Numerator)")
			Spacer()
				.frame(height: 0)
			Rectangle()
				.frame(height: 1)
				.padding(.horizontal, -4)
			Spacer()
				.frame(height: 0)
			Text("\(Denominator)")
		}
			.scaledToFit()
    }
}

struct FractionView_Previews: PreviewProvider {
    static var previews: some View {
		FractionView(n: 1, d: 2)
    }
}
