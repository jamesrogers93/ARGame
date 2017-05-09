//
//  FirstScene.swift
//  ARGame
//
//  Created by James Rogers on 07/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class CharacterSelectionScene : Scene
{
    
    let character: Array<String> = ["beta", "x-bot", "y-bot", "ely", "ganfaul", "pumpkin", "vanguard"]
    var currentSelection = 0
    
    override init()
    {
        
    }
 
    override public func updateScene()
    {
        
        
        //print("BALLS")
    }
    
    public func previousCharacter()
    {
        print("Previous Character")
    }
    
    public func nextCharacter()
    {
        print("Next Character")
    }
    
}
