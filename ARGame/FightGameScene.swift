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
    
    
    private var moveLeft: Bool = false
    private var moveRight: Bool = false
    
    private var characterSpeed: Double = 22.5
    
    override init()
    {
        
    }
    
    override public func updateScene(delta: Double)
    {
        if self.moveRight
        {
            super.entitesAnimated[self.playerName]?.translate(GLKVector3MultiplyScalar(GLKVector3Make(1.0, 0.0, 0.0), Float(self.characterSpeed * delta)))
        }
        else if self.moveLeft
        {
            super.entitesAnimated[self.playerName]?.translate(GLKVector3MultiplyScalar(GLKVector3Make(-1.0, 0.0, 0.0), Float(self.characterSpeed * delta)))
        }
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
        
        // Now set the animations
        //let playerAnimationName: String = self.playerName + "_warming_up"
        let playerAnimationName: String = self.playerName + "_breathing_idle"
        super.entitesAnimated[self.playerName]?.glModel.animationController.loop((playerAnimationName, super.animations[playerAnimationName]!))
        
        //let enemyAnimationName: String = self.enemyName + "_warming_up"
        let enemyAnimationName: String = self.enemyName + "_warming_up"
        super.entitesAnimated[self.enemyName]?.glModel.animationController.loop((enemyAnimationName, super.animations[enemyAnimationName]!))
    }
    
    private func loadAllAnimations()
    {
        let characterAnimations: Array<String> = ["_breathing_idle", "_warming_up", "_walking"]
        
        for i in 0..<characterAnimations.count
        {
            // Append character name to animation to load correct one
            let playerAnimName = self.playerName + characterAnimations[i]
            
            // Check if animation does not exist
            if !isAnimationExist(playerAnimName)
            {
                // Load animation from file
                let animation = (playerAnimName, AnimationLoader.loadAnimationFromFile(playerAnimName, "bvh")!)
                if !(super.addAnimation(animation))
                {
                    print("failed to load \(playerAnimName)")
                }
            }
            var animation = ("beta_punch", AnimationLoader.loadAnimationFromFile("beta_punch", "bvh")!)
            if !(super.addAnimation(animation))
            {
                print("failed to load beta_punch")
            }
            animation = ("beta_kick", AnimationLoader.loadAnimationFromFile("beta_kick", "bvh")!)
            if !(super.addAnimation(animation))
            {
                print("failed to load beta_kick")
            }
            
            animation = ("beta_block", AnimationLoader.loadAnimationFromFile("beta_block", "bvh")!)
            if !(super.addAnimation(animation))
            {
                print("failed to load beta_block")
            }
            
            // Append character name to animation to load correct one
            let enemyAnimName = self.enemyName + characterAnimations[i]
            
            // Check if animation does not exist
            if !isAnimationExist(enemyAnimName)
            {
                // Load animation from file
                let animation = (enemyAnimName, AnimationLoader.loadAnimationFromFile(enemyAnimName, "bvh")!)
                if !(super.addAnimation(animation))
                {
                    print("failed to load \(enemyAnimName)")
                }
            }
            
        }
    }
    
    public func activateMoveLeft()
    {
        self.moveLeft = true

        let playerAnimationName: String = self.playerName + "_walking"
        super.entitesAnimated[self.playerName]?.glModel.animationController.loop((playerAnimationName, super.animations[playerAnimationName]!), reverse: true)
    }
    
    public func deactivateMoveLeft()
    {
        self.stopMoving()
        //self.moveLeft = false
        //super.entitesAnimated[self.playerName]?.glModel.animationController.stop()
    }
    
    public func activateMoveRight()
    {
        self.moveRight = true
        
        let playerAnimationName: String = self.playerName + "_walking"
        super.entitesAnimated[self.playerName]?.glModel.animationController.loop((playerAnimationName, super.animations[playerAnimationName]!))
    }
    
    public func deactivateMoveRight()
    {
        self.stopMoving()
        //self.moveRight = false
        //super.entitesAnimated[self.playerName]?.glModel.animationController.stop()
    }
    
    private func stopMoving()
    {
        self.moveLeft = false
        self.moveRight = false
        
        let animationPlaying = super.entitesAnimated[self.playerName]?.glModel.animationController.animation
        
        if (self.playerName + "_walking") == animationPlaying!
        {
            super.entitesAnimated[self.playerName]?.glModel.animationController.stop()
        }
    
    }
    
    public func punchButton()
    {
        self.stopMoving()
        
        let playerAnimationName: String = self.playerName + "_punch"
        super.entitesAnimated[self.playerName]?.glModel.animationController.play((playerAnimationName, super.animations[playerAnimationName]!))
    }
    
    public func kickButton()
    {
        self.stopMoving()
        
        let playerAnimationName: String = self.playerName + "_kick"
        super.entitesAnimated[self.playerName]?.glModel.animationController.play((playerAnimationName, super.animations[playerAnimationName]!))
    }
    
    public func blockButton()
    {
        self.stopMoving()
        
        let playerAnimationName: String = self.playerName + "_block"
        super.entitesAnimated[self.playerName]?.glModel.animationController.play((playerAnimationName, super.animations[playerAnimationName]!))
    }
}
