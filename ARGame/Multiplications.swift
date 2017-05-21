//
//  Multiplications.swift
//  ARGame
//
//  Created by James Rogers on 16/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation


func GLKVector4Multiply(_ mat: GLKMatrix4, _ vec: GLKVector4) -> GLKVector4
{
    let x: Float = mat[0] * vec[0] + mat[4] * vec[1] + mat[8]  * vec[2] + mat[12] * vec[3]
    let y: Float = mat[1] * vec[0] + mat[5] * vec[1] + mat[9]  * vec[2] + mat[13] * vec[3]
    let z: Float = mat[2] * vec[0] + mat[6] * vec[1] + mat[10] * vec[2] + mat[14] * vec[3]
    let w: Float = mat[3] * vec[0] + mat[7] * vec[1] + mat[11] * vec[2] + mat[15] * vec[3]
    
    return GLKVector4Make(x,y,z,w)
}
