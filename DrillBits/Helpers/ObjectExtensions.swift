//
//  ObjectExtensions.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/11/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

precedencegroup SetPrecedence {
	associativity: right
	higherThan: MultiplicationPrecedence
}
infix operator <--: SetPrecedence
func <-- <T>(left: T, right: (T) -> Void) -> T {
	right(left);
	return left;
}

// The `<--` operator allows you to do C# style initialization w/ property assignment
// Ex:
//
// let m = MyObject() <-- {
//		$0.a = 3;
//		$0.foo = "bar";
//		$0.SomeValue = true;
// }
//
// (The `$0` are required)
