//
//  FSMFighter.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class FSMFighter : FSM<FighterAI>
{
    
    init(parent: FighterAI)
    {
        super.init(parent)
        
        // Add the states to the
        super.addState(STATECombat())
        super.addState(STATEMoveToPlayer())
        super.addState(STATEWin())
        super.addState(STATELose())
        
        // Set the current state
        super.currentState = FighterStates.S_MOVETOPLAYER.rawValue
    }
}
