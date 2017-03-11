//
//  Shader.fsh
//  ARGame
//
//  Created by James Rogers on 09/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

varying lowp vec2 texCoordIn;

uniform lowp vec4 colour;
uniform sampler2D texture0;
uniform sampler2D texture1;

void main()
{
    gl_FragColor = texture2D(texture0, texCoordIn) + texture2D(texture1, texCoordIn) + colour;
}
