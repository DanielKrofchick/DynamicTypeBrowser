//
//  DynamicTypeObserver.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-04.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

class DynamicTypeObserver {
    
    // contentSizeCategory: textStyle: font
    var preferredFonts = [String: [String: UIFont]]()
    var complete = false
    var completeBlock: (() -> ())? = nil
    
    init() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contentSizeClassDidChange:"), name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    @objc func contentSizeClassDidChange(note: NSNotification) {
        println("contentSizeClassDidChange")
        
        let category = UIApplication.sharedApplication().preferredContentSizeCategory
        
        if preferredFonts[category] == nil {
            preferredFonts[category] = [String: UIFont]()
        }
        
        for textStyle in UIFont.textStyles() {
            preferredFonts[category]![textStyle] = UIFont.preferredFontForTextStyle(textStyle)
        }
        
        if isComplete() {
            if complete == false {
                println("captured all content size classes")
                completeBlock?()
            }
            
            complete = true
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
    
}
