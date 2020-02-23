//
//  MaterialLoader.swift
//  DrillBitsData
//
//  Created by Michael Bykov on 1/18/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

/// A struct for holding all data associated with a material
public struct MaterialData: Identifiable {
	/// The id (index) of the object
	public var id: Int;
	
	/// The type of material
	public var Mat: Material;
	/// The index of the material type
	public var Index: Int;
	/// The name of the material
	public var Name: String;
	/// The description associated with the material
	public var Desc: String;
	/// The material's image
	public var Image: UIImage;
	
	/// Load all material data for the given material
	/// - Parameter mat: The material type to load data for
	public init(mat: Material) {
		Mat = mat;
		Index = mat.rawValue;
		id = Index;
		// Load all data
		Name = ToString(Mat: Mat);
		Desc = GetDescFor(Mat: Mat);
		Image = GetImageFor(Mat: Mat);
	}
	
	/// Load all material data for the given material
	/// - Parameter index: The index of the material type to load data for
	public init(index: Int) {
		Mat = Material(rawValue: index)!;
		Index = index;
		id = index;
		// Load all data
		Name = ToString(Mat: Mat);
		Desc = GetDescFor(Mat: Mat);
		Image = GetImageFor(Mat: Mat);
	}
}

/// Load data for all materials
/// - Parameter For: The drill bit whose materials to find
/// - Returns: A list of all the material data
public func LoadMaterialData(For: DrillBit) -> [MaterialData] {
	var Data: [MaterialData] = [];
	
	// Get what materials are possible
	let Mats = Materials(For: For);
	
	// Enumerate through all the materials
	for Mat in Mats {
		Data.append(MaterialData(mat: Mat));
	}
	
	return Data;
}
