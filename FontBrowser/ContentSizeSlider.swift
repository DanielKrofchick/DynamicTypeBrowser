//
//  ContentSizeSlider.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-07.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

private var circleS = CGSize(width: 7.0, height: 6.0)

struct ColorPoint {

    var value: CGFloat
    var color: UIColor
    
    init(value: CGFloat, color: UIColor) {
        self.value = value
        self.color = color
    }
    
}

class ContentSizeSlider: UISlider {
    
    var points = [ColorPoint]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let c = UIGraphicsGetCurrentContext()
        
        for point in points {
            CGContextSetFillColorWithColor(c, point.color.CGColor)
            CGContextFillEllipseInRect(c, rectForPoint(sliderCenterForPoint(point.value)))
        }
    }
    
    func rectForPoint(point: CGFloat) -> CGRect {
        let track = trackRectForBounds(bounds)
        let p = track.origin.x + track.size.width * point
        
        return CGRect(x: p - circleS.width / 2.0, y: track.origin.y + track.height / 2.0 - circleS.height / 2.0, width: circleS.width, height: circleS.height)
    }
    
    func sliderCenterForPoint(point: CGFloat) -> CGFloat {
        let track = trackRectForBounds(bounds)
        let thumb = thumbRectForBounds(bounds, trackRect: track, value: Float(point))
        
        return (CGRectGetMidX(thumb) - track.origin.x) / track.size.width
    }
    
}
