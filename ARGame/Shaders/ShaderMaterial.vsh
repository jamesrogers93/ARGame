//
//  Shader.vsh
//  ARGame
//
//  Created by James Rogers on 09/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord;

uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;

uniform mat3 normalMatrix;

// Out variables
varying lowp vec2 TexCoord;
varying lowp vec3 Normal;
varying lowp vec3 FragPos;

void main()
{
    TexCoord = texCoord;
    
    Normal = normalMatrix * normal;

    FragPos = vec3(modelMatrix * position);
    
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * position;
}
