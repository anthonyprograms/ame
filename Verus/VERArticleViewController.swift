//
//  VERArticleViewController.swift
//  Verus
//
//  Created by Anthony Williams on 7/23/16.
//  Copyright © 2016 Verus. All rights reserved.
//

import UIKit
import Cosmos

class VERArticleViewController: UIViewController {
    
    let tableView = UITableView()
    
    var link: String!
    
    let data: [String] = ["0.0", "Could be better", "Munich gunman had rampage info", "I'm so happy for @tmillsfashion with the launch of his new site 750 BOOST GREY WITH GUM SOLE SOLD OUT IN 1 MINUTE Jay hype Famous viewing @ Figueroa and 12th in downtown LA 11:10PM 750 BOOST GREY WITH GUM SOLE 750 BOOST GREY WITH GUM SOLE Famous SCHLESISCHE STR AND OBERBAUMBRUCKE @ 2:30AM HECKMANNUFER AND SCHLESISCHE STR @ 3:00AM BERGHAIN AND AM WRIEZENER BAHNHOF @ 4:00AM Show at 2am SOLD OUT Famous TV premiere tonight on E @ 7PM and 11PM So happy to do a video with my brothers. Rap can be fun.M & BOGART FAMOUS VIEWINGS IN ATLANTA TONIGHT STARTING AT WESTVIEW DRIVE SW AND LEE STREET SW @ 10:30PM PEACHTREE STREET AND 11TH STREET NE @ 11:15PM"]
    var data2:[String] = []
    var keywords: [NSDictionary] = []
    
    var rating = "0"
    var articleTitle = ""
    var articleText = ""
    
    init(link: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.link = link
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        
        VERHTTPClient().postLink(link!) { data in
            if let sentiment = data["docSentiment"] {
                guard let score = sentiment!["score"]! else { return }
                let r = Double("\(score)")! * 5
                self.rating = "\(r)"
                
                self.tableView.reloadData()
            }
        }
        
        VERHTTPClient().getText(link!) { data in
            guard let text = data["text"] else { return }
            self.articleText = "\(text!)"
            
            self.tableView.reloadData()
        }
        
        VERHTTPClient().getTitle(link!) { data in
            guard let title = data["title"] else { return }
            self.articleTitle = "\(title!)"
            
            self.tableView.reloadData()
        }
        
        VERHTTPClient().getKeywords(link!) { data in
            guard let keywords = data["keywords"] else { return }
            self.keywords = keywords as! [NSDictionary]
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clearColor()
        tableView.backgroundColor = .whiteColor()
        tableView.registerClass(VERStarTableViewCell.self, forCellReuseIdentifier: "StarCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerClass(VERArticleTextTableViewCell.self, forCellReuseIdentifier: "TextCell")
        view.addSubview(tableView)
    }
}

extension VERArticleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mainView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        mainView.backgroundColor = .whiteColor()
        
        let ratingView = CosmosView()
        ratingView.frame = CGRectMake(20, 2, tableView.frame.size.width-40, mainView.frame.height)
        ratingView.rating = Double(self.rating)!
        ratingView.text = data[1]
        ratingView.settings.fillMode = .Precise
        ratingView.settings.starSize = 30
        ratingView.settings.starMargin = 5
        ratingView.settings.filledColor = UIColor(red: 32/255, green: 206/255, blue: 153/255, alpha: 1)
        ratingView.settings.emptyBorderColor = UIColor(red: 32/255, green: 206/255, blue: 153/255, alpha: 1)
        ratingView.settings.updateOnTouch = false
        mainView.addSubview(ratingView)
        
        return mainView
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: VERStarTableViewCell = tableView.dequeueReusableCellWithIdentifier("StarCell", forIndexPath: indexPath) as! VERStarTableViewCell
            
            cell.selectionStyle = .None
            cell.setStarRating(self.rating)
            
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            
            cell.selectionStyle = .None
            cell.textLabel?.numberOfLines = 0
            cell.textLabel!.text = self.articleTitle
            
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 22)
            
            return cell
        } else {
            let cell: VERArticleTextTableViewCell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as! VERArticleTextTableViewCell
            
            cell.configureText(self.articleText, keywords: self.keywords)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return tableView.frame.size.height-115
        } else {
            return 30
        }
    }
}
