//
//  VertexData.swift
//  ARGame
//
//  Created by James Rogers on 23/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

struct Vector4i
{
    var x:GLint, y:GLint, z:GLint, w:GLint
    
    init(_ _i:GLint)
    {
        self.x = _i; self.y = _i; self.z = _i; self.w = _i
    }
    
    init(_ _x:GLint, _ _y:GLint, _ _z:GLint, _ _w:GLint)
    {
        self.x = _x; self.y = _y; self.z = _z; self.w = _w
    }
    
    subscript(index:Int) -> GLint {
        get {
            switch(index)
            {
            case 0:
                return self.x
            case 1:
                return self.y
            case 2:
                return self.z
            case 3:
                return self.w
            default:
                print("Out of bounds")
            }
            return 0
        }
        set(val) {
            switch(index)
            {
            case 0:
                self.x = val 
            case 1:
                self.y = val 
            case 2:
                self.z = val 
            case 3:
                self.w = val
            default:
                print("Out of bounds")
            }
        }
    }
}

struct Vector4f
{
    var x:GLfloat, y:GLfloat, z:GLfloat, w:GLfloat
    
    init(_ _i:GLfloat)
    {
        self.x = _i; self.y = _i; self.z = _i; self.w = _i
    }
    
    init(_ _x:GLfloat, _ _y:GLfloat, _ _z:GLfloat, _ _w:GLfloat)
    {
        self.x = _x; self.y = _y; self.z = _z; self.w = _w
    }
    
    subscript(index:Int) -> GLfloat {
        get {
            switch(index)
            {
            case 0:
                return self.x
            case 1:
                return self.y
            case 2:
                return self.z
            case 3:
                return self.w
            default:
                print("Out of bounds")
            }
            return 0.0
        }
        set(val) {
            switch(index)
            {
            case 0:
                self.x = val
            case 1:
                self.y = val
            case 2:
                self.z = val
            case 3:
                self.w = val
            default:
                print("Out of bounds")
            }
        }
    }
}

struct Vertex
{
    var position: GLKVector3 = GLKVector3Make(0.0, 0.0, 0.0)
    var normal: GLKVector3 = GLKVector3Make(0.0, 0.0, 0.0)
    var texCoord: GLKVector2 = GLKVector2Make(0.0, 0.0)
    
    init()
    {}
    
    init(_ position: GLKVector3, _ normal: GLKVector3, _ texCoord: GLKVector2)
    {
        self.position = position
        self.normal = normal
        self.texCoord = texCoord
    }
};

struct VertexAnimated
{
    var position: GLKVector3 = GLKVector3Make(0.0, 0.0, 0.0)
    var normal: GLKVector3 = GLKVector3Make(0.0, 0.0, 0.0)
    var texCoord: GLKVector2 = GLKVector2Make(0.0, 0.0)
    var boneIds: Vector4i = Vector4i(0, 0, 0, 0)
    var boneWeights: Vector4f = Vector4f(0.0, 0.0, 0.0, 0.0)
    
    
    init()
    {}
    
    init(_ _position: GLKVector3, _ _normal: GLKVector3, _ _texCoord: GLKVector2, _ _boneIds: Vector4i, _ _boneWeights: Vector4f)
    {
        self.position = _position
        self.normal = _normal
        self.texCoord = _texCoord
        self.boneIds = _boneIds
        self.boneWeights = _boneWeights
    }
    
    init(_ _vertex: Vertex, _ _boneIds: Vector4i = Vector4i(0), _ _boneWeights: Vector4f = Vector4f(0.0, 0.0, 0.0, 0.0))
    {
        self.init(_vertex.position, _vertex.normal, _vertex.texCoord, _boneIds, _boneWeights)
    }
};
