//
//  MyTaskTableViewCell.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 02.06.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

protocol MyTaskCellDelegate {
    func didTapDoneButton(index: Int)
}

class MyTaskTableViewCell: UITableViewCell {
    
    var cellDelegate: MyTaskCellDelegate?
    var index: IndexPath?

    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myDescription: UILabel!
    @IBOutlet weak var myTipLabel: UILabel!
    @IBOutlet weak var myHashtags: UILabel!
    @IBOutlet weak var doneButton: UIButton!

    func styleButton() {
        Utilities.styleFilledButton(doneButton)
    }
    
    @IBAction func taskDoneClicked(_ sender: UIButton) {
        cellDelegate?.didTapDoneButton(index: (index?.row)!)
        //print("Task done clicked")
    }
    
}
