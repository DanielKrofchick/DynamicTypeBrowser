//
//  UIFont+Extensions.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-04.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func textStyles() -> [String] {
        return [
            UIFontTextStyleHeadline,
            UIFontTextStyleBody,
            UIFontTextStyleSubheadline,
            UIFontTextStyleFootnote,
            UIFontTextStyleCaption1,
            UIFontTextStyleCaption2,
        ]
    }
    
    class func nameForTextStyle(textStyle: String) -> String {
        switch textStyle {
        case UIFontTextStyleHeadline:
            return "Headline"
        case UIFontTextStyleBody:
            return "Body"
        case UIFontTextStyleSubheadline:
            return "Subheadline"
        case UIFontTextStyleFootnote:
            return "Footnote"
        case UIFontTextStyleCaption1:
            return "Caption1"
        case UIFontTextStyleCaption2:
            return "Caption2"
        default:
            return ""
        }
    }
    
    class func weights() -> [CGFloat] {
        return [
            UIFontWeightUltraLight,
            UIFontWeightThin,
            UIFontWeightLight,
            UIFontWeightRegular,
            UIFontWeightMedium,
            UIFontWeightSemibold,
            UIFontWeightBold,
            UIFontWeightHeavy,
            UIFontWeightBlack,
        ]
    }
    
}