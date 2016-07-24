//
//  VERStarTableViewCell.swift
//  Verus
//
//  Created by Anthony Williams on 7/23/16.
//  Copyright © 2016 Verus. All rights reserved.
//

import UIKit
import Cosmos

class VERStarTableViewCell: UITableViewCell {

    let ratingView = CosmosView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        ratingView.frame = CGRectMake(0, 0, frame.size.width-40, frame.height)
        ratingView.center = center
        ratingView.settings.fillMode = .Precise
        ratingView.settings.starSize = 30
        ratingView.settings.starMargin = 5
        ratingView.settings.filledColor = UIColor(red: 32/255, green: 206/255, blue: 153/255, alpha: 1)
        ratingView.settings.emptyBorderColor = UIColor(red: 32/255, green: 206/255, blue: 153/255, alpha: 1)
        ratingView.settings.updateOnTouch = false
        addSubview(ratingView)
    }

    func setStarRating(rating: String) {
        ratingView.rating = Double(rating)!
    }
}
