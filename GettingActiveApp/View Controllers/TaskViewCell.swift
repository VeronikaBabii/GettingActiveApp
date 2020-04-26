//
//  TaskViewCell.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 26.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var previewTitleLabel: UILabel!
    @IBOutlet weak var previewMotivLabel: UILabel!
    @IBOutlet weak var previewHashtagsLabel: UILabel!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var openModalButton: UIButton!
    @IBOutlet weak var skipTaskButton: UIButton!
}
