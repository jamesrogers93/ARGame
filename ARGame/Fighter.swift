//
//  Fighter.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class Fighter {

    public var name: String = ""
    public var world: Scene? = nil
    public var moveLeft: Bool = false
    public var moveRight: Bool = false
    public var dashLeft: Bool = false
    public var dashRight: Bool = false
    public var combatAction:Bool = false
    public var walkSpeed: Double = 45.0
    public var dashSpeed: Double = 200.0
    public var actionSpeed: Float = 2.0

    init()
    {
    }
    
    public func updateScene(delta: Double)
    {
        if self.world != nil
        {
            if self.dashLeft
            {
                self.world?.entitesAnimated[self.name]?.translate(GLKVector3MultiplyScalar(GLKVector3Make(-1.0, 0.0, 0.0), Float(self.dashSpeed * delta)))
            }
            else if self.dashRight
            {
                self.world?.entitesAnimated[self.name]?.translate(GLKVector3MultiplyScalar(GLKVector3Make(1.0, 0.0, 0.0), Float(self.dashSpeed * delta)))
            }
            else if self.moveRight
            {
                self.world?.entitesAnimated[self.name]?.translate(GLKVector3MultiplyScalar(GLKVector3Make(1.0, 0.0, 0.0), Float(self.walkSpeed * delta)))
            }
            else if self.moveLeft
            {
                self.world?.entitesAnimated[self.name]?.translate(GLKVector3MultiplyScalar(GLKVector3Make(-1.0, 0.0, 0.0), Float(self.walkSpeed * delta)))
            }
        }
    }
    
    public func activateMoveLeft()
    {
        if !self.combatAction && self.world != nil
        {
            self.moveLeft = true
            
            //let playerAnimationName: String = self.name + "_walking"
            let playerAnimationName: String = "beta_walking"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), loop: true, reverse: true, speed: 2.0)
        }
    }
    
    public func deactivateMoveLeft()
    {
        self.stopMoving()
    }
    
    public func activateMoveRight()
    {
        if !combatAction && self.world != nil
        {
            self.moveRight = true
            
            //let playerAnimationName: String = self.name + "_walking"
            let playerAnimationName: String = "beta_walking"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), loop: true, speed: 2.0)
        }
    }
    
    public func deactivateMoveRight()
    {
        self.stopMoving()
    }
    
    private func stopMoving()
    {
        if self.world != nil
        {
            self.moveLeft = false
            self.moveRight = false
        
            let animationPlaying = self.world?.entitesAnimated[self.name]?.glModel.animationController.animation
        
            //if (self.name + "_walking") == animationPlaying!
            if ("beta_walking") == animationPlaying!
            {
                self.world?.entitesAnimated[self.name]?.glModel.animationController.stop()
            }
        }
        
    }
    
    public func activateDashLeft()
    {
        if !self.combatAction && self.world != nil
        {
            // Set combat action flag
            self.combatAction = true
            
            self.dashLeft = true
            
            self.stopMoving()
            
            //let playerAnimationName: String = self.name + "_step"
            let playerAnimationName: String = "beta_step"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), reverse: true, speed: 3.0, completion: self.dashActionComplete)
        }
    }
    
    public func activateDashRight()
    {
        if !self.combatAction && self.world != nil
        {
            // Set combat action flag
            self.combatAction = true
            
            self.dashRight = true
            
            self.stopMoving()
            
            //let playerAnimationName: String = self.name + "_step"
            let playerAnimationName: String = "beta_step"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), speed: 3.0, completion: self.dashActionComplete)
        }
    }
    
    public func punchButton()
    {
        if !combatAction && self.world != nil
        {
            // Set combat action flag
            self.combatAction = true
            
            self.stopMoving()
            
            // Choose random punch animation
            let randomIndex = Int(arc4random_uniform(UInt32(4)))
            //let playerAnimationName: String = self.name + "_punch_\(randomIndex+1)"
            let playerAnimationName: String = "beta_punch_\(randomIndex+1)"
            
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), speed: self.actionSpeed, completion: self.combatActionComplete)
            
        }
    }
    
    public func kickButton()
    {
        if !combatAction && self.world != nil
        {
            // Set combat action flag
            self.combatAction = true
            
            self.stopMoving()
            
            //let playerAnimationName: String = self.name + "_kick"
            let playerAnimationName: String = "beta_kick"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), speed: self.actionSpeed, completion: self.combatActionComplete)
        }
    }
    
    public func blockButton()
    {
        if !combatAction && self.world != nil
        {
            // Set combat action flag
            self.combatAction = true
            
            self.stopMoving()
            
            //let playerAnimationName: String = self.name + "_block"
            let playerAnimationName: String = "beta_block"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), speed: self.actionSpeed, completion: self.combatActionComplete)
        }
    }
    
    public func combatActionComplete() -> Void
    {
        self.combatAction = false
    }
    
    public func dashActionComplete() -> Void
    {
        self.combatAction = false
        self.dashLeft = false
        self.dashRight = false
    }
}
