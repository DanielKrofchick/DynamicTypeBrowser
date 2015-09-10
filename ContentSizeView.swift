//
//  ContentSizeCategoryView.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-04.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

private let ei = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
private let yi = CGFloat(5.0)

class ContentSizeView: UIView {
    
    var label = UILabel()
    var slider = ContentSizeSlider()
    var lastValue = CGFloat(0)
    var pointChangedBlock: (() -> ())?
    var points = [CGFloat]()
    var dynamicTypeObserver: DynamicTypeObserver?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        points = sliderPoints(UIApplication.contentSizeCategories().count)
        slider.points = colorPoints()

        label.textAlignment = .Center
        addSubview(label)
        
        slider.addTarget(self, action: Selector("sliderDidChange:"), forControlEvents: .ValueChanged)
        addSubview(slider)
        
        initConstraints()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contentSizeClassDidChange"), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contentSizeClassDidChange"), name: dynamicTypeObserverDidChangeNotification, object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initConstraints() {
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        slider.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: ei.top))
        addConstraint(NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: ei.left))
        addConstraint(NSLayoutConstraint(item: label, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -ei.right))

        addConstraint(NSLayoutConstraint(item: slider, attribute: .Top, relatedBy: .Equal, toItem: label, attribute: .Bottom, multiplier: 1, constant: yi))
        addConstraint(NSLayoutConstraint(item: slider, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: ei.left))
        addConstraint(NSLayoutConstraint(item: slider, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -ei.right))
        addConstraint(NSLayoutConstraint(item: slider, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -ei.bottom))
    }
    
    @objc func contentSizeClassDidChange() {
        slider.points = colorPoints()
    }
    
    func setCategory(category: String) {
        setPoint(nearestPoint(pointForContentSizeCategory(category), points: points), animated: true)
    }
    
    func getCategory() -> String {
        return contentSizeCategoryForPoint(nearestPoint(CGFloat(slider.value), points: points))
    }
    
    func sliderDidChange(slider: UISlider) {
        setPoint(nearestPoint(CGFloat(slider.value), points: points), animated: true)
    }
    
    func setPoint(point: CGFloat, animated: Bool) {
        slider.setValue(Float(point), animated: false)
        
        if let index = find(points, point) {
            label.text = UIApplication.nameForContentSizeCateogy(UIApplication.contentSizeCategories()[index])
        }
        
        if point != lastValue {
            pointChangedBlock?()
            lastValue = point
        }
    }
    
    func colorPoints() -> [ColorPoint] {
        var result = [ColorPoint]()
        
        for (index, point) in enumerate(points) {
            let category = UIApplication.contentSizeCategories()[index]

            if let _ = dynamicTypeObserver?.preferredFonts[category] {
                result.append(ColorPoint(value: point, color: UIColor.greenColor()))
            } else {
                result.append(ColorPoint(value: point, color: UIColor.redColor()))
            }
        }
        
        return result
    }
    
    func pointForContentSizeCategory(category: String) -> CGFloat {
        if let index = find(UIApplication.contentSizeCategories(), category) {
            return points[index]
        } else {
            return CGFloat(0)
        }
    }
    
    func contentSizeCategoryForPoint(point: CGFloat) -> String {
        if let index = find(points, point) {
            return UIApplication.contentSizeCategories()[index]
        }
        
        return ""
    }
    
    func nearestPoint(point: CGFloat, points: [CGFloat]) -> CGFloat {
        var nearest = CGFloat(0)
        var distance = CGFloat(1)
        
        for p in points {
            let d = point - p

            if abs(d) < abs(distance) {
                distance = d
                nearest = p
            }
            
            if d < 0 {
                return nearest
            }
        }
        
        return nearest
    }
    
    func sliderPoints(n: Int) -> [CGFloat] {
        var points = [CGFloat]()
        let span = CGFloat(1) / CGFloat(n - 1)
        var x = CGFloat(0)
        
        while true {
            points.append(x)

            if x >= 1 {
                break
            }
            
            x += span
        }
        
        return points
    }
    
}
