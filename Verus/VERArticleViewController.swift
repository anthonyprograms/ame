//
//  VERArticleViewController.swift
//  Verus
//
//  Created by Anthony Williams on 7/23/16.
//  Copyright © 2016 Verus. All rights reserved.
//

import UIKit
import Cosmos
import CoreData

class VERArticleViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    
    let tableView = UITableView()
    let titleLabel = UILabel()
    let articleTextView = UITextView()
    let ratingView = CosmosView()
    
    var link: String!
    
    var keywords: [NSDictionary] = []
    var rating = "1.0"
    
    init(link: String, managedContext: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        
        self.link = link
        self.managedContext = managedContext
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
                self.ratingView.rating = abs(Double("\(score)")! * 5)
                
                VERArticleCache(managedContext: self.managedContext).saveArticle(self.link, rating: CGFloat(self.ratingView.rating))
            }
        }
        
        VERHTTPClient().getText(link!) { data in
            guard let text = data["text"] else { return }
            self.articleTextView.attributedText = NSAttributedString(string: "\(text!)")
        }
        
        VERHTTPClient().getTitle(link!) { data in
            guard let title = data["title"] else { return }
            self.titleLabel.text = "\(title!)"
        }
        
        VERHTTPClient().getKeywords(link!) { data in
            guard let keywords = data["keywords"] else { return }
            self.keywords = keywords as! [NSDictionary]
            
            self.configureText(self.articleTextView.text, keywords: self.keywords)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        // Rating (CosmoView)
        ratingView.frame = CGRectMake(20, 80, view.frame.size.width/2, 40)
        ratingView.center.x = view.center.x
        ratingView.rating = Double(self.rating)!
        ratingView.settings.fillMode = .Precise
        ratingView.settings.starSize = 30
        ratingView.settings.starMargin = 5
        ratingView.settings.filledColor = UIColor(red: 0/255, green: 138/255, blue: 230/255, alpha: 1)
        ratingView.settings.filledBorderColor = UIColor(red: 0/255, green: 138/255, blue: 230/255, alpha: 1)
        ratingView.settings.emptyBorderColor = UIColor(red: 0/255, green: 138/255, blue: 230/255, alpha: 1)
        ratingView.settings.updateOnTouch = false
        view.addSubview(ratingView)
        
        // Title (UILabel)
        titleLabel.frame =  CGRectMake(0, ratingView.frame.maxY + 10, view.frame.size.width-40, 50)
        titleLabel.center.x = view.center.x
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.text = "Loading..."
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor(red: 0/255, green: 71/255, blue: 179/255, alpha: 1)
        view.addSubview(titleLabel)
        
        // Text (UITextView)
        articleTextView.frame = CGRectMake(0, titleLabel.frame.maxY + 10, titleLabel.frame.width, view.frame.size.height - titleLabel.frame.maxY - 20)
        articleTextView.center.x = view.center.x
        articleTextView.font = UIFont.systemFontOfSize(15)
        articleTextView.textColor = .blackColor()
        view.addSubview(articleTextView)
    }
    
    func configureText(text: String, keywords: [NSDictionary]) {
        let attributed = NSMutableAttributedString(string: text)
        
        let font: UIFont = UIFont(name: "Helvetica", size: 15)!
        attributed.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, attributed.length))
        
        for keyword in keywords {
            do {
                let regex = try NSRegularExpression(pattern: keyword["text"] as! String, options: .CaseInsensitive)
                
                for match in regex.matchesInString(text, options: NSMatchingOptions(), range: NSRange(location: 0, length: text.characters.count)) as [NSTextCheckingResult] {
                    
                    
                    guard let sentiment = keyword["sentiment"],
                        let type = sentiment["type"] else { return }
                    
                    let t = type as! String
                    if t == "negative" {
                        attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255/255, green: 51/255, blue: 51/255, alpha: 1), range: match.range)
                    }
                }
            } catch {
                print("Nope")
            }
        }
        
        articleTextView.attributedText = attributed
    }
}
