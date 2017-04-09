//
//  ShaderMaterial.fsh
//  ARGame
//
//  Created by James Rogers on 09/03/2017.
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
uniform int isTextureDiff;
uniform int isTextureSpec;
uniform mediump vec4 colourDiff;
uniform mediump vec4 colourSpec;
uniform mediump float shininess;

out mediump vec4 frag_colour;

void main()
{
    
    frag_colour = vec4(1.0);
    
    // Temporary hardcode light
    mediump vec3 lightPosition = vec3(-1800.0, 1600.0, 2650.0);
    mediump float lightConstant  = 1.0;
    mediump float lightLinear    = 0.007;
    mediump float lightQuadratic = 0.0002;
    mediump vec4 lightAmbient = vec4(1.0);
    mediump vec4 lightDiffuse = vec4(1.0);
    mediump vec4 lightSpecular = vec4(1.0);
    
    
    mediump vec3 lightDir = normalize(lightPosition - FragPos);
    mediump vec3 viewDir  = normalize(viewPosition  - FragPos);
    mediump vec3 normal = normalize(Normal);
    mediump vec4 diffuseTex = texture(textureDiff, TexCoord);
    
    // Ambient
    mediump float ambientStrength = 1.0;
    
    // Diffuse
    mediump float diffuseStrength = max(dot(normal, lightDir), 0.0);
    
    // Specular
    mediump vec3 halfwayDir = normalize(lightDir + viewDir);
    mediump float specularStrength = pow(max(dot(normal, halfwayDir), 0.0), shininess);
    
    // Attenuation
    mediump float distance = length(lightPosition - FragPos);
    mediump float attenuation = 1.0 / (lightConstant + lightLinear * distance + lightQuadratic * (distance * distance));
    
    // Calculate which colours to use
    mediump vec4 diffuseColour;// = colourDiff;
    mediump vec4 specularColour;// = colourSpec;
    if(isTextureDiff == 1)
    {
        diffuseColour = texture(textureDiff, TexCoord);
        specularColour = texture(textureSpec, TexCoord);
    }
    else
    {
        diffuseColour = colourDiff;
        specularColour = colourSpec;
    }

    // Calculate colours
    mediump vec4 ambient = lightAmbient * diffuseColour * ambientStrength;
    mediump vec4 diffuse = lightDiffuse * diffuseColour * diffuseStrength;
    mediump vec4 specular = lightSpecular * specularColour * specularStrength;
    
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;
    
    frag_colour = ambient + diffuse + specular + colour;
}
