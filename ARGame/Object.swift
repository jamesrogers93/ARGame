//
//  Object.swift
//  ARGame
//
//  Created by James Rogers on 16/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation
import GLKit

class Object
{
    private var model:GLKMatrix4 = GLKMatrix4Identity
    private var translate:GLKMatrix4 = GLKMatrix4Identity
    private var scale:GLKMatrix4 = GLKMatrix4Identity
    private var rotate:GLKMatrix4 = GLKMatrix4Identity
    
    private var mesh:Mesh
    
    init(_ mesh: Mesh)
    {
        self.mesh = mesh
    }
    
    public func getModel() -> GLKMatrix4
    {
        return self.model
    }
    
    private func updateModel()
    {
        self.model = GLKMatrix4Multiply(GLKMatrix4Multiply(self.translate, self.rotate), self.scale)
    }
    
    public func translate(_ translation: GLKVector3)
    {
        self.translate = GLKMatrix4TranslateWithVector3(GLKMatrix4Identity, translation)
        self.updateModel()
    }
    
    public func rotate(_ rotation: Float, _ axis: GLKVector3)
    {
        self.rotate = GLKMatrix4RotateWithVector3(GLKMatrix4Identity, rotation, axis)
        self.updateModel()
    }
    
    public func scale(_ scale: GLKVector3)
    {
        self.scale = GLKMatrix4ScaleWithVector3(GLKMatrix4Identity, scale)
        self.updateModel()
    }
    
    public func draw(_ effect: GLKBaseEffect?)
    {
        // Set model in renderer
        effect?.transform.modelviewMatrix = self.model
        
        self.mesh.draw(effect: effect)
    }
}








