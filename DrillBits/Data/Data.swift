//
//  Data.swift
//  DrillBits
//
//  Created by Michael Bykov on 8/4/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

func GetSpeed(Bit: DrillBit, Mat: Material, Size: Unit) -> Int {
	switch Bit {
	case .Twist:
		switch Mat {
		case .Softwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 3000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 15), Comparison: .LeftGreaterEqual)) {
				return 1500;
			} else {
				return 750;
			}
		case .Hardwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 3000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 1500;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 15), Comparison: .LeftGreaterEqual)) {
				return 750;
			} else {
				return 500;
			}
		case .Acrylic:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 2500;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 2000;
			} else {
				return 1500;
			}
		case .Brass:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 3000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 1200;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 15), Comparison: .LeftGreaterEqual)) {
				return 750;
			} else {
				return 400;
			}
		case .Aluminum:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 3000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 2500;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 15), Comparison: .LeftGreaterEqual)) {
				return 1500;
			} else {
				return 1000;
			}
		case .Steel:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 3000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 1000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 15), Comparison: .LeftGreaterEqual)) {
				return 600;
			} else {
				return 350;
			}
		default:
			return -1;
		}
	case .BulletPilotPoint:
		switch Mat {
		case .Softwood:
			return 3000;
		case .Hardwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 3000;
			} else {
				return 1500;
			}
		case .Acrylic:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 3000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 2400;
			} else {
				return 1600;
			}
		case .Brass:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 2000;
			} else {
				return 1500;
			}
		case .Aluminum:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 1500;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 1000;
			} else {
				return 750;
			}
		case .Steel:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 3000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 2000;
			} else {
				return 1200;
			}
		default:
			return -1;
		}
	case .BradPoint:
		switch Mat {
		case .Softwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 15), Comparison: .LeftGreaterEqual)) {
				return 1800;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 4), Millimeters: 19), Comparison: .LeftGreaterEqual)) {
				return 1400;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 7, d: 8), Millimeters: 22), Comparison: .LeftGreaterEqual)) {
				return 1200;
			} else {
				return 1000;
			}
		case .Hardwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Comparison: .LeftGreaterEqual)) {
				return 1200;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6), Comparison: .LeftGreaterEqual)) {
				return 1000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 12), Comparison: .LeftGreaterEqual)) {
				return 750;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 15), Comparison: .LeftGreaterEqual)) {
				return 500;
			} else {
				return 250;
			}
		case .Acrylic:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 1500;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 12), Comparison: .LeftGreaterEqual)) {
				return 1000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 4), Millimeters: 19), Comparison: .LeftGreaterEqual)) {
				return 750;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 7, d: 8), Millimeters: 22), Comparison: .LeftGreaterEqual)) {
				return 500;
			} else {
				return 250;
			}
		default:
			return -1;
		}
	case .Forstner:
		switch Mat {
		case .Softwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 8), Millimeters: 16), Comparison: .LeftGreaterEqual)) {
				return 2400;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 1), Millimeters: 25), Comparison: .LeftGreaterEqual)) {
				return 1500;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 1, n: 1, d: 4), Millimeters: 32), Comparison: .LeftGreaterEqual)) {
				return 1000;
			} else {
				return 500;
			}
		case .Hardwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
				return 700;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 1), Millimeters: 25), Comparison: .LeftGreaterEqual)) {
				return 500;
			} else {
				return 250;
			}
		case .Acrylic:
			return 250;
		default:
			return -1;
		}
	case .GlassAndTile:
		switch Mat {
		case .GlassAndTile:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 8), Millimeters: 3), Comparison: .LeftGreaterEqual)) {
				return 750;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 16), Millimeters: 5), Comparison: .LeftGreaterEqual)) {
				return 600;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6.5), Comparison: .LeftGreaterEqual)) {
				return 500;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 5, d: 16), Millimeters: 8), Comparison: .LeftGreaterEqual)) {
				return 400;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 9.5), Comparison: .LeftGreaterEqual)) {
				return 350;
			} else {
				return 200;
			}
		default:
			return -1;
		}
	case .HoleSaw:
		switch Mat {
		case .Softwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 2), Millimeters: 50), Comparison: .LeftGreaterEqual)) {
				return 500;
			} else {
				return 400;
			}
		case .Hardwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 1, n: 1, d: 2), Millimeters: 38), Comparison: .LeftGreaterEqual)) {
				return 350;
			} else {
				return 250;
			}
		case .Brass:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 1, n: 1, d: 2), Millimeters: 38), Comparison: .LeftGreaterEqual)) {
				return 250;
			} else {
				return 150;
			}
		case .Aluminum:
			return 250;
		default:
			return -1;
		}
	case .MultiSpur:
		switch Mat {
		case .Softwood:
			return 250;
		case .Hardwood:
			return 250;
		default:
			return -1;
		}
	case .Spade:
		switch Mat {
		case .Softwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13), Comparison: .LeftGreaterEqual)) {
				return 2000;
			} else if (Size.Compare(to: Unit(Inches: Fraction(w: 1), Millimeters: 25), Comparison: .LeftGreaterEqual)) {
				return 1750;
			} else {
				return 1500;
			}
		case .Hardwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 1), Millimeters: 25), Comparison: .LeftGreaterEqual)) {
				return 1500;
			} else {
				return 1000;
			}
		default:
			return -1;
		}
	case .SpadeWithSpurs:
		switch Mat {
		case .Softwood:
			return 2000;
		case .Hardwood:
			return 1800;
		case .Acrylic:
			return 500;
		default:
			return -1;
		}
	case .PowerBore:
		switch Mat {
		case .Softwood:
			return 1800;
		case .Hardwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 2), Millimeters: 13), Comparison: .LeftGreaterEqual)) {
				return 500;
			} else {
				return 750;
			}
		default:
			return -1;
		}
	case .CircleCutter:
		switch Mat {
		case .Softwood:
			if (Size.Compare(to: Unit(Inches: Fraction(w: 3), Millimeters: 75), Comparison: .LeftGreaterEqual)) {
				return 500;
			} else {
				return 250;
			}
		case .Hardwood:
			return 250;
		case .Acrylic:
			return 250;
		default:
			return -1;
		}
	}
}
