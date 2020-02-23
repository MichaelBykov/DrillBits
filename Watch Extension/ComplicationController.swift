//
//  ComplicationController.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/17/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import ClockKit
import DrillBitsDataWatch

class ComplicationController: NSObject, CLKComplicationDataSource {
	
	// MARK: - Template Source
	
	private let SuperScript = [ "⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "¹⁰", "¹¹", "¹²", "¹³", "¹⁴", "¹⁵" ];
	private let SubScript = [ 2: "₂", 4: "₄", 8: "₈", 16: "₁₆" ];
	
	private func GetString(Size: DrillBitsDataWatch.Unit) -> String {
		return Size.IsImperial! ?
			(Size.Inches.Whole == 0 ? "" : "\(Size.Inches.Whole)") +
			(Size.Inches.Numerator == 0 ? "" : (Size.Inches.Whole == 0 ? "" : " ") +
			(self.SuperScript[Size.Inches.Numerator]) + "⁄" + (self.SubScript[Size.Inches.Denominator]!)) + " in" :
			"\(Size.Millimeters) mm";
	}
	
	func getTemplateFor(for complication: CLKComplication, Speed: Int, Bit: DrillBit, Mat: Material, Size: DrillBitsDataWatch.Unit) -> CLKComplicationTemplate? {
		switch (complication.family) {
		case .circularSmall:
			let template = CLKComplicationTemplateCircularSmallStackText();
			template.line1TextProvider = CLKSimpleTextProvider(text: "\(Speed)");
			template.line2TextProvider = CLKSimpleTextProvider(text: "RPM");
			return template;
		case .modularSmall:
			let template = CLKComplicationTemplateModularSmallStackText();
			template.line1TextProvider = CLKSimpleTextProvider(text: "\(Speed)");
			template.line2TextProvider = CLKSimpleTextProvider(text: "RPM");
			return template;
		case .utilitarianSmall:
			let template = CLKComplicationTemplateUtilitarianSmallFlat();
			template.textProvider = CLKSimpleTextProvider(text: "\(Speed) RPM");
			return template;
		case .utilitarianSmallFlat:
			let template = CLKComplicationTemplateUtilitarianSmallFlat();
			template.textProvider = CLKSimpleTextProvider(text: "\(Speed) RPM");
			return template;
		case .extraLarge:
			let template = CLKComplicationTemplateExtraLargeStackText();
			template.line1TextProvider = CLKSimpleTextProvider(text: "RPM");
			template.line2TextProvider = CLKSimpleTextProvider(text: "\(Speed)");
			return template;
			
		case .graphicBezel:
			let cTemplate = CLKComplicationTemplateGraphicCircularStackText();
			cTemplate.line1TextProvider = CLKSimpleTextProvider(text: "RPM");
			cTemplate.line2TextProvider = CLKSimpleTextProvider(text: "\(Speed)");
			
			let template = CLKComplicationTemplateGraphicBezelCircularText();
			template.circularTemplate = cTemplate;
			template.textProvider = CLKSimpleTextProvider(text: "\(GetString(Size: Size)) • \(ToString(Bit: Bit))");
			return template;
		case .graphicCorner:
			let template = CLKComplicationTemplateGraphicCornerTextImage();
			template.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: ToString(Bit: Bit) + " Complication")!);
			template.textProvider = CLKSimpleTextProvider(text: "\(Speed) RPM");
			return template;
		case .graphicCircular:
			let template = CLKComplicationTemplateGraphicCircularStackText();
			template.line1TextProvider = CLKSimpleTextProvider(text: "RPM");
			template.line2TextProvider = CLKSimpleTextProvider(text: "\(Speed)");
			return template;
		case .graphicRectangular:
			let template = CLKComplicationTemplateGraphicRectangularStandardBody();
			template.headerTextProvider = CLKSimpleTextProvider(text: "\(Speed) RPM");
			template.body1TextProvider = CLKSimpleTextProvider(text: GetString(Size: Size));
			template.body2TextProvider = CLKSimpleTextProvider(text: ToString(Bit: Bit));
			return template;

		case .modularLarge:
			let template = CLKComplicationTemplateModularLargeStandardBody();
			template.headerTextProvider = CLKSimpleTextProvider(text: "\(Speed) RPM");
			template.body1TextProvider = CLKSimpleTextProvider(text: GetString(Size: Size));
			template.body2TextProvider = CLKSimpleTextProvider(text: ToString(Bit: Bit));
			return template;
		case .utilitarianLarge:
			let template = CLKComplicationTemplateUtilitarianLargeFlat();
			template.textProvider = CLKSimpleTextProvider(text: "\(Speed) RPM");
			return template;
			
		default:
			return nil;
		}
	}
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
		handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		let bit = Defaults.Bit;
		let mat = Defaults.Mat;
		var size = Defaults.Imperial ? DrillBitsDataWatch.Unit(Inches: Fraction(Normal: Int(Defaults.Size), MaxDenominator: 16)) : DrillBitsDataWatch.Unit(Millimeters: CGFloat(Defaults.Size * 2));
		
		// Clamp the size to valid values
		var (MinSize, MaxSize) = GetSize(Bit: bit, Mat: mat);
		MinSize.IsImperial = size.IsImperial; MaxSize.IsImperial = size.IsImperial;
		size = size.Compare(to: MaxSize, Comparison: .LeftGreater) ? MaxSize : size.Compare(to: MinSize, Comparison: .RightGreater) ? MinSize : size;
		let speed = GetSpeed(Bit: bit, Mat: mat, Size: size)
		
        // Call the handler with the current timeline entry
		let template = getTemplateFor(for: complication, Speed: speed, Bit: bit, Mat: mat, Size: size);
		if (template == nil) {
			handler(nil);
		} else {
			handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template!));
		}
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
		handler(getTemplateFor(for: complication, Speed: 3500, Bit: .Twist, Mat: .Softwood, Size: DrillBitsDataWatch.Unit(Inches: Fraction(w: 1, n: 3, d: 4))))
    }
    
}
