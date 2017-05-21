//
//  DifficultySelectionController.swift
//  ARGame
//
//  Created by James Rogers on 17/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class DifficultySelectionController: UIViewController
{
    
    var difficulty: FighterAIDifficulty = .AI_NORMAL
    
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? CharacterSelectionController {
            
            // Set the difficulty in the CharacterSelectionController
            destinationViewController.difficulty = self.difficulty
            
        }
    }
    
    @IBAction func backButtonPressed()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func easyButtonPressed(_ sender: UIButton)
    {
        difficulty = .AI_EASY
        
        sender.setImage(UIImage(named: "Easy_Enabled"), for: .normal)
        self.normalButton.setImage(UIImage(named: "Normal_Disabled"), for: .normal)
        self.hardButton.setImage(UIImage(named: "Hard_Disabled"), for: .normal)
    }
    
    @IBAction func normalButtonPressed(_ sender: UIButton)
    {
        difficulty = .AI_NORMAL
        
        sender.setImage(UIImage(named: "Normal_Enabled"), for: .normal)
        self.easyButton.setImage(UIImage(named: "Easy_Disabled"), for: .normal)
        self.hardButton.setImage(UIImage(named: "Hard_Disabled"), for: .normal)
    }
    
    @IBAction func hardButtonPressed(_ sender: UIButton)
    {
        difficulty = .AI_HARD
        
        sender.setImage(UIImage(named: "Hard_Enabled"), for: .normal)
        self.easyButton.setImage(UIImage(named: "Easy_Disabled"), for: .normal)
        self.normalButton.setImage(UIImage(named: "Normal_Disabled"), for: .normal)
    }
}
