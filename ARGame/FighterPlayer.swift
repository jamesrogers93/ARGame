//
//  FighterPlayer.swift
//  ARGame
//
//  Created by James Rogers on 14/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class FighterPlayer: Fighter
{
    
    override init()
    {
        super.init()
    }
    
    override public func updateScene(delta: Double)
    {
        super.updateScene(delta: delta)
        
        // Check if the player has won or loss
        if !super.isAlive()
        {
            super.lose()
        }
        else if !(super.world?.enemy.isAlive())!
        {
            super.win()
        }
        
        // Find distance between comabt limb and opponent
        if super.combatAction && super.canDamageFromAction
        {
            //self.distanceCombatLimbToOpponent = abs(self.activeCombatLimbPosition - (self.world?.entitesAnimated[(self.world?.enemy.name)!]?.position[0])!)
        
            if super.distanceToOpponent < 45.0
            {
                super.world?.enemy.hit(damage: self.strength)
                super.canDamageFromAction = false
            }
        }
    }
}
