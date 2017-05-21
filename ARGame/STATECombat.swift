//
//  STATEAttack.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class STATECombat : STATE<FighterAI>
{

    override public func run(parent: FighterAI) -> Int
    {
        // Check if AI has won or loss
        if !parent.isAlive()
        {
            return FighterStates.S_LOSE.rawValue
        }
        else if !(parent.world?.player.isAlive())!
        {
            return FighterStates.S_WIN.rawValue
        }
        
        if parent.waitCount <= parent.difficulty.rawValue
        {
            parent.waitCount += 1
        }
        else
        {
            parent.waitCount = 0
            
            if parent.distanceToOpponent > 45
            {
                return FighterStates.S_MOVETOPLAYER.rawValue
            }
            else
            {
                // If the opponent is attacking
                if (parent.world?.player.combatAction)!
                {
                    // Randomly block or dash right
                    let randomIndex = Int(arc4random_uniform(UInt32(2)))
            
                    if randomIndex != 0
                    {
                        // Block
                        parent.block()
                    }
                    else
                    {
                        // Dash right
                        parent.activateDashRight()
                    }
                }
                else
                {
                    // Choose random attack
                    let randomIndex = Int(arc4random_uniform(UInt32(4)))
                
                    if randomIndex != 0
                    {
                        // Punch
                        parent.punch()
                    }
                    else
                    {
                        // Kick
                        parent.kick()
                    }
                }
            }
        }
        
        return FighterStates.S_COMBAT.rawValue
    }
}
