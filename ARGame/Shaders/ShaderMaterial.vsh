//
//  ShaderMaterial.vsh
//  ARGame
//
//  Created by James Rogers on 09/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#version 300 es

in vec4 position;
in vec3 normal;
in vec2 texCoord;

uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;

uniform mat3 normalMatrix;

// Out variables
out mediump vec2 TexCoord;
out mediump vec3 Normal;
out mediump vec3 FragPos;

void main()
{
    TexCoord = texCoord;
    
    Normal = normalMatrix * normal;
    //Normal = normal;
    //Normal = mat3(transpose(inverse(modelMatrix))) * normal;

    FragPos = vec3(modelMatrix * position);
    
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * position;
}
