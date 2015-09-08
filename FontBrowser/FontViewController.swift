//
//  FontViewController.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-07.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

private var cellReuseIdentifier = "cellReuseIdentifier"

class FontViewController: UITableViewController {

    var font: UIFont? = nil {
        didSet {
            if font == oldValue {
                return
            }
            
            if font != nil {
                data = dataForFont(font!)
            } else {
                data = [ItemData]()
            }
            tableView.reloadData()
        }
    }
    private var data = [ItemData]()
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yellowColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        configureCell(cell, item: data[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    private func configureCell(cell: UITableViewCell, item: ItemData) {
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.value
    }
    
    private func dataForFont(font: UIFont) -> [ItemData] {
        var data = [ItemData]()
        
        data.append(ItemData(name: "familyName", value: font.familyName))
        data.append(ItemData(name: "fontName", value: font.fontName))
        data.append(ItemData(name: "pointSize", value: String(stringInterpolationSegment: font.pointSize)))
        data.append(ItemData(name: "ascender", value: String(stringInterpolationSegment: font.ascender)))
        data.append(ItemData(name: "descender", value: String(stringInterpolationSegment: font.descender)))
        data.append(ItemData(name: "capHeight", value: String(stringInterpolationSegment: font.capHeight)))
        data.append(ItemData(name: "xHeight", value: String(stringInterpolationSegment: font.xHeight)))
        data.append(ItemData(name: "lineHeight", value: String(stringInterpolationSegment: font.lineHeight)))
        data.append(ItemData(name: "leading", value: String(stringInterpolationSegment: font.leading)))

        return data
    }
    
}

private struct ItemData {
    
    var name: String
    var value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
}