//
//  DrillBit.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/26/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

/// An enumerator for all the possible (supported) drill bits
enum DrillBit: Int {
	/// Twist drill bit
	case Twist				= 0
	/// Bullet pilot-point drill bit
	case BulletPilotPoint	= 1
	/// Brad-point bit
	case BradPoint			= 2
	/// Forstner bit
	case Forstner			= 3
	/// Glass-and-tile drill bit
	case GlassAndTile		= 4
	/// Hole saw
	case HoleSaw			= 5
	/// Multi spur drill bit
	case MultiSpur			= 6
	/// Spade bit
	case Spade				= 7
	/// Spade bit with spurs
	case SpadeWithSpurs 	= 8
	/// Power bore drill bit
	case Powerbore			= 9
	/// Circle cutter bit
	case CircleCutter		= 10
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
	case .Powerbore:
		return "Powerbore Drill Bit";
	case .CircleCutter:
		return "Circle Cutter";
	}
}

func GetDescFor(Bit: DrillBit) -> String {
	switch Bit {
	case .Twist:
		return "Good bit for metal";
	case .BulletPilotPoint:
		return "Drills a pilot hole infront of the bit, preventing wandering";
	case .BradPoint:
		return "Accurate and precise";
	case .Forstner:
		return "Can cut angled, overlapped, and edge holes";
	case .GlassAndTile:
		return "Used to cut glass / tile pieces";
	case .HoleSaw:
		return "Creates holes without cutting up the core material";
	case .MultiSpur:
		return "Similar to a forstner bit";
	case .Spade:
		return "Used to bore quick, rough holes; these holes probably shouldn't be visible";
	case .SpadeWithSpurs:
		return "Best bit for acrylic";
	case .Powerbore:
		return "Ideal for deep holes and end-grain drilling";
	case .CircleCutter:
		return "Highly adjustable";
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
	case .Powerbore:
		return [ .Softwood, .Hardwood ];
	case .CircleCutter:
		return [ .Softwood, .Hardwood, .Acrylic ];
	}
}
