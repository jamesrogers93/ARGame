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
    
    @IBAction func easyButtonPressed()
    {
        difficulty = .AI_EASY
    }
    
    @IBAction func normalButtonPressed()
    {
        difficulty = .AI_NORMAL
    }
    
    @IBAction func hardButtonPressed()
    {
        difficulty = .AI_HARD
    }
}
