//
//  VERArticleTextTableViewCell.swift
//  Verus
//
//  Created by Anthony Williams on 7/23/16.
//  Copyright © 2016 Verus. All rights reserved.
//

import UIKit

class VERArticleTextTableViewCell: UITableViewCell {

    var textView: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        textView = UITextView(frame: frame)
        textView.textColor = .blackColor()
        textView.backgroundColor = .clearColor()
        textView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        textView.editable = false
        textView.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        addSubview(textView)
    }
    
    func configureText(text: String, keywords: [NSDictionary]) {
        let attributed = NSMutableAttributedString(string: text)
        
        for keyword in keywords {
            do {
                let regex = try NSRegularExpression(pattern: keyword["text"] as! String, options: .CaseInsensitive)
                
                for match in regex.matchesInString(text, options: NSMatchingOptions(), range: NSRange(location: 0, length: text.characters.count)) as [NSTextCheckingResult] {
                    attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255/255, green: 51/255, blue: 51/255, alpha: 1), range: match.range)
                }
            } catch {
                print("Nope")
            }
        }
        
        textView.attributedText = attributed
    }
    
    func configureTextWithRegex(text: String) {
        var text2 = text
        
        let a = NSMutableAttributedString(string: text2)
        
        // Regex look for ~[word]~
        let matches = text2.regexMatches("~[a-zA-Z]+~")
        
        for match in matches {
            print(match)
            
            // Remove ~ on both ends
            let range = text2.rangeOfString(match)
            
            text2.removeAtIndex(range!.startIndex.advancedBy(match.characters.count-1))
            text2.removeAtIndex(range!.startIndex)
            
            let startIndex: Int = text2.startIndex.distanceTo(range!.startIndex)
            let endIndex: Int = text2.startIndex.distanceTo(range!.endIndex) - 2
            
            a.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(startIndex, endIndex - startIndex))
        }
        
        // Set background color for that range
        print(a)
        
        textView.attributedText = a
    }
}


extension String {
    func regexMatches(pattern: String) -> Array<String> {
        let re: NSRegularExpression
        do {
            re = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return []
        }
        
        let matches = re.matchesInString(self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        var collectMatches: Array<String> = []
        for match in matches {
            let substring = (self as NSString).substringWithRange(match.rangeAtIndex(0))
            collectMatches.append(substring)
        }
        return collectMatches
    }
}