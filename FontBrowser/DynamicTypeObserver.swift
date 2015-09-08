//
//  DynamicTypeObserver.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-04.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

private let defaultsFontDictionaryKey = "defaultsFontDictionaryKey"

class DynamicTypeObserver {
    
    // contentSizeCategory: textStyle: font
    var preferredFonts = [String: [String: UIFont]]()
    var complete = false
    var completionBlock: (() -> ())? = nil
    
    init() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contentSizeClassDidChange:"), name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    func loadDefaults() {
        if let dictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(defaultsFontDictionaryKey) {
            preferredFonts = deserializePreferredFonts(dictionary as! [String: [String: [String: AnyObject]]])
        }
    }
    
    @objc func contentSizeClassDidChange(note: NSNotification) {
        println("contentSizeClassDidChange")
        
        captureCurrentCategory()

        NSUserDefaults.standardUserDefaults().setObject(serializePreferredFonts(preferredFonts), forKey: defaultsFontDictionaryKey)
        
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
