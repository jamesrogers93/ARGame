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
    private let startDistance: Float = 70.0
    
    public var player: FighterPlayer = FighterPlayer()
    public var enemy:  FighterAI = FighterAI()
    public var gameOver: Bool = false
    
    override init()
    {
        super.init()

        player.world = self
        enemy.world = self
    }
    
    override public func updateScene(delta: Double)
    {
        self.player.updateScene(delta: delta)
        self.enemy.updateScene(delta: delta)
    }
    
    public func setupGame()
    {
        // We know there is only one animated object in the scene
        // Retrieve it's name
        for (name, _) in super.entitesAnimated
        {
            self.player.name = name
            break
        }
        
        // We know the character is at the origin
        // Transform it to its start position
        super.entitesAnimated[self.player.name]?.translate(GLKVector3Make(-startDistance, 0.0, 0.0))
        super.entitesAnimated[self.player.name]?.rotate(1.5, GLKVector3Make(0.0, 1.0, 0.0))
        
        // Find a random enemy to fight
        /*let characters: Array<String> = ["beta", "x-bot", "y-bot", "ely", "ganfaul", "pumpkin", "vanguard"]
        while(true)
        {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            
            if !(self.player.name == characters[randomIndex])
            {
                self.enemyName = characters[randomIndex]
                break
            }
        }*/
        
        // Set enemy to beta_red
        self.enemy.name = "beta_red"
        
        // Now load enemy into scene
        let entityLoader: EntityLoader = EntityLoader()
        
        // Load character from file
        if(!entityLoader.loadEntityFromFile(self.enemy.name, self))
        {
            print("failed to load \(self.enemy.name)")
        }
    
        // And transform the enemy to it's starting position
        super.entitesAnimated[self.enemy.name]?.translate(GLKVector3Make(startDistance, 0.0, 0.0))
        super.entitesAnimated[self.enemy.name]?.rotate(-1.5, GLKVector3Make(0.0, 1.0, 0.0))
        
        // Set the players directions
        self.player.direction = 1
        self.enemy.direction = -1
        
        // Now load in the annimations for the 2 characters
        loadAllAnimations()
        
        // Now set the animations
        //let playerAnimationName: String = self.playerName + "_warming_up"
        var animationName: String = "beta_breathing_idle"
        super.entitesAnimated[self.player.name]?.glModel.animationController.play((animationName, super.animations[animationName]!), loop: true)
        
        //let enemyAnimationName: String = self.enemyName + "_warming_up"
        animationName = "beta_warming_up"
        super.entitesAnimated[self.enemy.name]?.glModel.animationController.play((animationName, super.animations[animationName]!), loop: true)
    }
    
    private func loadAllAnimations()
    {
        /*let characterAnimations: Array<String> = ["_breathing_idle", "_warming_up", "_walking"]
        
        for i in 0..<characterAnimations.count
        {
            // Append character name to animation to load correct one
            let playerAnimName = self.player.name + characterAnimations[i]
            
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
            
        }*/
        
        // Load aditional animations for prototyping
        var animation = ("beta_breathing_idle", AnimationLoader.loadAnimationFromFile("beta_breathing_idle", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_breathing_idle")
        }
        
        animation = ("beta_warming_up", AnimationLoader.loadAnimationFromFile("beta_warming_up", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_warming_up")
        }
        
        animation = ("beta_walking", AnimationLoader.loadAnimationFromFile("beta_walking", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_walking")
        }
        
        animation = ("beta_punch_1", AnimationLoader.loadAnimationFromFile("beta_punch_1", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_punch_1")
        }
        
        animation = ("beta_punch_2", AnimationLoader.loadAnimationFromFile("beta_punch_2", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_punch_2")
        }
        
        animation = ("beta_punch_3", AnimationLoader.loadAnimationFromFile("beta_punch_3", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_punch_3")
        }
        
        animation = ("beta_punch_4", AnimationLoader.loadAnimationFromFile("beta_punch_4", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_punch_4")
        }
        
        animation = ("beta_step", AnimationLoader.loadAnimationFromFile("beta_step", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_step")
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
        
        animation = ("beta_hit", AnimationLoader.loadAnimationFromFile("beta_hit", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_hit")
        }
        
        animation = ("beta_victory", AnimationLoader.loadAnimationFromFile("beta_victory", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_victory")
        }
        
        animation = ("beta_defeated", AnimationLoader.loadAnimationFromFile("beta_defeated", "bvh")!)
        if !(super.addAnimation(animation))
        {
            print("failed to load beta_defeated")
        }
    }
}
