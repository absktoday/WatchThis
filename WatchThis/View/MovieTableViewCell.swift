//
//  MovieTableViewCell.swift
//  WatchThis
//
//  Created by Abhishek Saral on 3/11/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var contentCell: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        traitCollection.performAsCurrent {
             // assign a dynamic borderColor called borderColor
            
            posterView.layer.cornerRadius = 13
                    
                    contentCell.layer.shadowColor = UIColor.black.cgColor
                    contentCell.layer.shadowOpacity = 0.10
                    contentCell.layer.shadowOffset = .init(width: 5.0, height: 5.0)
                    contentCell.layer.shadowRadius = 7
                    contentCell.layer.cornerRadius = 13
                    
                    shadowLayer.layer.shadowColor = UIColor.white.cgColor
                    shadowLayer.layer.shadowRadius = 7
                    shadowLayer.layer.shadowOpacity = 1
                    shadowLayer.layer.shadowOffset = .init(width: -5.0, height: -5.0)
                    shadowLayer.layer.cornerRadius = 13
            
            if self.traitCollection.userInterfaceStyle == .dark {
                // User Interface is Dark
                
                shadowLayer.layer.shadowOpacity = 0.08
                shadowLayer.layer.shadowColor = UIColor(named: "darkshadow")?.cgColor
                contentCell.layer.shadowOpacity = 0.66
                
            }
            
        }
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        
        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            
            shadowLayer.layer.shadowOpacity = 0.08
            shadowLayer.layer.shadowColor = UIColor(named: "darkshadow")?.cgColor
            contentCell.layer.shadowOpacity = 0.66
            
        } else {
            // User Interface is Light

            contentCell.layer.shadowOpacity = 0.10
            shadowLayer.layer.shadowColor = UIColor.white.cgColor
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
