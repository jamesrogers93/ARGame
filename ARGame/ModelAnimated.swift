//
//  ModelAnimated.swift
//  ARGame
//
//  Created by James Rogers on 21/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class ModelAnimated
{
    
    private var meshes: Array<MeshAnimated> = Array()
    private var animations: Array<AnimationSequence> = Array()
    private var currentAnimation: Int = 0
    private var skeleton: Skeleton = Skeleton()
    
    /**
     Initalise a Animated Model with an array of Meshes and animations.
     */
    init(_ _meshes: Array<MeshAnimated>, _ _animations: Array<AnimationSequence>, _ _skeleton: Skeleton)
    {
        self.animations = _animations
        self.meshes = _meshes
        self.skeleton = _skeleton
        
    }
    
    /**
     Draws the animated meshes in the Model.
     
     - parameters:
        - effect: The effect to draw the meshes.
     */
    public func draw(_ effect: EffectMatAnim)
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].draw(effect);
        }
    }
    
    /**
     Applies that animation transformations to the bones in the meshes.
     
     - parameters:
        - time: The time in seconds.
    */
    public func animate()
    {
        self.animations[self.currentAnimation].update()
        
        // Loop over meshes
        for i in 0..<self.meshes.count
        {
            
            self.meshes[i].animate(self.animations[self.currentAnimation], self.skeleton)
        }
    }
    
    /**
     Destroys the animated meshes.
     */
    public func destroy()
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].destroy();
        }
    }
}