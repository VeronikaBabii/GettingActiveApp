//
//  CollectionViewCell.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 26.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskMotivationalTipLabel: UILabel!
    @IBOutlet weak var taskHashtagsLabel: UILabel!
    
    @IBOutlet weak var taskImage: UIImageView!
    
    @IBOutlet weak var taskOpenModalButton: UIButton!
    @IBOutlet weak var taskSkipButton: UIButton!
    
    
    @IBAction func openModalButtonTapped(_ sender: Any) {
        
    }
    
}
