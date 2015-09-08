//
//  ViewController.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-03.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "cellReuseIdentifier"
private let contentSizeReuseIdentifier = "contentSizeReuseIdentifier"
private let fontSegue = "fontSegue"

class CategoryViewController: UITableViewController {
    
    var data = UIFont.textStyles()
    var dynamicTypeObserver = DynamicTypeObserver()
    var category = UIApplication.sharedApplication().preferredContentSizeCategory
    var contentSize = ContentSizeView()
    private var segueFont: UIFont? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contentSizeClassDidChange:"), name: UIContentSizeCategoryDidChangeNotification, object: nil)

        tableView.registerNib(UINib(nibName: "FontCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        dynamicTypeObserver.completionBlock = {
            self.tableView.reloadData()
        }
        
        contentSize.dynamicTypeObserver = dynamicTypeObserver
        configureContentSizeView(contentSize)
        
        dynamicTypeObserver.loadDefaults()
        contentSize.contentSizeClassDidChange()
        setTitle()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if contentSize.pointChangedBlock == nil {
            contentSize.pointChangedBlock = { [weak self] in
                if self == nil {
                    return
                }
                
                self?.category = self!.contentSize.getCategory()
                if let indexPaths = self?.tableView.indexPathsForVisibleRows() as? [NSIndexPath] {
                    self!.configureIndexPaths(indexPaths)
                }
                self?.setTitle()
            }
        }
    }
    
    @objc func contentSizeClassDidChange(note: NSNotification) {
        setTitle()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! FontCell
        
        if cell is FontCell {
            configureCell(cell as! FontCell, textStyle: data[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        configureContentSizeView(contentSize)

        return contentSize.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return contentSize
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let textStyle = data[indexPath.row]

        if let font = dynamicTypeObserver.preferredFonts[self.category]?[textStyle]{
            segueFont = font
            performSegueWithIdentifier(fontSegue, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == fontSegue {
            if let controller = segue.destinationViewController as? FontViewController {
                controller.font = segueFont
            }
        }
    }
    
    func configureIndexPaths(indexPaths: [NSIndexPath]) {
        for indexPath in indexPaths {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? FontCell {
                configureCell(cell, textStyle: data[indexPath.row])
            }
        }
    }
    
    func configureCell(cell: FontCell, textStyle: String) {
        if let font = dynamicTypeObserver.preferredFonts[self.category]?[textStyle] {
            cell.preview.font = dynamicTypeObserver.preferredFonts[self.category]?[textStyle]
            cell.preview.text = UIFont.nameForTextStyle(textStyle)
            cell.name.text = font.fontName
            cell.size.text = String(stringInterpolationSegment: font.pointSize)
        } else {
            cell.preview.text = nil
            cell.name.text = nil
            cell.size.text = nil
        }
    }
    
    func configureContentSizeView(view: ContentSizeView) {
        view.label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        view.setCategory(self.category)
    }
    
    func setTitle() {
        if dynamicTypeObserver.preferredFonts[self.category] == nil {
            let label = UILabel()
            label.font = UIFont.systemFontOfSize(12.0)
            label.text = "Settings > General > Accessibility > Larger Text"
            label.sizeToFit()
            
            navigationItem.titleView = label
        } else {
            navigationItem.titleView = nil
        }
    }
    
}

