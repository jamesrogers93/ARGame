//
//  AnimationSet.swift
//  ARGame
//
//  Created by James Rogers on 16/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class AnimationSet
{
    private var animations:Array<Animation> = Array()
    
    init(){}
    
    init(_ animations: Array<Animation>)
    {
        self.animations = animations
    }
}
