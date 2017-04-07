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
    var duration: Float = 0.0
    var ticksPerSecond: Float = 0.0
    var channels: [String: AnimationChannel] = [String: AnimationChannel]()
    
    init(){}
    
    init(_ duration:Float, _ ticksPerSecond:Float, _ channels:[String: AnimationChannel])
    {
        self.duration = duration
        self.ticksPerSecond = ticksPerSecond
        self.channels = channels
    }
}

class AnimationPlayBack
{
    private var animationFrame: Int
    private var animationDuration: Float
    private var animationTicksPerSecond: Float
    private var previousTime: TimeInterval
    private var isPlay: Bool
    private var isLoop: Bool
    
    init(_ _animation: Animation)
    {
        self.animationFrame = 0
        self.animationDuration = _animation.duration
        self.animationTicksPerSecond = _animation.ticksPerSecond
        self.previousTime = 0.0
        self.isPlay = false
        self.isLoop = false
    }
    
    public func play()
    {
        self.restart(false)
    }
    
    public func loop()
    {
        self.restart(true)
    }
    
    private func restart(_ _loop: Bool)
    {
        self.isPlay = true
        self.isLoop = _loop
        
        self.animationFrame = 0
        self.previousTime = NSDate().timeIntervalSince1970
    }
    
    public func stop()
    {
        self.isPlay = false
    }
    
    private func update()
    {
        if self.isPlay
        {
            // Calculate time
            let time: TimeInterval = NSDate().timeIntervalSince1970 - self.previousTime
            let timef: Float = Float(time)
            
            if timef > (self.animationDuration / self.animationTicksPerSecond)
            {
                
                if self.isLoop
                {
                    // Reset the animation
                    self.loop()
                }
                else
                {
                    // Stop the animation
                    self.stop()
                }
            }
            else
            {
                
                // Calculate animation frame
                let timeInTicks: Float = timef * self.animationTicksPerSecond
        
                self.animationFrame = Int(timeInTicks)
            }
        }
    }
    
    public func getFrame() -> Int
    {
        self.update()
        
        if self.isPlay
        {
            return self.animationFrame
        }
        else
        {
            return -1
        }
        
    }
}
