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
