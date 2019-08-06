//
//  Material.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/26/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

/// An enumerator that represents all the different (supported) materials
enum Material: Int {
	case Softwood		= 0
	case Hardwood		= 1
	case Acrylic		= 2
	case Brass			= 3
	case Aluminum		= 4
	case Steel			= 5
	case GlassAndTile	= 6
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
