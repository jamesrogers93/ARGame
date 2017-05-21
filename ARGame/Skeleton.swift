//
//  NodeData.swift
//  ARGame
//
//  Created by James Rogers on 04/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

struct Skeleton
{
    var name: String = ""
    var children: Array<Skeleton> = Array()
    var transformation: GLKMatrix4 = GLKMatrix4Identity
    
    init()
    {}
    
    init(_ _name: String, _ _children: Array<Skeleton>, _ _transformation: GLKMatrix4)
    {
        self.name = _name
        self.children = _children
        self.transformation = _transformation
    }
    
    init(_ _name: String, _ _transformation: GLKMatrix4)
    {
        self.name = _name
        self.transformation = _transformation
    }
    
    public mutating func insertChildrenAt(_ _name: String, _ _children: Array<Skeleton>) -> Bool
    {
        
        if self.name == _name
        {
            self.children = _children
            return true;
        }

        for i in 0..<self.children.count
        {
            if(self.children[i].insertChildrenAt(_name, _children))
            {
                return true
            }
        }
        return false
    }
}

struct Bone
{
    var name: String = ""
    var offset: GLKMatrix4 = GLKMatrix4Identity
    var transform: GLKMatrix4 = GLKMatrix4Identity
    
    init(_ _name: String, _ _offset: GLKMatrix4)
    {
        self.name = _name
        self.offset = _offset
    }
}
