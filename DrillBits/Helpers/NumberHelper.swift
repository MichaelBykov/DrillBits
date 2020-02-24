//
//  NumberHelper.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/11/19.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

// Adding the '++' and '--' prefixes and suffixes to numbers

// Increment
prefix func ++(x: inout Int) -> Int {
	x += 1;
	return x;
}

postfix func ++(x: inout Int) -> Int {
	x += 1;
	return (x - 1);
}

prefix func ++(x: inout Double) -> Double {
	x += 1;
	return x;
}

postfix func ++(x: inout Double) -> Double {
	x += 1;
	return (x - 1);
}

prefix func ++(x: inout CGFloat) -> CGFloat {
	x += 1;
	return x;
}

postfix func ++(x: inout CGFloat) -> CGFloat {
	x += 1;
	return (x - 1);
}

// Decrement
prefix func --(x: inout Int) -> Int {
	x -= 1;
	return x;
}

postfix func --(x: inout Int) -> Int {
	x -= 1;
	return (x + 1);
}

prefix func --(x: inout Double) -> Double {
	x -= 1;
	return x;
}

postfix func --(x: inout Double) -> Double {
	x -= 1;
	return (x + 1);
}

prefix func --(x: inout CGFloat) -> CGFloat {
	x -= 1;
	return x;
}

postfix func --(x: inout CGFloat) -> CGFloat {
	x -= 1;
	return (x + 1);
}
