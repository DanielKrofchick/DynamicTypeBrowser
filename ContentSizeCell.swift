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

class ContentSizeCell: UITableViewCell {
    
    var label = UILabel()
    var slider = UISlider()
    var lastValue = CGFloat(0)
    var pointChangedBlock: (() -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.textAlignment = .Center
        contentView.addSubview(label)
        
        slider.addTarget(self, action: Selector("sliderDidChange:"), forControlEvents: .ValueChanged)
        contentView.addSubview(slider)

        initConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initConstraints() {
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        slider.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addConstraint(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: ei.top))
        contentView.addConstraint(NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: ei.left))
        contentView.addConstraint(NSLayoutConstraint(item: label, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -ei.right))

        contentView.addConstraint(NSLayoutConstraint(item: slider, attribute: .Top, relatedBy: .Equal, toItem: label, attribute: .Bottom, multiplier: 1, constant: yi))
        contentView.addConstraint(NSLayoutConstraint(item: slider, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: ei.left))
        contentView.addConstraint(NSLayoutConstraint(item: slider, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -ei.right))
        contentView.addConstraint(NSLayoutConstraint(item: slider, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -ei.bottom))
    }
    
    func setCategory(category: String) {
        setPoint(nearestPointForPoint(pointForContentSizeCategory(category)), animated: true)
    }
    
    func getCategory() -> String {
        return contentSizeCategoryForPoint(nearestPointForPoint(CGFloat(slider.value)))
    }
    
    func sliderDidChange(slider: UISlider) {
        setPoint(nearestPointForPoint(CGFloat(slider.value)), animated: true)
    }
    
    func setPoint(point: CGFloat, animated: Bool) {
        let points = sliderPoints(UIApplication.contentSizeCategories().count)

        slider.setValue(Float(point), animated: false)
        
        if let index = find(points, point) {
            label.text = UIApplication.nameForContentSizeCateogy(UIApplication.contentSizeCategories()[index])
        }
        
        if point != lastValue {
            pointChangedBlock?()
            lastValue = point
        }
    }
    
    func pointForContentSizeCategory(category: String) -> CGFloat {
        if let index = find(UIApplication.contentSizeCategories(), category) {
            return sliderPoints(UIApplication.contentSizeCategories().count)[index]
        } else {
            return CGFloat(0)
        }
    }
    
    func nearestPointForPoint(point: CGFloat) -> CGFloat {
        let points = sliderPoints(UIApplication.contentSizeCategories().count)
        return nearestPoint(point, points: points)
    }
    
    func contentSizeCategoryForPoint(point: CGFloat) -> String {
        let points = sliderPoints(UIApplication.contentSizeCategories().count)

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
