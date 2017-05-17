//
//  FighterAI.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

enum FighterAIDifficulty: Int
{
    case AI_EASY = 30
    case AI_NORMAL = 20
    case AI_HARD = 10
}

class FighterAI : Fighter
{
    private static var DIFFICULTY: FighterAIDifficulty = .AI_NORMAL
    private static let STRENGTH: [Int: Int] = [FighterAIDifficulty.AI_EASY.rawValue: 5,FighterAIDifficulty.AI_NORMAL.rawValue: 10, FighterAIDifficulty.AI_HARD.rawValue: 20 ]
    
    private var _brain: FSMFighter? = nil
    private var _difficulty: FighterAIDifficulty = DIFFICULTY
    private var _waitCount: Int = 0
    
    var difficulty: FighterAIDifficulty
    {
        get
        {
            return self._difficulty
        }
        
        set(newVal)
        {
            self._difficulty = newVal
        }
    }
    
    var waitCount: Int
    {
        get
        {
            return self._waitCount
        }
        set(newVal)
        {
            self._waitCount = newVal
        }
    }
    
    override init()
    {
        super.init()
        
        self._brain = FSMFighter(parent: self)
        
    }
    
    public override func updateScene(delta: Double)
    {
        super.updateScene(delta: delta)
        
        self._brain?.update()
    
        if super.distanceToOpponent < 45.0 && super.combatAction && super.canDamageFromAction
        {
            super.world?.player.hit(damage: FighterAI.STRENGTH[self.difficulty.rawValue]!)
            super.canDamageFromAction = false
        }
    }
}
