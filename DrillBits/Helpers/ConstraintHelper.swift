//
//  ConstraintHelper.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/11/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

extension UIView {
	/// Get the specified constraint from the view
	/// - Parameter Attribute: The attribute for which to test
	func GetConstraint(_ Attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		for c in self.constraints {
			if (type(of: c) == type(of: NSLayoutConstraint()) && c.firstAttribute == Attribute) {
				return c;
			}
		}
		return nil;
	}
	
	/// Add a new constraint to the view, with the first item being this view
	/// - Parameter AttributeSelf: The attribute for this view
	/// - Parameter Relation: The relationship between this view and the other view
	/// - Parameter To: The other view
	/// - Parameter AttributeOther: The attribute for the other view
	/// - Parameter Constant: The constant added to the relation
	func AddConstraint(Attribute AttributeSelf: NSLayoutConstraint.Attribute, Relation: NSLayoutConstraint.Relation, To: Any?, Attribute AttributeOther: NSLayoutConstraint.Attribute, Constant: CGFloat) {
		self.addConstraint(NSLayoutConstraint(item: self, attribute: AttributeSelf, relatedBy: Relation, toItem: To, attribute: AttributeOther, multiplier: 1, constant: Constant))
	}
	
	/// Add a new constraint to the view, with the first item being another view
	/// - Parameter Item: The view that holds the left side of the constraint
	/// - Parameter AttributeSelf: The attribute for the left side view
	/// - Parameter Relation: The relationship between the left and right side views
	/// - Parameter To: The right side view
	/// - Parameter AttributeOther: The attribute for the right side view
	/// - Parameter Constant: The constant added to the relation
	func AddConstraint(Item: Any, Attribute AttributeSelf: NSLayoutConstraint.Attribute, Relation: NSLayoutConstraint.Relation, To: Any?, Attribute AttributeOther: NSLayoutConstraint.Attribute, Constant: CGFloat) {
		self.addConstraint(NSLayoutConstraint(item: Item, attribute: AttributeSelf, relatedBy: Relation, toItem: To, attribute: AttributeOther, multiplier: 1, constant: Constant))
	}
	
	/// Remove all constraints with the given attribute
	/// - Parameter Attribute: The attribute for which to test and remove
	func RemoveConstraints(_ Attribute: NSLayoutConstraint.Attribute) {
		var cons: [NSLayoutConstraint] = [ ];
		for c in self.constraints {
			if (type(of: c) == type(of: NSLayoutConstraint()) && c.firstAttribute == Attribute) {
				cons.append(c);
			}
		}
		
		if (cons.count > 0) {
			self.removeConstraints(cons);
		}
	}
}
