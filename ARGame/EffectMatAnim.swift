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
            if let loc = self.shader.getUniformLocation("bones[\(i)]")
            {
                withUnsafePointer(to: &self.bones[i], {
                    $0.withMemoryRebound(to: Float.self, capacity: 16, {
                        glUniformMatrix4fv(loc, 1, 0, $0)
                    })
                })
            }
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
