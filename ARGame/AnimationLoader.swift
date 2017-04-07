//
//  AnimationLoader.swift
//  ARGame
//
//  Created by James Rogers on 07/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class AnimationLoader
{
    /**
     Loads an animation from file using the Assimp library.
     
     - parameters:
        - resource: Name of the resource to be loaded.
        - type: The type of object to be loaded eg. fbx.
     
     - returns:
     The loaded animation.
     */
    static public func loadAnimationFromFile(_ resource: String, _ type: String) -> Animation?
    {
        // Find path of resource
        let path = Bundle.main.path(forResource: resource, ofType: type)
        
        // Convert path to C string
        let cpath = path?.cString(using: .utf8)
        
        // Load model using C code
        let loader = UnsafeRawPointer(mlLoadAssimpAnimation(cpath))
        
        // Extract the animations from the assimp loader
        let animation: Animation? = extractAnimationFromLoader(loader!)
        
        // Destroy assimp model
        mlDestroyAssimpLoader(loader)
        
        return animation
    }
    
    /**
     Extracts a animation array from the assimp loader class.
     
     - parameters:
        - loader: An unsafe pointer to the C++ AssimpModelLoader object.
     
     - returns:
     The animation.
     */
    static private func extractAnimationFromLoader(_ loader:UnsafeRawPointer) -> Animation?
    {
        
        // Get number of animations loaded
        let numAnimations: UInt32 = mlGetNumAnimations(loader)
        
        // Load animation
        if numAnimations > 0
        {
            var i: UInt32 = 0
            
            //
            // Load animation duration
            //
            let duration: Float = mlGetAnimationDuration(loader, i)
            
            //
            // Load animation ticks per second
            //
            let ticksPerSecond: Float = mlGetAnimationTicksPerSecond(loader, i)
            
            //
            // Load animation channels
            //
            var channels = [String: AnimationChannel]()
            let numChannels: UInt32 = mlGetNumChannelsInAnimation(loader, i)
            
            for j in 0..<numChannels
            {
                // Load channel name
                let name: String = String(cString: mlGetAnimationChannelName(loader, i, j))
                
                // load channel positions
                var positions:Array<GLKVector3> = Array()
                let numPositions: Int = Int(mlGetNumPositionsInChannel(loader, i, j))
                var cPositions = Array(UnsafeBufferPointer(start: mlGetAnimationChannelPositions(loader, i, j), count: numPositions))
                
                for k in stride(from: 0, to: numPositions, by: 3)
                {
                    positions.append(GLKVector3Make(cPositions[k], cPositions[k+1], cPositions[k+2]))
                }
                
                // load channel positions
                var scales:Array<GLKVector3> = Array()
                let numScales: Int = Int(mlGetNumScalesInChannel(loader, i, j))
                var cScales = Array(UnsafeBufferPointer(start: mlGetAnimationChannelScales(loader, i, j), count: numScales))
                
                for k in stride(from: 0, to: numScales, by: 3)
                {
                    scales.append(GLKVector3Make(cScales[k], cScales[k+1], cScales[k+2]))
                }
                
                // load channel rotations
                var rotations:Array<GLKMatrix3> = Array()
                let numRotations: Int = Int(mlGetNumRotationsInChannel(loader, i, j))
                var cRotations = Array(UnsafeBufferPointer(start: mlGetAnimationChannelRotations(loader, i, j), count: numRotations))
                
                for k in stride(from: 0, to: numRotations, by: 9)
                {
                    var rot: GLKMatrix3 = GLKMatrix3Make(cRotations[k], cRotations[k+3], cRotations[k+6],
                                                         cRotations[k+1], cRotations[k+4], cRotations[k+7],
                                                         cRotations[k+2], cRotations[k+5], cRotations[k+8])
                    
                    // Transpose matrix to change from assimps row major to GLKits column major
                    rot = GLKMatrix3Transpose(rot)
                    
                    // Put rotation matrix in array
                    rotations.append(rot)
                }
                
                // Insert channel into channels
                channels[name] = AnimationChannel(positions, scales, rotations)
                //channels.append(AnimationChannel(name, positions, scales, rotations))
            }
            
            // Return animation
            return Animation(duration, ticksPerSecond, channels)
        }
        
        return nil
    }
}
