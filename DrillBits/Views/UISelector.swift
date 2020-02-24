//
//  UISelector.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/10/19.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

/// A view that allows the user to select from a variety of options displayed as simple squares with icons
class UISelector: UIView {
	
	/// Should a blue outline appear around the selected item, or should it simply be enlarged
	@IBInspectable var ShowOutline: Bool = true {
		didSet {
			Gradient.opacity = ShowOutline ? 1 : 0;
		}
	}
	
	/// The size of each item (width & height)
	public var Size: CGFloat = 50 {
		didSet {
			Recalculate(.Size);
		}
	}
	
	private var data: [(UIImage, Int)] = [ ];
	/// The data to be used with the selection widgets
	/// - Item1: The icon
	/// - Item2: The item 'tag'
	public var Data: [(UIImage, Int)] {
		get { return data; }
		set { data = newValue; Recalculate(.Reset); }
	}
	
	/// An enum for describing how to align items in the UISelector view
	enum Align {
		/// Align the items so that they start from the left going out right
		case Left
		/// Align the items so that they start rendering from the center out evenly
		case Center
		/// Align the items so that they start from the right going out left
		case Right
	}
	
	private var alignment: UISelector.Align = .Center;
	/// The alignment of the items within the view
	public var Alignment: UISelector.Align {
		get { return alignment; }
		set { alignment = newValue; Recalculate(.Position); }
	}
	
	
	/// An event for when the selection has changed, either by the user or programmatically
	/// - Remark: The passed value represents the index of the item followed by the 'tag' inputed in the second collumn of the `Data` variable associated with the newly selected item
	public var OnSelectionChanged = Event<(Int, Int)>();
	/// An event that is triggered when selecting has ended
	public var OnSelectionEnded = Event<()>();
	/// An event that fires whenever the view's height chnages
	public var OnHeightChanged = Event<CGFloat>();
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame);
		Init();
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
		Init();
	}
	
	/// The selection gradient
	private let Gradient: CAGradientLayer = CAGradientLayer();
	
	/// Performs common init operations
	private func Init() {
		// Generate our gradient
		Gradient.colors = [
			UIColor(red: 120.0 / 255.0, green: 163.0 / 255.0, blue: 244.0 / 255.0, alpha: 1).cgColor,
			UIColor(red: 52.0 / 255.0, green: 120.0 / 255.0, blue: 246.0 / 255.0, alpha: 1).cgColor
		];
		Gradient.locations = [0.0, 1.0];
		Gradient.startPoint = CGPoint(x: 0.0, y: 0.0);
		Gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
		Gradient.cornerRadius = 5;
	}
	
	
	/// Is the user pressing down + dragging their finger?
	private var IsDragging: Bool = false;
	/// The index of the currently active button (defaults to 0 if `data.count < TouchIndex`)
	private var SelectedIndex = 0;
	/// The index of the button that the user last touched
	private var TouchIndex = 0;
	/// A list of all active buttons
	private var Buttons: [UIView] = [ ];
	
	/// Get the left-most bound of the buttons
	/// - Parameter Width: The width of all the buttons combined of the current row
	private func GetLeft(Width: CGFloat) -> CGFloat {
		return	alignment == .Left		?	0 :
				alignment == .Center	?	(frame.width / 2) - (Width / 2):
											frame.width - Width;
	}
	
	/// An enum that describes how to recalculate a `UISelector` view
	public enum RecalculateType {
		/// Reposition all items (buttons)
		case Position
		/// Reposition + Resize all items (buttons)
		case Size
		/// Delete all and create new items (buttons)
		case Reset
	}
	
	/// Recalculate the bounds of the buttons
	/// - Parameter Type: How we should recalculate
	public func Recalculate(_ Type: RecalculateType) {
		if (Type == .Reset) {
			// Kill all the subviews
			for b in Buttons { b.removeFromSuperview(); }
			Buttons.removeAll();
			
			for d in data {
				// Define our new button
				let button: UIView = UIView(frame: CGRect(x: 0, y: 0, width: Size, height: Size));
				
				// Give our tag a binding to the inputted data
				button.tag = d.1;
				
				// Add an image to our button
				let image = UIImageView(frame: CGRect(x: 2, y: 2, width: Size - 4, height: Size - 4));
				image.image = d.0;
				button.addSubview(image);
				
				// Add to our collection and the screen
				Buttons.append(button);
				addSubview(button);
			}
		} else if (Type == .Size)
		// Resize all our buttons
		{ for b in Buttons { b.frame = CGRect(x: 0, y: 0, width: Size, height: Size); } }
		
		if (Type == .Reset || Type == .Size) {
			// Update our background color too
			Gradient.frame = CGRect(x: -6, y: -6, width: Size + 12, height: Size + 12);
			
			let Mask = CAShapeLayer()
			Mask.lineWidth = 4
			Mask.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: Size + 12, height: Size + 12), cornerRadius: 5).cgPath
			Mask.strokeColor = UIColor.black.cgColor
			Mask.fillColor = UIColor.clear.cgColor
			Gradient.mask = Mask
			
			// So it doesn't error out
			SelectedIndex = -1;
			Select(Index: TouchIndex);
		}
		
		/// The width & height of a button with padding
		let Padding = Size + 5;
		/// The max number of elements in a row
		let MaxRow = Int(floor((frame.width + 5) / Padding));
		/// The number of rows needed
		let RowNum = Int(ceil(Double(data.count) / Double(MaxRow)));
		
		
		// Get the left-most bound of the buttons
		var left: CGFloat = GetLeft(Width: (CGFloat(MaxRow) * Padding) - 5);
		var OnRow: Int = -1;
		
		var OffsetX: CGFloat = 0;
		for i in 0..<data.count {
			if (i % MaxRow == 0) {
				let _ = OnRow++;
				OffsetX = 0;
				if (OnRow == RowNum - 1) {
					left = GetLeft(Width: (CGFloat(data.count - i) * Padding) - 5);
				}
			}
			// Reposition our button
			Buttons[i].frame = CGRect(x: left + (OffsetX++) * Padding, y: CGFloat(OnRow) * Padding, width: Size, height: Size);
		}
		
		// Change our height
		let Height = (CGFloat(RowNum) * Padding) - 5;
		self.GetConstraint(.height)?.constant = Height;
		layoutIfNeeded();
		OnHeightChanged <- Height;
	}
	
	/// Select the button at the specified index
	/// - Parameter Index: The index of the button to select, if greater than the number of buttons, selects 0 until a button with the specified index is drawn, if less than 0, throws.
	/// - Throws: `IndexOutOfRangeException` if Index is less than 0
	public func Select(Index: Int) {
		// We can't have that
		guard Index >= 0 else { NSException(name: NSExceptionName.rangeException, reason: "The specified index was less than 0", userInfo: nil).raise(); return; };
		
		TouchIndex = Index;
		
		// Check if we have actually been selecting something
		if (SelectedIndex >= 0)
		{
			// De-activate the previously selected button
			Buttons[SelectedIndex].layer.sublayers?.remove(at: 0);
			let ImageView = Buttons[SelectedIndex].subviews.first as! UIImageView;
			ImageView.frame = CGRect(
				x: ImageView.frame.origin.x + 6,
				y: ImageView.frame.origin.y + 6,
				width: ImageView.frame.width - 12,
				height: ImageView.frame.height - 12
			)
		}
		
		let last = SelectedIndex;
		
		// There is nothing to select!
		if (Buttons.isEmpty)
		{ SelectedIndex = -1; }
		// We are out of range; default to 0
		else if (TouchIndex >= Buttons.count)
		{ SelectedIndex = 0; }
		else
		{ SelectedIndex = TouchIndex; }
		
		// Event trigger?
		if (last != SelectedIndex) {
			// Selection changed! Lets tell everyone.
			OnSelectionChanged <- (SelectedIndex, Buttons[SelectedIndex].tag);
		}
		
		// If there is a button to select
		if (SelectedIndex >= 0)
		{
			// Activate the view
			Buttons[SelectedIndex].layer.insertSublayer(Gradient, at: 0);
			let ImageView = Buttons[SelectedIndex].subviews.first as! UIImageView;
			ImageView.frame = CGRect(
				x: ImageView.frame.origin.x - 6,
				y: ImageView.frame.origin.y - 6,
				width: ImageView.frame.width + 12,
				height: ImageView.frame.height + 12
			)
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		IsDragging = true;
		UpdateTouches(touches, feedback: true);
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		UpdateTouches(touches, feedback: true);
	}
	
	let Feedback = UISelectionFeedbackGenerator();
	private func UpdateTouches(_ touches: Set<UITouch>, feedback: Bool) {
		if (IsDragging && !Buttons.isEmpty) {
			let touch: UITouch = touches.first!;
			var Index = 0;
			// Loop through all our buttons (items)
			for b in Buttons {
				// Check if the touch is within the bounds of the button
				let pos = touch.location(in: b);
				if (pos.x >= 0 && pos.x <= b.frame.width && pos.y >= 0 && pos.y <= b.frame.height) {
					// We are selecting this button
					// New selection?
					if (SelectedIndex != Index) {
						Select(Index: Index);
						
						if (feedback) {
							// Give the user some haptic feedback
							Feedback.prepare();
							Feedback.selectionChanged();
						}
					}
					
					return;
				}
				
				let _ = Index++;
			}
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		IsDragging = false;
		OnSelectionEnded <- ();
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		IsDragging = false;
		OnSelectionEnded <- ();
	}
	
	override var bounds: CGRect {
		didSet {
			if (data.count > 0) {
				Recalculate(.Position);
			}
		}
	}
}
