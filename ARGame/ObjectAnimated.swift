//
//  ObjectAnimated.swift
//  ARGame
//
//  Created by James Rogers on 21/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

/**
 Holds a static Model and applies transformations to it.
 */
class ObjectAnimated
{
    /**
     The transformation model matrix.
     */
    private var model:GLKMatrix4 = GLKMatrix4Identity
    
    /**
     The translation matrix.
     */
    private var translation:GLKMatrix4 = GLKMatrix4Identity
    
    /**
     The scale matrix.
     */
    private var scale:GLKMatrix4 = GLKMatrix4Identity
    
    /**
     The rotation matrix.
     */
    private var rotation:GLKMatrix4 = GLKMatrix4Identity
    
    /**
     The model which contains the geometry.
     */
    private var GLmodel:ModelAnimated
    
    /**
     Initalise an object with a model.
     
     - parameters:
     - GLmodel: An instance of the type Model.
     */
    init(_ GLmodel: ModelAnimated)
    {
        self.GLmodel = GLmodel
    }
    
    /**
     Accessor method of the model instance.
     
     - returns:
     The model.
     */
    public func getModel() -> GLKMatrix4
    {
        return self.model
    }
    
    /**
     Updates the model matrix.
     */
    private func updateModel()
    {
        self.model = GLKMatrix4Multiply(GLKMatrix4Multiply(self.translation, self.rotation), self.scale)
    }
    
    /**
     Translates contents of the object.
     
     - parameters:
     - translation: A GLKVector3 instance which defines the translation on each xyz axis.
     
     This methods automatically updates the model matrix using the updateModel() method.
     */
    public func translate(_ translation: GLKVector3)
    {
        self.translation = GLKMatrix4TranslateWithVector3(GLKMatrix4Identity, translation)
        self.updateModel()
    }
    
    /**
     Rotates the contents object.
     
     - parameters:
     - rotation: The number of degrees to translate the object.
     - axis: A GLKVector3 instance which defines the rotation on each xyz axis.
     
     This methods automatically updates the model matrix using the updateModel() method.
     */
    public func rotate(_ rotation: Float, _ axis: GLKVector3)
    {
        self.rotation = GLKMatrix4RotateWithVector3(GLKMatrix4Identity, rotation, axis)
        self.updateModel()
    }
    
    /**
     Scales the contents object.
     
     - parameters:
     - scale: A GLKVector3 instance which defines the scale on each xyz axis.
     
     This methods automatically updates the model matrix using the updateModel() method.
     */
    public func scale(_ scale: GLKVector3)
    {
        self.scale = GLKMatrix4ScaleWithVector3(GLKMatrix4Identity, scale)
        self.updateModel()
    }
    
    /**
     Draws the contents of the object.
     
     - parameters:
     - effect: The effect to draw the contents.
     
     This function automatically places the contents of the object in the effect.
     */
    public func draw(_ effect: EffectMaterial)
    {
        effect.setModel(self.model)
        self.GLmodel.draw(effect)
    }
    
    /**
     Deletes the OpenGL data associated with this object.
     */
    public func destroy()
    {
        self.GLmodel.destroy()
    }
}
