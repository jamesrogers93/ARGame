//
//  FirstScene.swift
//  ARGame
//
//  Created by James Rogers on 07/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class CharacterSelectionScene : Scene
{
    
    private let characters: Array<String> = ["beta", "x-bot", "y-bot", "ely", "ganfaul", "pumpkin", "vanguard"]
    
    private let characterAnimations: Array<String> = ["beta_breathing_idle", "x-bot_breathing_idle", "y-bot_breathing_idle", "ely_breathing_idle", "ganfaul_breathing_idle", "pumpkin_breathing_idle", "vanguard_breathing_idle"]

    private var currentSelection: Int = 0
    
    override init()
    {
        
    }
 
    override public func updateScene(delta: Double)
    {
        
    }
    
    public func previousCharacter()
    {
        removeCharacter()
        
        if self.currentSelection == 0
        {
            self.currentSelection = self.characters.count-1
        }
        else
        {
            self.currentSelection -= 1
        }
        
        loadCharacter()
        
        startAnimation()
    }
    
    public func nextCharacter()
    {

        removeCharacter()
        
        if self.currentSelection == self.characters.count-1
        {
            self.currentSelection = 0
        }
        else
        {
            self.currentSelection += 1
        }

        loadCharacter()
        
        startAnimation()
    }
    
    private func loadCharacter()
    {
        let entityLoader: EntityLoader = EntityLoader()
        
        // Load character from file
        if(!entityLoader.loadEntityFromFile(self.characters[self.currentSelection], self))
        {
            print("failed to load \(self.characters[self.currentSelection])")
        }
        
        // Load animation from file
        let animation = (self.characterAnimations[self.currentSelection], AnimationLoader.loadAnimationFromFile(self.characterAnimations[self.currentSelection], "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load \(self.characterAnimations[self.currentSelection])")
        }
    }
    
    private func removeCharacter()
    {
        // Delete the character and animation from the scene
        super.deleteEntityAnimated(self.characters[self.currentSelection])
        super.deleteAnimation(self.characterAnimations[self.currentSelection])
    }
    
    private func startAnimation()
    {
        // Start the animation for the newly loaded character
        if let entity = super.getEntityAnimated(self.characters[self.currentSelection])
        {
            if !entity.glModel.animationController.isPlaying
            {
                if let animation = super.getAnimation(self.characterAnimations[self.currentSelection])
                {
                    entity.glModel.animationController.play((self.characterAnimations[self.currentSelection], animation), loop: true)
                }
            }
        }
    }
    
}
