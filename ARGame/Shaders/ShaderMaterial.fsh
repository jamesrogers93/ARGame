//
//  Shader.fsh
//  ARGame
//
//  Created by James Rogers on 09/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

varying lowp vec2 TexCoord;
varying lowp vec3 Normal;
varying lowp vec3 FragPos;

uniform lowp vec3 viewPosition;

uniform lowp vec4 colour;
uniform sampler2D textureDiff;
uniform sampler2D textureSpec;


void main()
{
    // Temporary hardcode light
    lowp vec3 lightPosition = vec3(50.0, 50.0, 50.0);
    lowp vec3 lightDir = normalize(lightPosition - FragPos);
    lowp vec3 viewDir  = normalize(viewPosition  - FragPos);
    lowp vec3 normal = normalize(Normal);
    lowp vec4 diffuseTex = texture2D(textureDiff, TexCoord);
    
    // Ambient
    lowp float ambientStrength = 0.1;
    
    // Diffuse
    lowp float diffuseStrength = max(dot(normal, lightDir), 0.0);
    
    // Specular
    lowp vec3 halfwayDir = normalize(lightDir + viewDir);
    lowp float specularStrength = pow(max(dot(normal, halfwayDir), 0.0), 32.0);
    
    lowp vec4 ambient = diffuseTex * ambientStrength;
    lowp vec4 diffuse = diffuseTex * diffuseStrength;
    lowp vec4 specular = texture2D(textureSpec, TexCoord) * specularStrength;
    
    gl_FragColor = ambient + diffuse + specular + colour;
    //gl_FragColor = ambient;
    //gl_FragColor = diffuse;
    //gl_FragColor = specular;
    //gl_FragColor = colour;
}
