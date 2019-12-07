//
//  UICancelableScrollView.swift
//  DrillBits
//
//  Created by Michael Bykov on 8/7/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

/// A wrapper around scroll view that allows touch canceling in certain regions
class UICancelableScrollView: UIScrollView, UIScrollViewDelegate {
	/// A list of views that will cancel scrolling
	public var Cancels: [UIView] = [ ];
	/// A likst of views whose children cancel scrolling, but it itself doesn't
	public var RootCancels: [UIView] = [ ];
	
	override func touchesShouldCancel(in view: UIView) -> Bool {
		// True and false for the return of this function are switched... false = stop scrolling, true = continue scrolling
		var parent = view;
		if (RootCancels.contains(view)) {
			return true;
		}
		
		while (parent != self && !Cancels.contains(parent) && !RootCancels.contains(parent)) {
			parent = parent.superview!;
		}
		
		if (parent == self) {
			return true;
		}
		return false;
	}
	
	public var OnScroll: Event<()> = Event<()>();
	
	override init(frame: CGRect) {
		super.init(frame: frame);
		
		canCancelContentTouches = true;
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
		
		canCancelContentTouches = true;
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		OnScroll.Trigger(WithValue: ());
	}
}
