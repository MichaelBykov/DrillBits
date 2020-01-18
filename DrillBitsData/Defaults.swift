//
//  Defaults.swift
//  DrillBitsData
//
//  Created by Michael Bykov on 1/18/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

/// A static class for handling user defaults for drill bits
public class Defaults {
	// MARK: - Keys
	
	/// The key for if user defaults are saved
	public static let    StartKey = "Start";
	/// The key for what drill bit is currently selected
	public static let      BitKey = "Bit";
	/// The key for what material is currently selected
	public static let      MatKey = "Mat";
	/// The key for what size is currenly selected
	public static let     SizeKey = "Size";
	/// The key for what unit system we are currently using
	public static let ImperialKey = "Imperial";
	
	
	
	// MARK: - Variables
	
	
	/// The variable that dictates whether or not user defaults have been saved (on get, if `false`, `true` will automatically be set)
	public static var Start: Bool {
		get {
			let b = UserDefaults.standard.object(forKey: Defaults.StartKey) != nil;
			if (!b) {
				SetStart(true);
			}
			return b;
		}
		set { SetStart(newValue); }
	}
	
	/// The variable that dictates what drill bit is currently selected
	public static var Bit: DrillBit {
		get { return GetBit(); }
		set { SetBit(newValue); }
	}
	
	/// The variable that dictates what material is currently selected
	public static var Mat: Material {
		get { return GetMat(); }
		set { SetMat(newValue); }
	}
	
	/// The variable that dictates what size is currently selected
	public static var Size: Float {
		get { return GetSize(); }
		set { SetSize(newValue); }
	}
	
	/// The variable that dictates what unit system we are currently using
	public static var Imperial: Bool {
		get { return GetImperial(); }
		set { SetImperial(newValue); }
	}
	
	
	
	// MARK: - Load
	
	/// Get whether or not user defaults have been saved
	public static func GetStart() -> Bool                       { UserDefaults.standard.bool(forKey:    StartKey); }
	/// Get what drill bit was last selected
	public static func GetBit() -> DrillBit  { DrillBit(rawValue: UserDefaults.standard.integer(forKey:   BitKey))!; }
	/// Get what material was last selected
	public static func GetMat() -> Material  { Material(rawValue: UserDefaults.standard.integer(forKey:   MatKey))!; }
	/// Get what size was last selected
	public static func GetSize() -> Float                       { UserDefaults.standard.float(forKey:    SizeKey); }
	/// Get what unit system we last used
	public static func GetImperial() -> Bool                    { UserDefaults.standard.bool(forKey: ImperialKey); }
	
	
	
	// MARK: - Save
	
	/// Set whether or not user defaults have been saved
	public static func SetStart(_ Start: Bool)       { UserDefaults.standard.set(Start,        forKey:    StartKey); }
	/// Set what drill bit is currently selected
	public static func SetBit(_ Bit: DrillBit)       { UserDefaults.standard.set(Bit.rawValue, forKey:      BitKey); }
	/// Set what material is currently selected
	public static func SetMat(_ Mat: Material)       { UserDefaults.standard.set(Mat.rawValue, forKey:      MatKey); }
	/// Set what size is currenly selected
	public static func SetSize(_ Size: Float)        { UserDefaults.standard.set(Size,         forKey:     SizeKey); }
	/// Set what unit system we are currently using
	public static func SetImperial(_ Imperial: Bool) { UserDefaults.standard.set(Imperial,     forKey: ImperialKey); }
}
