//
//  TaskViewCell.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 26.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

protocol TaskCellDelegate {
    func didTapImInButton(index: Int)
}

class TaskViewCell: UITableViewCell {
    
    var cellDelegate: TaskCellDelegate?
    var index: IndexPath?

    @IBOutlet weak var previewTitleLabel: UILabel!
    @IBOutlet weak var previewMotivLabel: UILabel!
    @IBOutlet weak var previewTipLabel: UILabel!
    @IBOutlet weak var previewHashtagsLabel: UILabel!
    @IBOutlet weak var addMyTaskButton: UIButton!
    
    func styleButton() {
        Utilities.styleFilledButton(addMyTaskButton)
    }
    
    @IBAction func addMyTaskClicked(_ sender: UIButton) {
        cellDelegate?.didTapImInButton(index: (index?.row)!)
       // print("Button clicked")
    }
    
}
