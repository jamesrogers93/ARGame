//
//  Shader.fsh
//  ARGame
//
//  Created by James Rogers on 16/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
