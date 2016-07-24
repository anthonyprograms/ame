//
//  ViewController.swift
//  Verus
//
//  Created by Anthony Williams on 7/23/16.
//  Copyright © 2016 Verus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var managedContext: NSManagedObjectContext!
    var linkField: UITextField!
    let links = ["https://google.com", "https://facebook.com", "https://twitter.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0/255, green: 138/255, blue: 230/255, alpha: 1)
        
        linkField = UITextField(frame: CGRectMake(0, 0, view.frame.size.width-20, 40))
        linkField.center = view.center
        linkField.textColor = .blackColor()
        linkField.textAlignment = .Center
        linkField.backgroundColor = .whiteColor()
        linkField.placeholder = "Enter Link Here"
        linkField.layer.borderColor = UIColor.blackColor().CGColor
        linkField.layer.borderWidth = 1.0
        linkField.layer.masksToBounds = true
        view.addSubview(linkField)
        
        let submitButton = UIButton(frame: CGRectMake(0, linkField.frame.maxY+20, 100, 40))
        submitButton.center.x = view.center.x
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.backgroundColor = UIColor(red: 25/255, green: 205/255, blue: 163/255, alpha: 1)
        submitButton.setTitleColor(.whiteColor(), forState: .Normal)
        submitButton.addTarget(self, action: #selector(ViewController.submitAction), forControlEvents: .TouchUpInside)
        view.addSubview(submitButton)
        
        let titleImageView = UIImageView(frame: CGRectMake(20, 0, 150, 150))
        titleImageView.center.x = view.center.x
        titleImageView.center.y = (view.frame.size.height - linkField.frame.minY) / 2
        titleImageView.image = UIImage(named: "Verus")
        titleImageView.contentMode = .ScaleAspectFill
        view.addSubview(titleImageView)

        let tableView = UITableView(frame: CGRectMake(0, submitButton.frame.maxY+20, view.frame.size.width, view.frame.size.height - submitButton.frame.maxY+20))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clearColor()
        tableView.backgroundColor = .clearColor()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func submitAction() {
        let articleVC = VERArticleViewController(link: linkField.text!)
        
        self.navigationController?.pushViewController(articleVC, animated: true)
    }
    
    func previousAction() {
        
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.textAlignment = .Center
        cell.textLabel!.text = links[indexPath.row]
        cell.backgroundColor = .clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        let articleVC = VERArticleViewController(link: links[indexPath.row])
        
        self.navigationController?.pushViewController(articleVC, animated: true)
    }
}


