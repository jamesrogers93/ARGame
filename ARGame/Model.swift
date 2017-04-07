//
//  Model.swift
//  ARGame
//
//  Created by James Rogers on 07/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

/**
 Maintains an array of Meshes that are associated with each other.
 */
class ModelStatic
{
    private var meshes: Array<MeshStatic> = Array()
    
    /**
     Initalise a Model with an array of Meshes.
     */
    init(_ meshes: Array<MeshStatic>)
    {
        self.meshes = meshes
    }
    
    /**
     Draws the meshes in the Model.
     
     - parameters:
        - effect: The effect to draw the meshes.
     */
    public func draw(_ effect: EffectMaterial)
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].draw(effect);
        }
    }
    
    /**
     Destroys the meshes.
     */
    public func destroy()
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].destroy();
        }
    }
}

class ModelAnimated
{
    
    private var meshes: Array<MeshAnimated> = Array()
    private var skeleton: Skeleton = Skeleton()
    private var _animationController: AnimationPlayBack = AnimationPlayBack()
    
    /**
     Initalise a Animated Model with an array of Meshes and animations.
     */
    init(_ _meshes: Array<MeshAnimated>, _ _skeleton: Skeleton)
    {
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
    public func animate(_ animation: Animation, _ animationFrame: Int)
    {
        // Loop over meshes
        for i in 0..<self.meshes.count
        {
            self.meshes[i].animate(animation, animationFrame, self.skeleton)
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
    
    public var animationController: AnimationPlayBack
    {
        get
        {
            return self._animationController
        }
        
        set
        {
            self._animationController = newValue
        }
    }
}
