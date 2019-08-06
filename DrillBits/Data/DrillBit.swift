//
//  DrillBit.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/26/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

/// An enumerator for all the possible (supported) drill bits
enum DrillBit {
	/// Twist drill bit
	case Twist
	/// Bullet pilot-point drill bit
	case BulletPilotPoint
	/// Brad-point bit
	case BradPoint
	/// Forstner bit
	case Forstner
	/// Glass-and-tile drill bit
	case GlassAndTile
	/// Hole saw
	case HoleSaw
	/// Multi spur drill bit
	case MultiSpur
	/// Spade bit
	case Spade
	/// Spade bit with spurs
	case SpadeWithSpurs
	/// Power bore drill bit
	case PowerBore
	/// Circle cutter bit
	case CircleCutter
}

func ToString(Bit: DrillBit) -> String {
	switch Bit {
	case .Twist:
		return "Twist Bit";
	case .BulletPilotPoint:
		return "Bullet Pilot-Point Bit";
	case .BradPoint:
		return "Brad-Point Drill Bit";
	case .Forstner:
		return "Forstner Bit";
	case .GlassAndTile:
		return "Glass-and-Tile Bit";
	case .HoleSaw:
		return "Hole Saw";
	case .MultiSpur:
		return "Multi Spur Bit";
	case .Spade:
		return "Spade Bit";
	case .SpadeWithSpurs:
		return "Spade Bit with Spurs";
	case .PowerBore:
		return "Power Bore Bit";
	case .CircleCutter:
		return "Circle Cutter";
	}
}

func GetImageFor(Bit: DrillBit) -> UIImage {
	return UIImage(named: ToString(Bit: Bit))!;
}

/// Get all the "supported" materials for a drillbit
func Materials(For: DrillBit) -> [Material] {
	switch For {
	case .Twist:
		return [ .Softwood, .Hardwood, .Acrylic, .Brass, .Aluminum, .Steel ];
	case .BulletPilotPoint:
		return [ .Softwood, .Hardwood, .Acrylic, .Brass, .Aluminum, .Steel ];
	case .BradPoint:
		return [ .Softwood, .Hardwood, .Acrylic ];
	case .Forstner:
		return [ .Softwood, .Hardwood, .Acrylic ];
	case .GlassAndTile:
		return [ .GlassAndTile ];
	case .HoleSaw:
		return [ .Softwood, .Hardwood, .Brass, .Aluminum ];
	case .MultiSpur:
		return [ .Softwood, .Hardwood ];
	case .Spade:
		return [ .Softwood, .Hardwood ];
	case .SpadeWithSpurs:
		return [ .Softwood, .Hardwood, .Acrylic ];
	case .PowerBore:
		return [ .Softwood, .Hardwood ];
	case .CircleCutter:
		return [ .Softwood, .Hardwood, .Acrylic ];
	}
}
