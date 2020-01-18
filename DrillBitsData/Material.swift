//
//  Material.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/26/19.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

/// An enumerator that represents all the different (supported) materials
public enum Material: Int {
	case Softwood		= 0
	case Hardwood		= 1
	case Acrylic		= 2
	case Brass			= 3
	case Aluminum		= 4
	case Steel			= 5
	case GlassAndTile	= 6
}

public func ToString(Mat: Material) -> String {
	switch Mat {
	case .Softwood:
		return "Softwood";
	case .Hardwood:
		return "Hardwood";
	case .Acrylic:
		return "Acrylic";
	case .Brass:
		return "Brass";
	case .Aluminum:
		return "Aluminum";
	case .Steel:
		return "Steel";
	case .GlassAndTile:
		return "Glass and Tile";
	}
}

public func GetDescFor(Mat: Material) -> String {
	switch Mat {
	case .Softwood:
		return "Very versatile";
	case .Hardwood:
		return "Long lasting";
	case .Acrylic:
		return "Best paired with a spade bit with spurs";
	case .Brass:
		return "Doesn't cause sparks";
	case .Aluminum:
		return "A very lightweight metal, resists corrosion";
	case .Steel:
		return "Strong and inexpensive";
	case .GlassAndTile:
		return "Should only be cut with a glass-and-tile drill bit";
	}
}

public func GetImageFor(Mat: Material) -> UIImage {
	return UIImage(named: ToString(Mat: Mat))!;
}
