//
//  Material.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/26/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

/// An enumerator that represents all the different (supported) materials
enum Material {
	case Softwood
	case Hardwood
	case Acrylic
	case Brass
	case Aluminum
	case Steel
	case GlassAndTile
}

func ToString(Mat: Material) -> String {
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

func GetImageFor(Mat: Material) -> UIImage {
	return UIImage(named: ToString(Mat: Mat))!;
}
