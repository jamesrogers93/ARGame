//
//  ShaderMatAnim.fsh
//  ARGame
//
//  Created by James Rogers on 24/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#version 300 es

in mediump vec2 TexCoord;
in mediump vec3 Normal;
in mediump vec3 FragPos;

uniform mediump vec3 viewPosition;

uniform mediump vec4 colour;
uniform sampler2D textureDiff;
uniform sampler2D textureSpec;
uniform mediump vec4 colourDiff;
uniform mediump vec4 colourSpec;
uniform mediump float shininess;

out mediump vec4 frag_colour;

void main()
{
    // Temporary hardcode light
    mediump vec3 lightPosition = vec3(-1800.0, 1600.0, 2650.0);
    mediump vec3 lightDir = normalize(lightPosition - FragPos);
    mediump vec3 viewDir  = normalize(viewPosition  - FragPos);
    mediump vec3 normal = normalize(Normal);
    
    // Get texture colours
    mediump vec4 textureDiff = texture(textureDiff, TexCoord);
    mediump vec4 textureSpec = texture(textureSpec, TexCoord);
    
    // Ambient
    mediump float ambientStrength = 0.1;
    
    // Diffuse
    mediump float diffuseStrength = max(dot(normal, lightDir), 0.0) * 0.1; // Need to fix this
    
    // Specular
    mediump vec3 halfwayDir = normalize(lightDir + viewDir);
    mediump float specularStrength = pow(max(dot(normal, halfwayDir), 0.0), shininess);
    
    // Calculate colours
    mediump vec4 ambient = (colourDiff + textureDiff) * ambientStrength;
    mediump vec4 diffuse = (colourDiff + textureDiff) * diffuseStrength;
    mediump vec4 specular = (colourSpec + textureSpec) * specularStrength;
    
    frag_colour = ambient + diffuse + specular + colour;
    
    //frag_colour = ambient;
    //frag_colour = diffuse;
    //frag_colour = specular;
    //frag_colour = colour;
}
