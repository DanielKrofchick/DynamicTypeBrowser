//
//  NSIndexPath+Extensions.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-07.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import Foundation

extension NSIndexPath {
    
    class func forRange(range: NSRange, section: Int) -> [NSIndexPath] {
        var result = [NSIndexPath]()
    
        for index in range.location...(range.location + range.length) {
            result.append(NSIndexPath(forItem: index, inSection: section))
        }
        
        return result
    }
    
}