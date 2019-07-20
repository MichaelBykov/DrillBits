//
//  UIAlertLabel.swift
//  DrillBits
//
//  Created by Michael Bykov on 7/19/19.
//  Copyright © 2019 Lepario. All rights reserved.
//

import UIKit

class UIAlertLabel: UIView {
	
	@IBOutlet var Container: UIView!
	@IBOutlet weak var ViewWatcher: UIViewWatcher!
	
	@IBOutlet weak var Label: UILabel!
	@IBInspectable var Text: String? {
		get { return Label.text; }
		set { Label.text = newValue; Resize(); }
	}
	
	@IBOutlet weak var ImageView: UIImageView!
	@IBInspectable var Image: UIImage? {
		get { return ImageView.image; }
		set { ImageView.image = newValue; }
	}
	
	
	
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
		Bundle.main.loadNibNamed("UIAlertLabel", owner: self, options: nil);
		addSubview(Container);
		Container.frame = self.bounds;
		Container.autoresizingMask = [.flexibleWidth, .flexibleHeight];
		
		ViewWatcher.OnBoundsChanged += { _ in self.Resize(); }
		
		Resize();
	}
	
	@objc func FontSizeChanged() {
		Resize();
	}
	
	/// A function for handling view resizing (vertically)
	private func Resize() {
		// Wait for constraint update
		DispatchQueue.main.async {
			// rounded corners
			let Bounds = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height);
			let MaskPath = UIBezierPath(roundedRect: Bounds, cornerRadius: 4);
			let Mask = CAShapeLayer();
			Mask.path = MaskPath.cgPath;
			self.layer.mask = Mask;
			
			self.GetConstraint(.height)?.constant = self.ViewWatcher.frame.height;
			self.updateConstraintsIfNeeded();
		}
	}
	
	override var bounds: CGRect {
		didSet {
			Resize();
		}
	}
}
