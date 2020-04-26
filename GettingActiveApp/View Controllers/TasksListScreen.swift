//
//  TasksListScreen.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 26.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

class TasksListScreen: UIViewController {
    
    // variables
    let tasksTitle = ["Let's be productive!", "Let's be kind today!", "Sometimes you just need to relax!"]
    
    let taskMotivation = ["By learning how to do one new thing a day, you'll be capable of many things.", "Helping others is great.", "Taking care of yourself is the best gift you can give yourself."]
    
    let tasksImage = [UIImage(named: ""), UIImage(named: ""), UIImage(named: "")]
    
    let taskHashtags = ["#productive #learn", "#kind #help", "#loveyourself #takecare"]
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // actions
    @IBAction func yesButtonTapped(_ sender: Any) {
        print("Hello")
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        print("Bye")
    }
    
    // styling the buttons
    func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.white
    }
    
    func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.black
    }
    
}

extension TasksListScreen: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskViewCell
        
        cell.previewTitleLabel.text = tasksTitle[indexPath.row]
        cell.previewImageView.image = tasksImage[indexPath.row]
        cell.previewMotivLabel.text = taskMotivation[indexPath.row]
        cell.previewHashtagsLabel.text = taskHashtags[indexPath.row]
        
        styleFilledButton(cell.openModalButton)
        styleHollowButton(cell.skipTaskButton)
        
        return cell
    }
}
