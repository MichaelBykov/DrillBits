//
//  DetailView.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/15/19.
//  Copyright © 2020 Lepario. All rights reserved.
//

import UIKit

class UIDetailView: UIView {
	
	@IBOutlet var Container: UIView!
	
	@IBOutlet weak var TitleLabel: UILabel!
	
	@IBOutlet weak var SelectionView: UISelector!
	
	@IBOutlet weak var SelectedImage: UIImageView!
	@IBOutlet weak var SelectedTitle: UILabel!
	@IBOutlet weak var SelectedDesc: UILabel!
	
	@IBInspectable var Title: String? {
		get { return TitleLabel.text; }
		set { TitleLabel.text = newValue; }
	}
	
	//
	// UISelector properties
	//
	
	/// Should a blue outline appear around the selected item, or should it simply be enlarged
	@IBInspectable var ShowOutline: Bool {
		get { return SelectionView.ShowOutline; }
		set { SelectionView.ShowOutline = newValue; }
	}
	
	/// The size of each item (width & height)
	public var Size: CGFloat {
		get { return SelectionView.Size; }
		set { SelectionView.Size = newValue; }
	}
	
	private var data: [(UIImage, Int, String, String)] = [ ];
	/// The data to be used with the selection widgets
	/// - Item1: The icon
	/// - Item2: The item 'tag'
	/// - Item3: The name of the item
	/// - Item4: The item description
	public var Data: [(UIImage, Int, String, String)] {
		get { return data; }
		set { data = newValue; SelectionView.Data = newValue.map { d in return (d.0, d.1); }; }
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
	
	/// The alignment of the items within the view
	public var Alignment: UISelector.Align {
		get { return SelectionView.Alignment; }
		set { SelectionView.Alignment = newValue; }
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
	
	/// Performs common init operations
	private func Init() {
		// Load our xib
		Bundle.main.loadNibNamed("UIDetailView", owner: self, options: nil);
		addSubview(Container);
		Container.frame = self.bounds;
		Container.autoresizingMask = [.flexibleWidth, .flexibleHeight];
		
		// Size updating
		SelectionView.OnHeightChanged += { _ in self.Resize(); };
		SelectionView.OnSelectionEnded += { self.OnSelectionEnded <- (); }
		SelectionView.OnSelectionChanged += { Index, Tag in
			// Change values
			self.SelectedTitle.text = self.data[Index].2;
			self.SelectedDesc.text	= self.data[Index].3;
			self.OnSelectionChanged <- (Index, Tag);
		};
		
		// Dynamic Type font size changed
		NotificationCenter.default.addObserver(self, selector: #selector(FontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil);
		
		Resize();
	}
	
	@objc func FontSizeChanged() {
		Resize();
	}
	
	/// Select the button at the specified index
	/// - Parameter Index: The index of the button to select, if greater than the number of buttons, selects 0 until a button with the specified index is drawn, if less than 0, throws.
	/// - Throws: `IndexOutOfRangeException` if Index is less than 0
	@inline(__always) public func Select(Index: Int) { self.SelectionView.Select(Index: Index); Resize(); }
	
	/// A function for handling view resizing (vertically)
	private func Resize() {
		updateConstraintsIfNeeded();
		// Wait for constraint update
		DispatchQueue.main.async {
			var Height: CGFloat = 0;
			
			// Calculate the new height by getting the size of all submembers
			Height += self.TitleLabel.frame.height + 8;
			Height += self.SelectionView.frame.height + 8;
			
			// Find if the height of the text or the image is greater and add the largest value to `Height`
			let h = self.SelectedTitle.frame.height + 8 + self.SelectedDesc.frame.height;
			
			Height += h <= 100 ? 100 : h;
			
			self.GetConstraint(.height)?.constant = Height;
			self.updateConstraintsIfNeeded();
			
			// Callback
			self.OnHeightChanged <- Height;
		}
	}
	
	override var bounds: CGRect {
		didSet {
			Resize();
		}
	}
}
