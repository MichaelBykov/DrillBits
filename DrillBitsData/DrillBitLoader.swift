//
//  DrillBitLoader.swift
//  DrillBitsData
//
//  Created by Michael Bykov on 1/18/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

/// A struct for holding all data associated with a drill bit
public struct DrillBitData: Identifiable {
	/// The id (index) of the object
	public var id: Int;
	
	/// The type of drill bit
	public var Bit: DrillBit;
	/// The index of the bit type
	public var Index: Int;
	/// The name of the drill bit
	public var Name: String;
	/// The description associated with the drill bit
	public var Desc: String;
	/// The drill bit's image
	public var Image: UIImage;
	
	/// Load all bit data for the given bit
	/// - Parameter bit: The bit type to load data for
	public init(bit: DrillBit) {
		Bit = bit;
		Index = bit.rawValue;
		id = Index;
		// Load all data
		Name = ToString(Bit: Bit);
		Desc = GetDescFor(Bit: Bit);
		Image = GetImageFor(Bit: Bit);
	}
	
	/// Load all bit data for the given bit
	/// - Parameter index: The index of the bit type to load data for
	public init(index: Int) {
		Bit = DrillBit(rawValue: index)!;
		Index = index;
		id = index;
		// Load all data
		Name = ToString(Bit: Bit);
		Desc = GetDescFor(Bit: Bit);
		Image = GetImageFor(Bit: Bit);
	}
}

/// Load data for all drill bits
/// - Returns: A list of all the drill bit data
public func LoadDrillBitData() -> [DrillBitData] {
	var Data: [DrillBitData] = [];
	
	// Enumerate through all the bits
	for i in 0...10 {
		Data.append(DrillBitData(index: i));
	}
	
	return Data;
}
