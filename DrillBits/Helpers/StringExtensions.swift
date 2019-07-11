//
//  StringExtensions.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/11/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

extension String {
	/// Insert a string at the specified index
	/// - Parameter newElement: The string to insert
	/// - Parameter at: The index to insert the string at
	public mutating func insert(_ newElement: String, at: Int) {
		var Index: String.Index = self.index(self.startIndex, offsetBy: at);
		
		for i in 0..<newElement.count {
			self.insert(newElement[i], at: Index);
			Index = self.index(after: Index);
		}
	}
	
	/// Remove a character at the specified index
	/// - Parameter at: The index at which to remove a character
	public mutating func remove(at: Int) {
		self.remove(at: self.index(self.startIndex, offsetBy: at));
	}
	
	/// Get the character at the specified index
	/// - Parameter index: The index of the character to access
	public subscript(_ index: Int) -> Character {
		return self[self.index(self.startIndex, offsetBy: index)];
	}
}
