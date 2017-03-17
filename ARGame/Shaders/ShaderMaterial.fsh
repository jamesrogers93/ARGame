//
//  Shader.fsh
//  ARGame
//
//  Created by James Rogers on 09/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

varying mediump vec2 TexCoord;
varying mediump vec3 Normal;
varying mediump vec3 FragPos;

uniform mediump vec3 viewPosition;

uniform mediump vec4 colour;
uniform sampler2D textureDiff;
uniform sampler2D textureSpec;
uniform mediump vec4 colourDiff;
uniform mediump vec4 colourSpec;
uniform mediump float shininess;


void main()
{
    // Temporary hardcode light
    mediump vec3 lightPosition = vec3(-1800.0, 1600.0, 2650.0);
    mediump vec3 lightDir = normalize(lightPosition - FragPos);
    mediump vec3 viewDir  = normalize(viewPosition  - FragPos);
    mediump vec3 normal = normalize(Normal);
    mediump vec4 diffuseTex = texture2D(textureDiff, TexCoord);
    
    // Ambient
    mediump float ambientStrength = 0.1;
    
    // Diffuse
    mediump float diffuseStrength = max(dot(normal, lightDir), 0.0) * 0.1; // Need to fix this
    
    // Specular
    mediump vec3 halfwayDir = normalize(lightDir + viewDir);
    mediump float specularStrength = pow(max(dot(normal, halfwayDir), 0.0), shininess);
    
    // Calculate colours
    mediump vec4 ambient = (colourDiff + diffuseTex) * ambientStrength;
    mediump vec4 diffuse = (colourDiff + diffuseTex) * diffuseStrength;
    mediump vec4 specular = (colourSpec + texture2D(textureSpec, TexCoord)) * specularStrength;
    
    gl_FragColor = ambient + diffuse + specular + colour;
    
    //gl_FragColor = ambient;
    //gl_FragColor = diffuse;
    //gl_FragColor = specular;
    //gl_FragColor = colour;
}
