//
//  Event.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/11/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

class Event<T> {
	private var Delegates: [(T) -> Void] = [ ];
	
	public init() {
		
	}
	
	/// Add a new delegate to begin listening to the event
	/// - Parameter Delegate: The delegate callback for when the event is triggered
	public func Add(Delegate: @escaping (T) -> Void) {
		Delegates.append(Delegate);
	}
	
	/// Trigger all delegates listening to the event
	/// - Parameter value: The value to pass to the delegates
	public func Trigger(WithValue value: T) {
		for d in Delegates {
			d(value);
		}
	}
}

infix operator +=
func +=<T>(left: inout Event<T>, right: @escaping (T) -> Void) {
	left.Add(Delegate: right);
}

infix operator <-
func <-<T>(left: inout Event<T>, right: T) {
	left.Trigger(WithValue: right);
}
