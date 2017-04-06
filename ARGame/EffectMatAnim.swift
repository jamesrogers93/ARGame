//
//  EffectMatAnim.swift
//  ARGame
//
//  Created by James Rogers on 24/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class EffectMatAnim : EffectMaterial
{
    private var bones: Array<GLKMatrix4> = Array()
    
    public override init()
    {
        // Set shader parameters
        let vertName: String = "ShaderMatAnim"
        let fragName: String = "ShaderMatAnim"
        
        let vertAttribs: [(GLint, String)] = [(ShaderVertexAttrib.position.rawValue,   "position"),
                                              (ShaderVertexAttrib.normal.rawValue,     "normal"),
                                              (ShaderVertexAttrib.texCoord.rawValue,   "texCoord"),
                                              (ShaderVertexAttrib.boneIds.rawValue,    "boneIDs"),
                                              (ShaderVertexAttrib.boneWeight.rawValue, "boneWeights")]
        
        var uniformNames:[String] = ["projectionMatrix", "viewMatrix", "modelMatrix",
                                     "normalMatrix",
                                     "viewPosition",
                                     "colour",
                                     "textureDiff", "textureSpec",
                                     "colourDiff", "colourSpec",
                                     "shininess"]
        for i in 0..<50
        {
            uniformNames.append("bones[\(i)]")
        }
        
        super.init(vertName, fragName, vertAttribs, uniformNames)
    }
    
    public override func prepareToDraw()
    {
        super.prepareToDraw()
        
        // Put bones in the shader
        for i in 0..<bones.count
        {
            // Test matrix is correct in column major order
            //print(bones[i][0], bones[i][4], bones[i][8], bones[i][12])
            //print(bones[i][1], bones[i][5], bones[i][9], bones[i][13])
            //print(bones[i][2], bones[i][6], bones[i][10], bones[i][14])
            //print(bones[i][3], bones[i][7], bones[i][11], bones[i][15])
            
            withUnsafePointer(to: &self.bones[i], {
                $0.withMemoryRebound(to: Float.self, capacity: 16, {
                    glUniformMatrix4fv(self.shader.getUniformLocation("bones[\(i)]"), 1, 0, $0)
                })
            })
        }
    }
    
    public func setBones(_ _bones: Array<GLKMatrix4>)
    {
        if _bones.count > 50
        {
            print("Unsupported number of bones")
            return
        }
        
        self.bones = _bones
    }
}
