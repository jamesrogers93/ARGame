//
//  STATEMoveToPlayer.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class STATEMoveToPlayer : STATE<FighterAI>
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
        
        // Check if we are too far to the left
        if (parent.world?.entitesAnimated[parent.name]?.position.x)! < Float(-40.0)
        {
            parent.activateMoveRight()
        }
        else if (parent.world?.entitesAnimated[parent.name]?.position.x)! < Float(-60.0)
        {
            parent.activateDashRight()
        }
        
        
        // First check is we want to move to player
        // Get distance between this player and the other
        else if parent.distanceToOpponent > 150
        {
            parent.activateDashLeft()
        }
        else if parent.distanceToOpponent > 45
        {
            parent.activateMoveLeft()
        }
        else
        {
            parent.deactivateMoveLeft()
            
            return FighterStates.S_COMBAT.rawValue
        }
        
        
        return FighterStates.S_MOVETOPLAYER.rawValue
    }
}
