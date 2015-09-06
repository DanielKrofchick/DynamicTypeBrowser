//
//  UIApplication+Extensions.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-04.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func contentSizeCategories() -> [String] {
        return normalContentSizeCategories() + accessibilityContentSizeCategories()
    }
    
    class func normalContentSizeCategories() -> [String] {
        return [
            UIContentSizeCategoryExtraSmall,
            UIContentSizeCategorySmall,
            UIContentSizeCategoryMedium,
            UIContentSizeCategoryLarge,
            UIContentSizeCategoryExtraLarge,
            UIContentSizeCategoryExtraExtraLarge,
            UIContentSizeCategoryExtraExtraExtraLarge,
        ]
    }

    class func accessibilityContentSizeCategories() -> [String] {
        return [
            UIContentSizeCategoryAccessibilityMedium,
            UIContentSizeCategoryAccessibilityLarge,
            UIContentSizeCategoryAccessibilityExtraLarge,
            UIContentSizeCategoryAccessibilityExtraExtraLarge,
            UIContentSizeCategoryAccessibilityExtraExtraExtraLarge,
        ]
    }
    
    class func nameForContentSizeCateogy(category: String) -> String {
        switch category {
        case UIContentSizeCategoryExtraSmall:
            return "ExtraSmall"
        case UIContentSizeCategorySmall:
            return "Small"
        case UIContentSizeCategoryMedium:
            return "Medium"
        case UIContentSizeCategoryLarge:
            return "Large"
        case UIContentSizeCategoryExtraLarge:
            return "ExtraLarge"
        case UIContentSizeCategoryExtraExtraLarge:
            return "ExtraExtraLarge"
        case UIContentSizeCategoryExtraExtraExtraLarge:
            return "ExtraExtraExtraLarge"
        case UIContentSizeCategoryAccessibilityMedium:
            return "AccessibilityMedium"
        case UIContentSizeCategoryAccessibilityLarge:
            return "AccessibilityLarge"
        case UIContentSizeCategoryAccessibilityExtraLarge:
            return "AccessibilityExtraLarge"
        case UIContentSizeCategoryAccessibilityExtraExtraLarge:
            return "AccessibilityExtraExtraLarge"
        case UIContentSizeCategoryAccessibilityExtraExtraExtraLarge:
            return "AccessibilityExtraExtraExtraLarge"
        default:
            return ""
        }
    }
    
}
