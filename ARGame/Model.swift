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
    private var _meshes: Array<MeshStatic> = Array()
    
    /**
     Initalise a Model with an array of Meshes.
     */
    init(_ _meshes: Array<MeshStatic>)
    {
        self._meshes = _meshes
    }
    
    /**
     Draws the meshes in the Model.
     
     - parameters:
        - effect: The effect to draw the meshes.
     */
    public func draw(_ effect: EffectMaterial)
    {
        for i in 0..<self._meshes.count
        {
            self._meshes[i].draw(effect);
        }
    }
    
    /**
     Destroys the meshes.
     */
    public func destroy()
    {
        for i in 0..<self._meshes.count
        {
            self._meshes[i].destroy();
        }
    }
    
    public func updateModelVAO()
    {
        // Loop over meshes
        for i in 0..<self._meshes.count
        {
            self._meshes[i].setupVAO()
        }
    }
}

class ModelAnimated
{
    
    private var _meshes: Array<MeshAnimated> = Array()
    private var _skeleton: Skeleton = Skeleton()
    private var _animationController: AnimationPlayBack = AnimationPlayBack()
    
    /**
     Initalise a Animated Model with an array of Meshes and animations.
     */
    init(_ _meshes: Array<MeshAnimated>, _ _skeleton: Skeleton)
    {
        self._meshes = _meshes
        self._skeleton = _skeleton
        
    }
    
    /**
     Draws the animated meshes in the Model.
     
     - parameters:
        - effect: The effect to draw the meshes.
     */
    public func draw(_ effect: EffectMatAnim)
    {
        for i in 0..<self._meshes.count
        {
            self._meshes[i].draw(effect);
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
        self.animate(animation, animationFrame, self._skeleton)
    }
    
    var testInverseMatrix: GLKMatrix4 = GLKMatrix4Identity
    private func animate(_ animation: Animation, _ animationFrame: Int, _ skeleton: Skeleton)
    {
        let testBool: UnsafeMutablePointer<Bool>? = nil
        testInverseMatrix = GLKMatrix4Invert(skeleton.transformation, testBool)
        self.processSkeletonHierarchy(animation, animationFrame, skeleton, GLKMatrix4Identity)
    }
    
    private func processSkeletonHierarchy(_ animation:Animation, _ animationFrame: Int, _ skeleton: Skeleton, _ parentTransformation: GLKMatrix4)
    {
        
        //var nodeTransformation: GLKMatrix4 = GLKMatrix4Identity
        var nodeTransformation: GLKMatrix4 = skeleton.transformation
        
        // Get animation channel from dictonary O(1) access complexity
        let channel = animation.channels[skeleton.name]
        
        if channel != nil
        {
            // Do transformation stuff
            let position: GLKVector3
            let scale: GLKVector3
            let rotation: GLKMatrix3
            
            //position = GLKVector3Make(0.0,0.0,0.0)
            //position = (channel?.positions[0])!
            
            //scale = GLKVector3Make(1.0,1.0,1.0)
            //scale = (channel?.scalings[0])!
            
            //rotation = GLKMatrix3Identity
            //rotation = (channel?.rotations[0])!
            
            
            // Get the position, scale and rotation data from the channel
            
            if (channel?.positions.count)! > animationFrame
            {
                position = (channel?.positions[animationFrame])!
            }
            else if (channel?.positions.count)! == 1
            {
                position = (channel?.positions[0])!
                //position = GLKVector3Make(0.0, 0.0, 0.0)
            }
            else
            {
                position = GLKVector3Make(0.0, 0.0, 0.0)
            }
            
            if (channel?.scalings.count)! > animationFrame
            {
                scale = (channel?.scalings[animationFrame])!
            }
            else if (channel?.scalings.count)! == 1
            {
                scale = (channel?.scalings[0])!
            }
            else
            {
                scale = GLKVector3Make(0.0, 0.0, 0.0)
            }
            
            if (channel?.rotations.count)! > animationFrame
            {
                rotation = (channel?.rotations[animationFrame])!
            }
            else
            {
                rotation = GLKMatrix3Identity
            }
            
            // Put into matrices
            let tranMat: GLKMatrix4 = GLKMatrix4TranslateWithVector3(GLKMatrix4Identity, position)
            let scalMat: GLKMatrix4 = GLKMatrix4ScaleWithVector3(GLKMatrix4Identity, scale)
            let rotMat: GLKMatrix4 = GLKMatrix4Make(
                rotation[0], rotation[3], rotation[6], 0.0,
                rotation[1], rotation[4], rotation[7], 0.0,
                rotation[2], rotation[5], rotation[8], 0.0,
                0.0,         0.0,         0.0,         1.0)
            
            // Transform bone
            //nodeTransformation = GLKMatrix4Add(nodeTransformation, GLKMatrix4Multiply(GLKMatrix4Multiply(tranMat, rotMat), scalMat))
            
            nodeTransformation = GLKMatrix4Multiply(GLKMatrix4Multiply(tranMat, rotMat), scalMat)
            
        }
        
        // Find global transformation
        let globalTransformation: GLKMatrix4 = GLKMatrix4Multiply(parentTransformation, nodeTransformation)
        
        // Recursively process the remaining child nodes
        for i in 0..<skeleton.children.count
        {
            self.processSkeletonHierarchy(animation, animationFrame, skeleton.children[i], globalTransformation)
        }
        
        for i in 0..<self._meshes.count
        {
            // Get bone index from dictonary O(1) access complexity
            if let index = self._meshes[i].boneIndex[skeleton.name]
            {
                // Apply transformation if bone exists
                self._meshes[i]._bones[index].transform = GLKMatrix4Multiply(testInverseMatrix, GLKMatrix4Multiply(globalTransformation, self._meshes[i]._bones[index].offset))
                //self.bones[index].transform =  globalTransformation
            }
        }
    }
    
    /**
     Destroys the animated meshes.
     */
    public func destroy()
    {
        for i in 0..<self._meshes.count
        {
            self._meshes[i].destroy();
        }
    }
    
    public func updateModelVAO()
    {
        // Loop over meshes
        for i in 0..<self._meshes.count
        {
            self._meshes[i].setupVAO()
        }
    }
    
    public var meshes: Array<MeshAnimated>
    {
        get
        {
            return self._meshes
        }
    }
    
    public var skeleton: Skeleton
    {
        get
        {
            return self._skeleton
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
