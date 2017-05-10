//
//  FightGameScene.swift
//  ARGame
//
//  Created by James Rogers on 10/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class FightGameScene : Scene
{
    private var playerName: String = ""
    private var enemyName: String = ""
    private let startDistance: Float = 70.0
    
    override init()
    {
        
    }
    
    override public func updateScene()
    {
        
    }
    
    public func setupGame()
    {
        // We know there is only one animated object in the scene
        // Retrieve it's name
        for (name, _) in super.entitesAnimated
        {
            self.playerName = name
            break
        }
        
        // We know the character is at the origin
        // Transform it to its start position
        super.entitesAnimated[self.playerName]?.translate(GLKVector3Make(-startDistance, 0.0, 0.0))
        super.entitesAnimated[self.playerName]?.rotate(1.5, GLKVector3Make(0.0, 1.0, 0.0))
        
        // Find a random enemy to fight
        let characters: Array<String> = ["beta", "x-bot", "y-bot", "ely", "ganfaul", "pumpkin", "vanguard"]
        while(true)
        {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            
            if !(self.playerName == characters[randomIndex])
            {
                self.enemyName = characters[randomIndex]
                break
            }
        }
        
        // Now load enemy into scene
        let entityLoader: EntityLoader = EntityLoader()
        
        // Load character from file
        if(!entityLoader.loadEntityFromFile(self.enemyName, self))
        {
            print("failed to load \(self.enemyName)")
        }
        
        // And transform the enemy to it's starting position
        super.entitesAnimated[self.enemyName]?.translate(GLKVector3Make(startDistance, 0.0, 0.0))
        super.entitesAnimated[self.enemyName]?.rotate(-1.5, GLKVector3Make(0.0, 1.0, 0.0))
        
        // Now load in the annimations for the 2 characters
        loadAllAnimations()
    }
    
    public func loadAllAnimations()
    {
        let characterAnimations: Array<String> = ["_breathing_idle", "_warming_up"]
        
        for i in 0..<characterAnimations.count
        {
            
        }
    }
    
}
