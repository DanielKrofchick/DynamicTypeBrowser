//
//  DynamicTypeObserver.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-04.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

private let defaultsFontDictionaryKey = "defaultsFontDictionaryKey"
let dynamicTypeObserverDidChangeNotification = "dynamicTypeObserverDidChangeNotification"

class DynamicTypeObserver {
    
    // contentSizeCategory: textStyle: font
    var preferredFonts = [String: [String: UIFont]]()
    var complete = false
    var completionBlock: (() -> ())? = nil
    var custom = false {
        didSet {
            if oldValue != custom {
                loadCustom(custom)
            }
        }
    }
    
    init() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contentSizeClassDidChange:"), name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    func loadDefaults() {
        loadCustom(custom)
    }
    
    func loadCustom(custom: Bool) {
        if custom {
            preferredFonts = figure1FontDictionary()
        } else {
            if let dictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(defaultsFontDictionaryKey) {
                preferredFonts = deserializePreferredFonts(dictionary as! [String: [String: [String: AnyObject]]])
            } else {
                preferredFonts = [String: [String: UIFont]]()
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(dynamicTypeObserverDidChangeNotification, object: nil)
    }
    
    @objc func contentSizeClassDidChange(note: NSNotification) {
        println("contentSizeClassDidChange")
        
        captureCurrentCategory()

        if !custom {
            NSUserDefaults.standardUserDefaults().setObject(serializePreferredFonts(preferredFonts), forKey: defaultsFontDictionaryKey)
        }
        
        if isComplete() {
            if complete == false {
                println("captured all content size classes")
                completionBlock?()
            }
            
            complete = true
        }
    }
    
    func captureCurrentCategory() {
        let category = UIApplication.sharedApplication().preferredContentSizeCategory
        
        if preferredFonts[category] == nil {
            preferredFonts[category] = [String: UIFont]()
        }
        
        for textStyle in UIFont.textStyles() {
            preferredFonts[category]![textStyle] = UIFont.preferredFontForTextStyle(textStyle)
        }
    }
    
    func isComplete() -> Bool {
        for category in UIApplication.contentSizeCategories() {
            if preferredFonts[category] == nil {
                return false
            } else {
                for textStyle in UIFont.textStyles() {
                    if preferredFonts[category]![textStyle] == nil {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func serializePreferredFonts(preferredFonts: [String: [String: UIFont]]) -> [String: AnyObject] {
        var serialized = [String: [String: [String: AnyObject]]]()
        
        for (category, styles) in preferredFonts {
            var styleDict = [String: [String: AnyObject]]()

            for (style, font) in styles {
                styleDict[style] = font.serialize()
            }
            
            serialized[category] = styleDict
        }
        
        return serialized
    }
    
    func deserializePreferredFonts(serialized: [String: [String: [String: AnyObject]]]) -> [String: [String: UIFont]] {
        var deserialized = [String: [String: UIFont]]()
        
        for (category, styles) in serialized {
            var styleDict = [String: UIFont]()
            
            for (style, fontDictionary) in styles {
                if let font = UIFont.deserialize(fontDictionary) {
                    styleDict[style] = font
                }
            }
            
            deserialized[category] = styleDict
        }
        
        return deserialized
    }
    
    func figure1FontDictionary() -> [String: [String: UIFont]] {
        func headline() -> [String: UIFont] {
            return [
                UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: UIFont.systemFontOfSize(26),
                UIContentSizeCategoryAccessibilityExtraExtraLarge: UIFont.systemFontOfSize(25),
                UIContentSizeCategoryAccessibilityExtraLarge: UIFont.systemFontOfSize(24),
                UIContentSizeCategoryAccessibilityLarge: UIFont.systemFontOfSize(24),
                UIContentSizeCategoryAccessibilityMedium: UIFont.systemFontOfSize(23),
                UIContentSizeCategoryExtraExtraExtraLarge: UIFont.systemFontOfSize(23),
                UIContentSizeCategoryExtraExtraLarge: UIFont.systemFontOfSize(22),
                UIContentSizeCategoryExtraLarge: UIFont.systemFontOfSize(21),
                UIContentSizeCategoryLarge: UIFont.systemFontOfSize(20),
                UIContentSizeCategoryMedium: UIFont.systemFontOfSize(19),
                UIContentSizeCategorySmall: UIFont.systemFontOfSize(18),
                UIContentSizeCategoryExtraSmall: UIFont.systemFontOfSize(17),
            ]
        }
        
        func subheadline() -> [String: UIFont] {
            return [
                UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: UIFont.systemFontOfSize(24),
                UIContentSizeCategoryAccessibilityExtraExtraLarge: UIFont.systemFontOfSize(23),
                UIContentSizeCategoryAccessibilityExtraLarge: UIFont.systemFontOfSize(22),
                UIContentSizeCategoryAccessibilityLarge: UIFont.systemFontOfSize(22),
                UIContentSizeCategoryAccessibilityMedium: UIFont.systemFontOfSize(21),
                UIContentSizeCategoryExtraExtraExtraLarge: UIFont.systemFontOfSize(20),
                UIContentSizeCategoryExtraExtraLarge: UIFont.systemFontOfSize(19),
                UIContentSizeCategoryExtraLarge: UIFont.systemFontOfSize(18),
                UIContentSizeCategoryLarge: UIFont.systemFontOfSize(17),
                UIContentSizeCategoryMedium: UIFont.systemFontOfSize(16),
                UIContentSizeCategorySmall: UIFont.systemFontOfSize(15),
                UIContentSizeCategoryExtraSmall: UIFont.systemFontOfSize(14),
            ]
        }
        
        func body() -> [String: UIFont] {
            return [
                UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: UIFont.systemFontOfSize(22),
                UIContentSizeCategoryAccessibilityExtraExtraLarge: UIFont.systemFontOfSize(21),
                UIContentSizeCategoryAccessibilityExtraLarge: UIFont.systemFontOfSize(20),
                UIContentSizeCategoryAccessibilityLarge: UIFont.systemFontOfSize(19),
                UIContentSizeCategoryAccessibilityMedium: UIFont.systemFontOfSize(18),
                UIContentSizeCategoryExtraExtraExtraLarge: UIFont.systemFontOfSize(18),
                UIContentSizeCategoryExtraExtraLarge: UIFont.systemFontOfSize(16),
                UIContentSizeCategoryExtraLarge: UIFont.systemFontOfSize(15),
                UIContentSizeCategoryLarge: UIFont.systemFontOfSize(14),
                UIContentSizeCategoryMedium: UIFont.systemFontOfSize(13),
                UIContentSizeCategorySmall: UIFont.systemFontOfSize(12),
                UIContentSizeCategoryExtraSmall: UIFont.systemFontOfSize(11),
            ]
        }
        
        func caption1() -> [String: UIFont] {
            return [
                UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: UIFont.systemFontOfSize(22),
                UIContentSizeCategoryAccessibilityExtraExtraLarge: UIFont.systemFontOfSize(21),
                UIContentSizeCategoryAccessibilityExtraLarge: UIFont.systemFontOfSize(20),
                UIContentSizeCategoryAccessibilityLarge: UIFont.systemFontOfSize(19),
                UIContentSizeCategoryAccessibilityMedium: UIFont.systemFontOfSize(18),
                UIContentSizeCategoryExtraExtraExtraLarge: UIFont.systemFontOfSize(18),
                UIContentSizeCategoryExtraExtraLarge: UIFont.systemFontOfSize(17),
                UIContentSizeCategoryExtraLarge: UIFont.systemFontOfSize(16),
                UIContentSizeCategoryLarge: UIFont.systemFontOfSize(15),
                UIContentSizeCategoryMedium: UIFont.systemFontOfSize(14),
                UIContentSizeCategorySmall: UIFont.systemFontOfSize(13),
                UIContentSizeCategoryExtraSmall: UIFont.systemFontOfSize(12),
            ]
        }
        
        func caption2() -> [String: UIFont] {
            return [
                UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: UIFont.systemFontOfSize(18),
                UIContentSizeCategoryAccessibilityExtraExtraLarge: UIFont.systemFontOfSize(17),
                UIContentSizeCategoryAccessibilityExtraLarge: UIFont.systemFontOfSize(16),
                UIContentSizeCategoryAccessibilityLarge: UIFont.systemFontOfSize(16),
                UIContentSizeCategoryAccessibilityMedium: UIFont.systemFontOfSize(15),
                UIContentSizeCategoryExtraExtraExtraLarge: UIFont.systemFontOfSize(15),
                UIContentSizeCategoryExtraExtraLarge: UIFont.systemFontOfSize(14),
                UIContentSizeCategoryExtraLarge: UIFont.systemFontOfSize(14),
                UIContentSizeCategoryLarge: UIFont.systemFontOfSize(13),
                UIContentSizeCategoryMedium: UIFont.systemFontOfSize(12),
                UIContentSizeCategorySmall: UIFont.systemFontOfSize(12),
                UIContentSizeCategoryExtraSmall: UIFont.systemFontOfSize(11),
            ]
        }
        
        func footnote() -> [String: UIFont] {
            return [
                UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: UIFont.systemFontOfSize(20),
                UIContentSizeCategoryAccessibilityExtraExtraLarge: UIFont.systemFontOfSize(18),
                UIContentSizeCategoryAccessibilityExtraLarge: UIFont.systemFontOfSize(17),
                UIContentSizeCategoryAccessibilityLarge: UIFont.systemFontOfSize(16),
                UIContentSizeCategoryAccessibilityMedium: UIFont.systemFontOfSize(15),
                UIContentSizeCategoryExtraExtraExtraLarge: UIFont.systemFontOfSize(15),
                UIContentSizeCategoryExtraExtraLarge: UIFont.systemFontOfSize(14),
                UIContentSizeCategoryExtraLarge: UIFont.systemFontOfSize(13),
                UIContentSizeCategoryLarge: UIFont.systemFontOfSize(12),
                UIContentSizeCategoryMedium: UIFont.systemFontOfSize(11),
                UIContentSizeCategorySmall: UIFont.systemFontOfSize(10),
                UIContentSizeCategoryExtraSmall: UIFont.systemFontOfSize(10),
            ]
        }
        
        func transform(input: [String: [String: UIFont]]) -> [String: [String:  UIFont]] {
            var output = [String: [String: UIFont]]()
            
            for category in UIApplication.contentSizeCategories() {
                for textStyle in UIFont.textStyles() {
                    if output[category] == nil {
                        var dictionary = [String: UIFont]()
                        output[category] = dictionary
                    }
                    
                    output[category]![textStyle] = input[textStyle]![category]
                }
            }
            
            return output
        }
        
        return transform([
            UIFontTextStyleHeadline: headline(),
            UIFontTextStyleSubheadline: subheadline(),
            UIFontTextStyleBody: body(),
            UIFontTextStyleCaption1: caption1(),
            UIFontTextStyleCaption2: caption2(),
            UIFontTextStyleFootnote: footnote(),
        ])
    }
    
}

private let fontFamilyNameKey = "fontFamilyNameKey"
private let fontNameKey = "fontNameKey"
private let fontPointSizeKey = "fontPointSizeKey"
private let fontAscenderKey = "fontAscenderKey"
private let fontDescenderKey = "fontDescenderKey"
private let fontCapHeightKey = "fontCapHeightKey"
private let fontXHeightKey = "fontXHeightKey"
private let fontLineHeightKey = "fontLineHeightKey"
private let fontLeadingKey = "fontLeadingKey"

private extension UIFont {
    
    func serialize() -> [String: AnyObject] {
        var result = [String: AnyObject]()
        
        result[fontFamilyNameKey] = familyName
        result[fontNameKey] = fontName
        result[fontPointSizeKey] = NSNumber(float: Float(pointSize))
        result[fontAscenderKey] = NSNumber(float: Float(ascender))
        result[fontDescenderKey] = NSNumber(float: Float(descender))
        result[fontCapHeightKey] = NSNumber(float: Float(capHeight))
        result[fontXHeightKey] = NSNumber(float: Float(xHeight))
        result[fontLineHeightKey] = NSNumber(float: Float(lineHeight))
        result[fontLeadingKey] = NSNumber(float: Float(leading))

        return result
    }
    
    class func deserialize(dictionary: [String: AnyObject]) -> UIFont? {
        var font: UIFont? = nil
        
        if let name = dictionary[fontFamilyNameKey] as? String,
            let pointSize = dictionary[fontPointSizeKey] as? NSNumber,
            let ascender = dictionary[fontAscenderKey] as? NSNumber,
            let descender = dictionary[fontDescenderKey] as? NSNumber,
            let capHeight = dictionary[fontCapHeightKey] as? NSNumber,
            let xHeight = dictionary[fontXHeightKey] as? NSNumber,
            let lineHeight = dictionary[fontLineHeightKey] as? NSNumber,
            let leadingHeight = dictionary[fontLeadingKey] as? NSNumber
        {
            font = UIFont(name: name, size: CGFloat(pointSize.floatValue))
        }
        
        return font
    }
    
}
