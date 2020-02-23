//
//  UnitSelectView.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/19/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import SwiftUI

struct UnitSelector: View {
	@Binding var Imperial: Bool;
	
	/// The animated `is imperial` value
	@State private var AnimImperial = true;
	/// The non-animated `is imperial` value
	@State private var NoAnimImperial = true;
	
	init(IsImperial: Binding<Bool>) {
		_Imperial = IsImperial;
	}
	
    var body: some View {
        ZStack {
			// The indicator container
			HStack() {
				if (!AnimImperial) {
					Spacer()
				}
				
				// The indicator of what is selected
				Button("") { }
					.frame(width: 70, height: 45)
					.disabled(true)
				
				if (AnimImperial) {
					Spacer()
				}
			}
				.frame(width: 140)
			
			// The actual button container
			HStack {
				// Inches button
				ZStack {
					if (!AnimImperial) {
					Button(action: {
						self.Imperial = true;
						self.NoAnimImperial = true
						withAnimation(.easeOut(duration: 0.15)) {
							self.AnimImperial = true;
						}
					}) { Text("in") }
						.frame(width: 70, height: 45)
						.buttonStyle(PlainButtonStyle())
					} else {
						Text("in")
							.fontWeight(.semibold)
							.frame(width: 70, height: 45)
					}
				}
				
				Spacer()
					.frame(width: 0)
				
				// Millimeter button
				ZStack {
					if (AnimImperial) {
						Button(action: {
							self.Imperial = false;
							self.NoAnimImperial = false
							withAnimation(.easeOut(duration: 0.15)) {
								self.AnimImperial = false;
							}
						}) { Text("mm") }
							.frame(width: 70, height: 45)
							.buttonStyle(PlainButtonStyle())
					} else {
						Text("mm")
							.fontWeight(.semibold)
							.frame(width: 70, height: 45)
					}
				}
			}
		}
			.onAppear {
				// Set initial values
				self.AnimImperial = self.Imperial;
				self.NoAnimImperial = self.Imperial;
			}
    }
}

struct UnitSelector_Previews: PreviewProvider {
    static var previews: some View {
		UnitSelector(IsImperial: Binding(get: { false }, set: { _ in }))
    }
}
