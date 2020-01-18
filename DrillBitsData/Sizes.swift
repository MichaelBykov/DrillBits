//
//  Speeds.swift
//  DrillBits
//
//  Created by Michael Bykov on 8/4/19.
//  Copyright © 2020 Lepario. All rights reserved.
//

/// Get the upper and lower bound of sizes for the given drill bit
/// - Parameter Bit:
public func GetSize(Bit: DrillBit, Mat: Material) -> (Unit, Unit) {
	let lookup: [DrillBit: [Material: (Unit, Unit)]] = [
		.Twist: [
			.Softwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 16), Millimeters: 1), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Hardwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 16), Millimeters: 1), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Acrylic: (Unit(Inches: Fraction(w: 0, n: 1, d: 16), Millimeters: 1), Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 15)),
			.Brass: (Unit(Inches: Fraction(w: 0, n: 1, d: 16), Millimeters: 1), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Aluminum: (Unit(Inches: Fraction(w: 0, n: 1, d: 16), Millimeters: 1), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Steel: (Unit(Inches: Fraction(w: 0, n: 1, d: 16), Millimeters: 1), Unit(Inches: Fraction(w: 1), Millimeters: 25))
		],
		.BulletPilotPoint: [
			.Softwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13)),
			.Hardwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13)),
			.Acrylic: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13)),
			.Brass: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13)),
			.Aluminum: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13)),
			.Steel: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13))
		],
		.BradPoint: [
			.Softwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Hardwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Acrylic: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 1), Millimeters: 25))
		],
		.Forstner: [
			.Softwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6), Unit(Inches: Fraction(w: 2), Millimeters: 50)),
			.Hardwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6), Unit(Inches: Fraction(w: 2), Millimeters: 50)),
			.Acrylic: (Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13), Unit(Inches: Fraction(w: 1, n: 1, d: 4), Millimeters: 32))
		],
		.GlassAndTile: [
			.GlassAndTile: (Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13))
		],
		.HoleSaw: [
			.Softwood: (Unit(Inches: Fraction(w: 1), Millimeters: 25), Unit(Inches: Fraction(w: 2, n: 1, d: 2), Millimeters: 64)),
			.Hardwood: (Unit(Inches: Fraction(w: 1), Millimeters: 25), Unit(Inches: Fraction(w: 2, n: 1, d: 2), Millimeters: 64)),
			.Brass: (Unit(Inches: Fraction(w: 1), Millimeters: 25), Unit(Inches: Fraction(w: 2), Millimeters: 50)),
			.Aluminum: (Unit(Inches: Fraction(w: 1), Millimeters: 25), Unit(Inches: Fraction(w: 2, n: 1, d: 2), Millimeters: 64))
		],
		.MultiSpur: [
			.Softwood: (Unit(Inches: Fraction(w: 2, n: 1, d: 8), Millimeters: 54), Unit(Inches: Fraction(w: 4), Millimeters: 100)),
			.Hardwood: (Unit(Inches: Fraction(w: 2, n: 1, d: 8), Millimeters: 54), Unit(Inches: Fraction(w: 4), Millimeters: 100))
		],
		.Spade: [
			.Softwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6), Unit(Inches: Fraction(w: 1, n: 1, d: 2), Millimeters: 38)),
			.Hardwood: (Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6), Unit(Inches: Fraction(w: 1, n: 1, d: 2), Millimeters: 38))
		],
		.SpadeWithSpurs: [
			.Softwood: (Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 9), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Hardwood: (Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 9), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Acrylic: (Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 9), Unit(Inches: Fraction(w: 1), Millimeters: 25))
		],
		.Powerbore: [
			.Softwood: (Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 9), Unit(Inches: Fraction(w: 1), Millimeters: 25)),
			.Hardwood: (Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 9), Unit(Inches: Fraction(w: 1), Millimeters: 25))
		],
		.CircleCutter: [
			.Softwood: (Unit(Inches: Fraction(w: 1, n: 1, d: 2), Millimeters: 38), Unit(Inches: Fraction(w: 6), Millimeters: 150)),
			.Hardwood: (Unit(Inches: Fraction(w: 1, n: 1, d: 2), Millimeters: 38), Unit(Inches: Fraction(w: 6), Millimeters: 150)),
			.Acrylic: (Unit(Inches: Fraction(w: 1, n: 1, d: 2), Millimeters: 38), Unit(Inches: Fraction(w: 6), Millimeters: 150))
		]
	];
	
	return lookup[Bit]![Mat]!;
}
