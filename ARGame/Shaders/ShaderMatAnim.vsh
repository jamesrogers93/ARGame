//
//  ShaderMatAnim.vsh
//  ARGame
//
//  Created by James Rogers on 24/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#version 300 es

in vec4  position;
in vec3  normal;
in vec2  texCoord;
in ivec4 boneIDs;
in vec4  boneWeights;

uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;

uniform mat3 normalMatrix;

const int MAX_BONES = 50;
uniform mat4 bones[MAX_BONES];

// Out variables
out mediump vec2 TexCoord;
out mediump vec3 Normal;
out mediump vec3 FragPos;

void main()
{
    TexCoord = texCoord;
    
    mat4 BoneTransform = bones[boneIDs[0]] * boneWeights[0];
    BoneTransform += bones[boneIDs[1]] * boneWeights[1];
    BoneTransform += bones[boneIDs[2]] * boneWeights[2];
    BoneTransform += bones[boneIDs[3]] * boneWeights[3];
    
    Normal = vec3(modelMatrix * BoneTransform * vec4(normal, 0.0));

    FragPos = vec3(modelMatrix * position);
    
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * BoneTransform * position;
}
