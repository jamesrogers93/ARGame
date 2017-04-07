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
    
    init()
    {}
    
    init(_ _name: String, _ _children: Array<Skeleton>)
    {
        self.name = _name
        self.children = _children
    }
    
    init(_ _name: String, _ _children: Array<String>)
    {
        self.name = _name
        
        for i in 0..<_children.count
        {
            self.children.append(Skeleton(_children[i], Array<Skeleton>()))
        }
    }
    
    init(_ _name: String)
    {
        self.name = _name
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
