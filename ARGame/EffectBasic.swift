//
//  EffectBasic.swift
//  ARGame
//
//  Created by James Rogers on 10/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class EffectBasic : Effect
{
    
    public init()
    {
        // Set shader parameters
        let vertName: String = "Shader"
        let fragName: String = "Shader"
        
        let vertAttribs: [(GLint, String)] = [(ShaderVertexAttrib.position.rawValue, "position"),
                                              (ShaderVertexAttrib.normal.rawValue,   "normal"),
                                              (ShaderVertexAttrib.texCoord.rawValue, "texCoord")];
        
        let uniformNames:[String] = ["modelViewProjectionMatrix",
                                     "colour",
                                     "texture0", "texture1"]
        
        super.init(vertName, fragName, vertAttribs, uniformNames)
    }
}
