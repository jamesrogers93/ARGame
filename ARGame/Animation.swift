//
//  Animation.swift
//  ARGame
//
//  Created by James Rogers on 16/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

struct AnimationChannel
{
    var name:String = ""
    var positions:Array<GLKVector3> = Array()
    var scalings:Array<GLKVector3> = Array()
    var rotations:Array<GLKMatrix3> = Array()
    
    init() {}
    
    init(_ name:String, _ positions:Array<GLKVector3>, _ scalings:Array<GLKVector3>, _ rotations:Array<GLKMatrix3>)
    {
        self.name = name
        self.positions = positions
        self.scalings = scalings
        self.rotations = rotations
    }
}

class Animation
{
    private var duration:Double = 0.0
    private var ticksPerSecond:Double = 0.0
    private var channels:Array<AnimationChannel> = Array()
    
    init(){}
    
    init(_ duration:Double, _ ticksPerSecond:Double, _ channels:Array<AnimationChannel>)
    {
        self.duration = duration
        self.ticksPerSecond = ticksPerSecond
        self.channels = channels
    }
    
}
