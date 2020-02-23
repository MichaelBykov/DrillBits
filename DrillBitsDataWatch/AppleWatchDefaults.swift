//
//  AppleWatchDefaults.swift
//  DrillBitsDataWatch
//
//  Created by Michael Bykov on 1/31/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

extension Defaults {
	// MARK: - Keys
	
	/// The key for what the last viewed view was
	private static let CurrentViewKey = "CurrentView";
	
	
	
	// MARK: - Variables
	
	
	/// The variable that dictates what the last viewed view was
	public static var CurrentView: Int {
		get { return GetCurrentView(); }
		set { SetCurrentView(newValue); }
	}
	
	
	
	// MARK: - Load
	
	/// Get the last viewed view
	private static func GetCurrentView() -> Int { UserDefaults.standard.integer(forKey: CurrentViewKey); }
	
	
	
	// MARK: - Save
	
	/// Set the last viewed view
	private static func SetCurrentView(_ CurrentView: Int) { UserDefaults.standard.set(CurrentView, forKey: CurrentViewKey); }

}
