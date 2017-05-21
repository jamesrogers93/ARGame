//
//  Fighter.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class Fighter {
    
    private static let DEFAULT_HEALTH: Int = 200
    private static let DEFAULT_STRENGTH: Int = 10
    private static let DEFAULT_WALK_SPEED: Double = 45.0
    private static let DEFAULT_DASH_SPEED: Double = 200.0
    private static let DEFAULT_ACTION_SPEED: Float = 2.0
    private static let DEFAULT_DIRECTION: Int = 1

    private var _name: String = ""
    private var _opponent: String = ""
    private var _world: FightGameScene? = nil
    private var _health: Int = DEFAULT_HEALTH
    private var _startHealth: Int = DEFAULT_HEALTH
    private var _strength: Int = DEFAULT_STRENGTH
    private var _walkSpeed: Double = DEFAULT_WALK_SPEED
    private var _dashSpeed: Double = DEFAULT_DASH_SPEED
    private var _actionSpeed: Float = DEFAULT_ACTION_SPEED
    private var _direction: Int = DEFAULT_DIRECTION
    private var _moveLeft: Bool = false
    private var _moveRight: Bool = false
    private var _dashLeft: Bool = false
    private var _dashRight: Bool = false
    private var _combatAction:Bool = false
    private var _canDamageFromAction: Bool = false
    private var _blocking: Bool = false
    private var _isHit: Bool = false
    private var _distanceToOpponent: Float = 0.0
    private var _hasWon: Bool = false
    private var _hasLoss: Bool = false
    
    var name: String
    {
        get
        {
            return self._name
        }
        set(newVal)
        {
            self._name = newVal
        }
    }
    
    var opponent: String
    {
        get
        {
            return self._opponent
        }
    }
    
    var world: FightGameScene?
    {
        get
        {
            return self._world
        }
        set(newVal)
        {
            self._world = newVal
        }
    }
    
    var moveLeft: Bool
    {
        get
        {
            return self._moveLeft
        }
    }
    
    var moveRight: Bool
    {
        get
        {
            return self._moveRight
        }
    }
    
    var dashLeft: Bool
    {
        get
        {
            return self._dashLeft
        }
    }
    
    var dashRight: Bool
    {
        get
        {
            return self._dashRight
        }
    }
    
    var combatAction: Bool
    {
        get
        {
            return self._combatAction
        }
    }
    
    var canDamageFromAction: Bool
    {
        get
        {
            return self._canDamageFromAction
        }
        set(newVal)
        {
            self._canDamageFromAction = newVal
        }
    }
    
    var blocking: Bool
    {
        get
        {
            return self._blocking
        }
    }
    
    var isHit: Bool
    {
        get
        {
            return self._isHit
        }
    }
    
    var walkSpeed: Double
    {
        get
        {
            return self._walkSpeed
        }
    }
    
    var dashSpeed: Double
    {
        get
        {
            return self._dashSpeed
        }
    }
    
    var actionSpeed: Float
    {
        get
        {
            return self._actionSpeed
        }
    }
    
    var direction: Int
    {
        get
        {
            return self._direction
        }
        
        set(newVal)
        {
            if newVal == -1 || newVal == 1
            {
                self._direction = newVal
            }
            else
            {
                print("Invalid direction. Must be -1 (Left) or 1 (Right)")
            }
        }
    }
    
    var distanceToOpponent: Float
    {
        get
        {
            return self._distanceToOpponent
        }
    }
    
    var health: Int
    {
        get
        {
            return self._health
        }
    }
    
    var startHealth: Int
    {
        get
        {
            return self._startHealth
        }
    }
    
    var strength: Int
    {
        get
        {
            return self._strength
        }
    }
    
    var hasWon: Bool
    {
        get
        {
            return self._hasWon
        }
    }
    
    var hasLoss: Bool
    {
        get
        {
            return self._hasLoss
        }
    }
    
    init()
    {
    }
    
    public func updateScene(delta: Double)
    {
        self._distanceToOpponent = abs((self.world?.entitesAnimated[(self.world?.player.name)!]?.position[0])! - (self.world?.entitesAnimated[(self.world?.enemy.name)!]?.position[0])!)
        
        if self.world != nil && !self._hasWon && !self._hasLoss
        {
            if distanceToOpponent < 30.0
            {
                if self._direction == 1
                {
                    self.stopMovingRight()
                }
                else
                {
                    self.stopMovingLeft()
                }
            }
            
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
        if !self.combatAction && self.world != nil && !self.moveLeft && !self.dashLeft && !self.dashRight && !self.isHit && !self._hasWon && !self._hasLoss
        {
            self._moveLeft = true
            
            let reverse: Bool = self._direction == 1 ? true : false
            
            let playerAnimationName: String = "beta_walking"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), loop: true, reverse: reverse, speed: 2.0)
        }
    }
    
    public func deactivateMoveLeft()
    {
        self.stopWalking()
    }
    
    public func activateMoveRight()
    {
        if !combatAction && self.world != nil && !self.moveRight  && !self.dashLeft && !self.dashRight && !self.isHit && !self._hasWon && !self._hasLoss
        {
            self._moveRight = true
            
            let reverse: Bool = self._direction == -1 ? true : false
            
            let playerAnimationName: String = "beta_walking"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), loop: true, reverse: reverse, speed: 2.0)
        }
    }
    
    public func deactivateMoveRight()
    {
        self.stopWalking()
    }
    
    private func stopWalking()
    {
        if self.world != nil
        {
            self._moveLeft = false
            self._moveRight = false
        
            let animationPlaying = self.world?.entitesAnimated[self.name]?.glModel.animationController.animation
        
            if "beta_walking" == animationPlaying!
            {
                self.world?.entitesAnimated[self.name]?.glModel.animationController.stop()
            }
        }
        
    }
    
    private func stopMovingLeft()
    {
        if self.world != nil && (self.moveLeft || self.dashLeft) && !self._hasWon && !self._hasLoss
        {
            self._moveLeft = false
            self._dashLeft = false
            
            let animationPlaying = self.world?.entitesAnimated[self.name]?.glModel.animationController.animation
            
            if "beta_walking" == animationPlaying! || "beta_step" == animationPlaying!
            {
                self.world?.entitesAnimated[self.name]?.glModel.animationController.stop()
            }
        }
    }
    
    private func stopMovingRight()
    {
        if self.world != nil && (self.moveRight || self.dashRight) && !self._hasWon && !self._hasLoss
        {
            self._moveRight = false
            self._dashRight = false
            
            let animationPlaying = self.world?.entitesAnimated[self.name]?.glModel.animationController.animation
            
            if "beta_walking" == animationPlaying! || "beta_step" == animationPlaying!
            {
                self.world?.entitesAnimated[self.name]?.glModel.animationController.stop()
            }
        }
    }
    
    public func activateDashLeft()
    {
        if !self.combatAction && self.world != nil && !self.blocking && !self.isHit && !self._hasWon && !self._hasLoss
        {
            self._dashLeft = true
            
            self.stopWalking()
            
            let reverse: Bool = self._direction == 1 ? true : false
            
            let playerAnimationName: String = "beta_step"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), reverse: reverse, speed: 3.0, completion: self.dashActionComplete)
        }
    }
    
    public func activateDashRight()
    {
        if !self.combatAction && self.world != nil && !self.blocking && !self.isHit && !self._hasWon && !self._hasLoss
        {
            
            self._dashRight = true
            
            self.stopWalking()
            
            let reverse: Bool = self._direction == -1 ? true : false
            let playerAnimationName: String = "beta_step"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), reverse: reverse, speed: 3.0, completion: self.dashActionComplete)
        }
    }
    
    public func punch()
    {
        if !combatAction && self.world != nil && !self.dashLeft && !self.dashRight && !self.blocking && !self.isHit && !self._hasWon && !self._hasLoss
        {
            // Set combat action flag
            self._combatAction = true
            
            self._canDamageFromAction = true
            
            self.stopWalking()
            
            // Choose random punch animation
            let randomIndex = Int(arc4random_uniform(UInt32(4)))+1
            let playerAnimationName: String = "beta_punch_\(randomIndex)"
            
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), speed: self.actionSpeed, completion: self.combatActionComplete)
            
        }
    }
    
    public func kick()
    {
        if !combatAction && self.world != nil && !self.dashLeft && !self.dashRight && !self.blocking && !self.isHit && !self._hasWon && !self._hasLoss
        {
            // Set combat action flag
            self._combatAction = true
            
            self._canDamageFromAction = true
            
            self.stopWalking()
            
            let playerAnimationName: String = "beta_kick"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), speed: self.actionSpeed, completion: self.combatActionComplete)
        }
    }
    
    public func block()
    {
        if !self.blocking && !self.combatAction && self.world != nil && !self.dashLeft && !self.dashRight && !self.isHit && !self._hasWon && !self._hasLoss
        {
            // Set blocking flag
            self._blocking = true
            
            self.stopWalking()
            
            let playerAnimationName: String = "beta_block"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), speed: self.actionSpeed, completion: self.blockingComplete)
        }
    }
    
    public func hit(damage: Int)
    {
        if self.world != nil && !self.blocking && !self._hasWon && !self._hasLoss
        {
            self._isHit = true
         
            self._blocking = false
            self._combatAction = false
            self.stopWalking()
            self._dashLeft = false
            self._dashRight = false
            
            self._health -= damage
            
            let playerAnimationName: String = "beta_hit"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), speed: 2.0, completion: self.hitComplete)
        }
    }
    
    public func isAlive() -> Bool
    {
        return self._health > 0
    }
    
    public func win()
    {
        if !self._hasWon && !self._hasLoss
        {
            self._hasWon = true
            
            let playerAnimationName: String = "beta_victory"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), loop: false, completion: victoryComplete)
        }
    }
    
    public func lose()
    {
        if !self._hasLoss && !self._hasWon
        {
            self._hasLoss = true
            
            let playerAnimationName: String = "beta_defeated"
            self.world?.entitesAnimated[self.name]?.glModel.animationController.play((playerAnimationName, (self.world?.animations[playerAnimationName]!)!), loop: false)
        }
    }
    
    public func combatActionComplete() -> Void
    {
        self._combatAction = false
        self._canDamageFromAction = false
    }
    
    public func blockingComplete() -> Void
    {
        self._blocking = false
    }
    
    public func hitComplete() -> Void
    {
        self._isHit = false
    }
    
    public func dashActionComplete() -> Void
    {
        self._combatAction = false
        self._dashLeft = false
        self._dashRight = false
    }
    
    public func victoryComplete() -> Void
    {
        self._world?.gameOver = true
    }
}
