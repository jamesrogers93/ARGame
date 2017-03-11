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

// Out variables
varying lowp vec2 texCoordIn;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    texCoordIn = texCoord;
    //colour = vec4(1.0, 0.0, 0.0, 1.0);
    gl_Position = modelViewProjectionMatrix * position;
}
