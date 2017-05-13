//
//  FighterAI.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class FighterAI : Fighter
{
    private var brain: FSMFighter
    
    init(_ brain: FSMFighter)
    {
        self.brain = brain
    }
    
    public override func updateScene(delta: Double)
    {
        super.updateScene(delta: delta)
        
        self.brain.update()
    }
    
}
