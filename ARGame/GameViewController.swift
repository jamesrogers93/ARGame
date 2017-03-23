//
//  GameViewController.swift
//  ARGame
//
//  Created by James Rogers on 16/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import GLKit
import OpenGLES

func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer?
{
    return UnsafeRawPointer(bitPattern: i)
}

class GameViewController: GLKViewController
{
    
    var context: EAGLContext? = nil
    
    // Shaders
    /// GLKit shader
    //var effect: GLKBaseEffect? = nil
    /// OpenGLES Shader
    var effect: EffectMaterial? = nil
    
    var obj: ObjectStatic? = nil
    var obj2: ObjectAnimated? = nil
    
    var arHandler: ARHandler = ARHandler()
    
    deinit
    {
        self.tearDownGL()
        
        if EAGLContext.current() === self.context
        {
            EAGLContext.setCurrent(nil)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.context = EAGLContext(api: .openGLES2)
        
        if !(self.context != nil)
        {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        
        self.setupGL()
        
        // Create object with model
        //self.obj = Object(ModelLoader.loadStaticModelFromFile("box", "obj"))
        self.obj = ObjectStatic(ModelLoader.loadStaticModelFromFile("sword_and_shield_idle", "fbx"))
        self.obj2 = ObjectAnimated(ModelLoader.loadAnimatedModelFromFile("sword_and_shield_idle", "fbx"))
        
        // Initalise the AR handler
        self.arHandler.onViewLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // Start the AR handler
        self.arHandler.start()
        
        //glViewport(-105, 0, 851, 1136);
        glViewport(0,0, self.arHandler.camWidth, self.arHandler.camHeight)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Stop the AR handler
        self.arHandler.stop()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded && (self.view.window != nil)
        {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.current() === self.context
            {
                EAGLContext.setCurrent(nil)
            }
            self.context = nil
        }
    }
    
    func setupGL()
    {
        // Set current GL context
        EAGLContext.setCurrent(self.context)
        
        // Set GLKit Shader
        //self.effect = GLKBaseEffect()   // Init renderer
        //self.effect!.light0.enabled = GLboolean(GL_TRUE)    // Add light
        //self.effect!.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0)   // Set light colour
        
        // Set my OpenGLES Effect
        //self.effect = EffectBasic()
        self.effect = EffectMaterial()
        //self.effect?.setColour(GLKVector4Make(1.0, 0.0, 0.0, 1.0))
        
        // Allow depth testing
        glEnable(GLenum(GL_DEPTH_TEST))
    }
    
    func tearDownGL()
    {
        EAGLContext.setCurrent(self.context)
        
        // Delete Effect
        self.effect?.destroy()
        self.effect = nil
        
        // Delete object
        self.obj?.destroy()
        self.obj = nil
        
        self.obj2?.destroy()
        self.obj2 = nil
    }
    
    var rotation: Float = 0.0
    
    // Update view in here
    func update()
    {
        // Update the projection matrix
        self.effect?.setProjection(self.arHandler.camProjection)
        
        // Update model in renderer
        //self.effect?.transform.modelviewMatrix = GLKMatrix4Multiply(self.arHandler.camPose, (self.obj?.getModel())!)
        self.effect?.setView(self.arHandler.camPose)
        
        self.obj?.translate(GLKVector3Make(0.0, 0.0, -500.0))
        //self.obj?.rotate(rotation, GLKVector3Make(1.0, 0.0, 0.0))
        self.obj?.scale(GLKVector3Make(10.0, 10.0, 10.0))
        //rotation+=0.01
        //print(rotation)
    }
    
    // Draw OpenGL content here
    override func glkView(_ view: GLKView, drawIn rect: CGRect)
    {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        // Update viewport here?
        //glViewport(-105, 0, 851, 1136);
        self.arHandler.setViewport()
        
        // Draw the camera view
        self.arHandler.draw()
        
        // Draw the object
        self.obj?.draw(self.effect!)
    }
}
