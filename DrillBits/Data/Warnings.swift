//
//  Data.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/26/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

func WarningsFor(Size: Unit, Bit: DrillBit, Mat: Material) -> [String] {
	var Warnings: [String] = [ ];
	
	switch Bit {
	case .Twist:
		if (Mat == .Steel) {
			Warnings.append("Lubricate drill with oil when cutting steel \(Size.IsImperial! ? "1/8\"" : "3mm") or thicker");
		}
		Warnings.append("Use a center punch on all holes to prevent drill from wandering");
		Warnings.append("Back material to prevent chip out");
		break;
	case .BulletPilotPoint:
		Warnings.append("Back material to prevent chip out");
		break;
	case .BradPoint:
		if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 1, d: 4), Millimeters: 6), Comparison: .LeftGreaterEqual)) {
			Warnings.append("Raise bit often to clear shavings and to prevent heat build up");
		}
		Warnings.append("Back material to prevent chip out");
		break;
	case .Forstner:
		if (Size.Compare(to: Unit(Inches: Fraction(w: 0, n: 3, d: 8), Millimeters: 10), Comparison: .LeftGreaterEqual)) {
			Warnings.append("Raise bit often to clear shavings and to prevent heat build up");
		} else {
			Warnings.append("Make several shallow passes with larger bits; allow bit to cool between passes");
		}
		break;
	case .GlassAndTile:
		Warnings.append("Wear safety goggles");
		Warnings.append("Use drill press only");
		Warnings.append("Do not apply excessive pressure");
		Warnings.append("Lubricate with water when drilling");
		Warnings.append("Reduce quill pressure when bit tip emerges from back side");
		break;
	case .HoleSaw:
		if (Mat == .Brass || Mat == .Aluminum) {
			Warnings.append("Do not use with \(Mat == .Brass ? "brass" : "aluminum") thicker than \(Size.IsImperial! ? "1/16\"" : "1.5 mm")");
		} else if (Mat == .Hardwood) {
			Warnings.append("Avoid dense hardwoods such as hard maple");
		}
		Warnings.append("Back material to prevent chip out");
		break;
	case .MultiSpur:
		Warnings.append("Back material to prevent chip out");
		break;
	case .Spade:
		Warnings.append("Clamp work to table to improve quality of hole");
		Warnings.append("Back material to prevent chip out");
		break;
	case .SpadeWithSpurs:
		Warnings.append("Clamp work securely");
		break;
	case .Powerbore:
		Warnings.append("Back material to prevent chip out");
		break;
	case .CircleCutter:
		Warnings.append("Drill one side, flip material over, place center bit in its hole, and resume cut");
		Warnings.append("Back material to prevent chip out");
		break;
	}
	
	switch Mat {
	case .Softwood:
		Warnings.append("Reduce speed when drilling into end grain");
		break;
	case .Hardwood:
		Warnings.append("Reduce speed when drilling into end grain");
		break;
	case .Acrylic:
		break;
	case .Brass:
		break;
	case .Aluminum:
		break;
	case .Steel:
		break;
	case .GlassAndTile:
		break;
	}
	
	return Warnings;
}
