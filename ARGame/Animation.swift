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
    var positions:Array<GLKVector3> = Array()
    var scalings:Array<GLKVector3> = Array()
    var rotations:Array<GLKMatrix3> = Array()
    
    init() {}
    
    init(_ positions:Array<GLKVector3>, _ scalings:Array<GLKVector3>, _ rotations:Array<GLKMatrix3>)
    {
        self.positions = positions
        self.scalings = scalings
        self.rotations = rotations
    }
}

struct Animation
{
    var duration:Float = 0.0
    var ticksPerSecond:Float = 0.0
    var channels:[String: AnimationChannel] = [String: AnimationChannel]()
    
    init(){}
    
    init(_ duration:Float, _ ticksPerSecond:Float, _ channels:[String: AnimationChannel])
    {
        self.duration = duration
        self.ticksPerSecond = ticksPerSecond
        self.channels = channels
    }
}

class AnimationSequence
{
    private var animation: Animation
    private var animationFrame: Int
    private var previousTime: TimeInterval
    private var restart: Bool
    
    init(_ _animation: Animation)
    {
        self.animation = _animation
        self.animationFrame = 0
        self.previousTime = 0.0
        self.restart = true
    }
    
    public func start()
    {
        self.animationFrame = 0
        self.previousTime = NSDate().timeIntervalSince1970
        self.restart = false
    }
    
    public func update()
    {
        if self.restart
        {
            self.start()
        }
        
        // Calculate time
        let time: TimeInterval = NSDate().timeIntervalSince1970 - self.previousTime
        let timef: Float = Float(time)
            
        if timef > (self.animation.duration / self.animation.ticksPerSecond)
        {
            // Reset the animation
            self.start()
                
        }
        else
        {
            //self.previousTime = time
                
            // Calculate animation frame
            let timeInTicks: Float = timef * self.animation.ticksPerSecond
        
            self.animationFrame = Int(timeInTicks)
        }
    }
    
    public func getChannel(_ name: String) -> AnimationChannel?
    {
        return self.animation.channels[name]
    }
    
    public func getFrame() -> Int
    {
        return self.animationFrame
    }
}
