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
    /// OpenGLES Shader
    //var effect: EffectMaterial? = nil
    var effect2:EffectMatAnim? = nil
    
    //var obj: ObjectStatic? = nil
    var obj2: EntityAnimated? = nil
    
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
        
        self.context = EAGLContext(api: .openGLES3)
        
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
        //self.obj = ObjectStatic(ModelLoader.loadStaticModelFromFile("sword_and_shield_idle", "fbx"))
        //self.obj2 = ObjectAnimated(ModelLoader.loadAnimatedModelFromFile("sword_and_shield_idle", "fbx"))
        self.obj2 = EntityAnimated(ModelLoader.loadAnimatedModelFromFile("leg_sweep", "fbx"))
        
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
        //self.effect = EffectMaterial()
        self.effect2 = EffectMatAnim()
        //self.effect?.setColour(GLKVector4Make(1.0, 0.0, 0.0, 1.0))
        
        // Allow depth testing
        glEnable(GLenum(GL_DEPTH_TEST))
    }
    
    func tearDownGL()
    {
        EAGLContext.setCurrent(self.context)
        
        // Delete Effect
        //self.effect?.destroy()
        //self.effect = nil
        
        self.effect2?.destroy()
        self.effect2 = nil
        
        // Delete object
        //self.obj?.destroy()
        //self.obj = nil
        
        self.obj2?.glModel.destroy()
        self.obj2 = nil
    }
    
    var rotation: Float = 0.0
    
    // Update view in here
    func update()
    {
        // Update the projection matrix
        self.effect2?.setProjection(self.arHandler.camProjection)
        
        // Update the camera view
        self.effect2?.setView(self.arHandler.camPose)
        self.obj2?.scale(GLKVector3Make(10.0, 10.0, 10.0))
        
        // Animate
        self.obj2?.glModel.animate()
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
        self.effect2?.setModel((self.obj2?.model)!)
        self.obj2?.glModel.draw(self.effect2!)
    }
}
