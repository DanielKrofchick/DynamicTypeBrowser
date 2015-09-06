//
//  ViewController.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-03.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

private var cellReuseIdentifier = "cellReuseIdentifier"
private var contentSizeReuseIdentifier = "contentSizeReuseIdentifier"

class ViewController: UITableViewController {
    
    var data = [contentSizeReuseIdentifier] + UIFont.textStyles()
    var dynamicTypeObserver = DynamicTypeObserver()
    var category = UIApplication.sharedApplication().preferredContentSizeCategory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamicTypeObserver.completeBlock = {
            self.tableView.reloadData()
        }
        
        view.backgroundColor = UIColor.orangeColor()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.registerClass(ContentSizeCell.classForCoder(), forCellReuseIdentifier: contentSizeReuseIdentifier)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let identifier = data[indexPath.row]
        
        if identifier == contentSizeReuseIdentifier {
            cell = tableView.dequeueReusableCellWithIdentifier(contentSizeReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            configureContentSizeCell(cell as! ContentSizeCell)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            configureCell(cell, textStyle: data[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = data[indexPath.row]
        
        if identifier == contentSizeReuseIdentifier {
            let cell = ContentSizeCell()
            configureContentSizeCell(cell)
            return cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        } else {
            return 60.0
        }
    }
    
    func configureCell(cell: UITableViewCell, textStyle: String) {
        cell.contentView.backgroundColor = UIColor.blueColor()
        cell.textLabel?.font = dynamicTypeObserver.preferredFonts[self.category]?[textStyle]
        cell.textLabel?.text = UIFont.nameForTextStyle(textStyle)
    }
    
    func configureContentSizeCell(cell: ContentSizeCell) {
        cell.label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.setCategory(self.category)
        cell.pointChangedBlock = {
            self.category = cell.getCategory()
            self.tableView.reloadData()
        }
    }
    
}

