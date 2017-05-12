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
    private var animationName: String = ""
    private var animationFrame: Int = 0
    private var animationDuration: Float = 0.0
    private var animationTicksPerSecond: Float = 0.0
    private var previousTime: TimeInterval = 0.0
    private var isPlay: Bool = false
    private var isLoop: Bool = false
    private var reverse: Bool = false
    
    public func play(_ animation:(String, Animation), reverse: Bool = false)
    {
        self.initalise(animation)
        self.reverse = reverse
        
        self.restart(false)
    }
    
    public func loop(_ animation:(String, Animation), reverse: Bool = false)
    {
        self.initalise(animation)
        self.reverse = reverse
        self.restart(true)
    }
    
    public func stop()
    {
        self.isPlay = false
    }
    
    public var frame:Int
    {
        get
        {
            self.update()
        
            return self.animationFrame
        }
    }
    
    public var animation:String
    {
        get
        {
            return self.animationName
        }
    }
    
    public var isPlaying:Bool
    {
        get
        {
            return self.isPlay
        }
    }
    
    private func restart(_ _loop: Bool)
    {
        self.isPlay = true
        self.isLoop = _loop
        
        self.animationFrame = 0
        self.previousTime = NSDate().timeIntervalSince1970
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
                    self.restart(true)
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
        
                if self.reverse
                {
                    self.animationFrame = Int(self.animationDuration - timeInTicks)
                }
                else
                {
                    self.animationFrame = Int(timeInTicks)
                }
            }
        }
    }
    
    private func initalise(_ animation:(String, Animation))
    {
        self.animationName = animation.0
        self.animationFrame = 0
        self.animationDuration = animation.1.duration
        self.animationTicksPerSecond = animation.1.ticksPerSecond
        self.previousTime = 0.0
        self.isPlay = false
        self.isLoop = false
    }
}
