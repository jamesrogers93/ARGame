//
//  Shader.swift
//  ARGame
//
//  Created by James Rogers on 09/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation
import GLKit

enum ShaderVertexAttrib: GLint
{
    case position
    case normal
    case texCoord
}

class Shader
{
    private var program:GLuint = 0
    private var uniforms: [(String, GLint)]
    
    private init(_ program:GLuint, _ uniforms:[(String, GLint)])
    {
        self.program = program
        self.uniforms = uniforms
    }
    
    public func useProgram()
    {
        glUseProgram(self.program)
    }
    
    public func getUniformLocation(_ name:String) -> GLint
    {
        for i in 0..<self.uniforms.count
        {
            if(self.uniforms[i].0 == name)
            {
                return self.uniforms[i].1
            }
        }
        
        return -1
    }
    
    public static func loadShader(_ vertex: String, _ fragment: String, _ vertexAttribs: [(GLint, String)], _ uniformNames:[String]) -> Shader?
    {
        var program: GLuint = 0
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        
        // Create shader program.
        program = glCreateProgram()
        
        // Create and compile vertex shader.
        let vertShaderPathname: String = Bundle.main.path(forResource: vertex, ofType: "vsh")!
        if self.compileShader(&vertShader, type: GLenum(GL_VERTEX_SHADER), file: vertShaderPathname) == false
        {
            print("Failed to compile vertex shader")
            return nil
        }
        
        // Create and compile fragment shader.
        let fragShaderPathname: String = Bundle.main.path(forResource: fragment, ofType: "fsh")!
        if !self.compileShader(&fragShader, type: GLenum(GL_FRAGMENT_SHADER), file: fragShaderPathname)
        {
            print("Failed to compile fragment shader")
            return nil
        }
        
        // Attach vertex shader to program.
        glAttachShader(program, vertShader)
        
        // Attach fragment shader to program.
        glAttachShader(program, fragShader)
        
        // Bind attribute locations.
        // This needs to be done prior to linking.
        let numAttribs: Int = vertexAttribs.count
        for i in 0..<numAttribs
        {
            glBindAttribLocation(program,GLuint(vertexAttribs[i].0), vertexAttribs[i].1)
        }
        
        // Link program.
        if !self.linkProgram(program)
        {
            print("Failed to link program: \(program)")
            
            if vertShader != 0
            {
                glDeleteShader(vertShader)
                vertShader = 0
            }
            if fragShader != 0
            {
                glDeleteShader(fragShader)
                fragShader = 0
            }
            if program != 0
            {
                glDeleteProgram(program)
                program = 0
            }
            
            return nil
        }
        
        // Get uniform locations.
        let numUniforms:Int = uniformNames.count
        var uniforms:[(String, GLint)] = [(String, GLint)](repeating:("", 0), count: numUniforms)
        for i in 0..<numUniforms
        {
            uniforms[i].0 = uniformNames[i]
            uniforms[i].1 = glGetUniformLocation(program, uniforms[i].0)
        }
        
        // Release vertex and fragment shaders.
        if vertShader != 0
        {
            glDetachShader(program, vertShader)
            glDeleteShader(vertShader)
        }
        if fragShader != 0
        {
            glDetachShader(program, fragShader)
            glDeleteShader(fragShader)
        }
        
        return Shader(program, uniforms)
    }
    
    private static func compileShader(_ shader: inout GLuint, type: GLenum, file: String) -> Bool {
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do
        {
            source = try NSString(contentsOfFile: file, encoding: String.Encoding.utf8.rawValue).utf8String!
        } catch
        {
            print("Failed to load vertex shader")
            return false
        }
        var castSource: UnsafePointer<GLchar>? = UnsafePointer<GLchar>(source)
        
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0
        {
            glDeleteShader(shader)
            return false
        }
        return true
    }
    
    private static func linkProgram(_ prog: GLuint) -> Bool {
        var status: GLint = 0
        glLinkProgram(prog)
        
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0
        {
            return false
        }
        
        return true
    }
    
    private static func validateProgram(prog: GLuint) -> Bool {
        var logLength: GLsizei = 0
        var status: GLint = 0
        
        glValidateProgram(prog)
        glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0
        {
            var log: [GLchar] = [GLchar](repeating: 0, count: Int(logLength))
            glGetProgramInfoLog(prog, logLength, &logLength, &log)
            print("Program validate log: \n\(log)")
        }
        
        glGetProgramiv(prog, GLenum(GL_VALIDATE_STATUS), &status)
        var returnVal = true
        if status == 0
        {
            returnVal = false
        }
        return returnVal
    }
    
    public func destroy()
    {
        if self.program != 0
        {
            glDeleteProgram(self.program)
        }
    }
}
