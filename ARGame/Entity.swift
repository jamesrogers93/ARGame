//
//  Entity.swift
//  ARGame
//
//  Created by James Rogers on 06/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

/**
 Holds a Model and applies transformations to it.
 */
class Entity
{
    /**
     The transformation model matrix.
     */
    private var _model:GLKMatrix4 = GLKMatrix4Identity
    
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
    Constructor is file private
    */
    fileprivate init() {}
    
    /**
     Accessor method for the model matrix
    */
    public var model: GLKMatrix4
    {
        get
        {
            return self._model
        }
    }
    
    /**
     Updates the model matrix.
     */
    private func updateModelMatrix()
    {
        self._model = GLKMatrix4Multiply(GLKMatrix4Multiply(self.translation, self.rotation), self.scale)
    }
    
    /**
     Translates contents of the object.
     
     - parameters:
        - translation: A GLKVector3 instance which defines the translation on each xyz axis.
     
     This methods automatically updates the model matrix using the updateModelMatrix() method.
     */
    public func translate(_ translation: GLKVector3)
    {
        self.translation = GLKMatrix4TranslateWithVector3(GLKMatrix4Identity, translation)
        self.updateModelMatrix()
    }
    
    /**
     Rotates the contents object.
     
     - parameters:
        - rotation: The number of degrees to translate the object.
        - axis: A GLKVector3 instance which defines the rotation on each xyz axis.
     
     This methods automatically updates the model matrix using the updateModelMatrix() method.
     */
    public func rotate(_ rotation: Float, _ axis: GLKVector3)
    {
        self.rotation = GLKMatrix4RotateWithVector3(GLKMatrix4Identity, rotation, axis)
        self.updateModelMatrix()
    }
    
    /**
     Scales the contents object.
     
     - parameters:
        - scale: A GLKVector3 instance which defines the scale on each xyz axis.
     
     This methods automatically updates the model matrix using the updateModelMatrix() method.
     */
    public func scale(_ scale: GLKVector3)
    {
        self.scale = GLKMatrix4ScaleWithVector3(GLKMatrix4Identity, scale)
        self.updateModelMatrix()
    }
    
}


class EntityStatic : Entity
{
    /**
     The OpenGL geometry
     */
    private let _glModel: ModelStatic
    
    /**
     Initalise an object with a model.
     
     - parameters:
        - glModel: An instance of the type Model.
     */
    public init(_ glModel: ModelStatic)
    {
        self._glModel = glModel
        
        super.init()
    }
    
    /**
     Accesses the ModelStatic instance
     
     - returns:
     The ModelStatic instance
    */
    var glModel: ModelStatic {
        get
        {
            return self._glModel
        }
    }
}


class EntityAnimated : Entity
{
    /**
     The OpenGL geometry
     */
    private let _glModel: ModelAnimated
    
    /**
     Initalise an object with a model.
     
     - parameters:
        - glModel: An instance of the type Model.
     */
    public init(_ glModel: ModelAnimated)
    {
        self._glModel = glModel
        
        super.init()
    }
    
    /**
     Accesses the ModelAnimated instance
     
     - returns:
     The ModelAnimated instance
     */
    var glModel: ModelAnimated {
        get
        {
            return self._glModel
        }
    }
}
