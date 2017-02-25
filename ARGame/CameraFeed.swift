//
//  ARCameraFeed.swift
//  ARGame
//
//  Created by James Rogers on 23/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation
import CoreVideo
import AVFoundation
import GLKit

@objc protocol CameraFeedDeletage
{
    @objc optional func cameraSessionDidOutputSampleBuffer(sampleBuffer: CMSampleBuffer!)
}

class CameraFeed : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate
{
    // The OpenGL mesh which covers the display
    private var display: Mesh? = nil
    
    // The shader progam for the display
    private var effect: GLKBaseEffect? = nil
    
    // Capture configurations
    private let captureSession: AVCaptureSession  = AVCaptureSession()
    private var captureDevice: AVCaptureDevice?
    private var captureInput:  AVCaptureInput?
    private var captureOutput: AVCaptureVideoDataOutput?
    
    // Thread handle
    private var captureQueue: DispatchQueue!
    
    // Reference to delegate to invoke when image captured from camera
    private var cameraFeedDelagate: CameraFeedDeletage?
    
    // Texture cache
    private var textureID: GLuint = 0
    private var unmanagedTexture: UnsafeMutablePointer<CVOpenGLESTexture?>?
    private var texture: CVOpenGLESTexture?
    private var coreTextureCache: CVOpenGLESTextureCache?
    private var unmanagedCoreTextureCache: UnsafeMutablePointer<CVOpenGLESTextureCache?>?
    
    init(_ context: EAGLContext)
    {
        
        super.init()
        
        // Initalise the shaders
        self.initEffect()
        
        // Initalise the display(opengl geometry)
        self.initDisplay(context)
        
        // Setup the camera capture session
        self.setupCaptureSession()
    }
    
    deinit
    {
        display = nil
        effect = nil
    }
    
    /**  Sets the camera feed delegate.
     *
     * @param delegate  The delegate of type CameraFeedDeletage.
     */
    //public func setCameraFeedDelegate(delegate: CameraFeedDeletage!)
    //{
    //    self.cameraFeedDelagate = delegate
    //}
    
    /**  Draws the camera feed to screen.
     *
     */
    public func draw()
    {
        display?.draw(effect)
    }
    
    /**  Sets the camera feed delegate.
     *
     * @param buffer  The GLKTextureInfo object.
     */
    public func setCameraBuffer(_ buffer: GLKTextureInfo)
    {
        self.display?.setTexture(buffer)
    }
    
    /**  Initalises the display.
     *
     */
    private func initDisplay(_ context: EAGLContext)
    {
        // Mesh geometry
        var vertices: Array<Vertex> = Array();
        vertices.append(Vertex(GLKVector3Make(-1.0, -1.0, 0.0), GLKVector3Make(0.0, 0.0, 1.0), GLKVector2Make(0.0, 1.0)))
        vertices.append(Vertex(GLKVector3Make(-1.0,  1.0, 0.0), GLKVector3Make(0.0, 0.0, 1.0), GLKVector2Make(0.0, 0.0)))
        vertices.append(Vertex(GLKVector3Make( 1.0,  1.0, 0.0), GLKVector3Make(0.0, 0.0, 1.0), GLKVector2Make(1.0, 0.0)))
        vertices.append(Vertex(GLKVector3Make( 1.0, -1.0, 0.0), GLKVector3Make(0.0, 0.0, 1.0), GLKVector2Make(1.0, 1.0)))
        
        var indices: Array<GLuint> = Array();
        indices.append(0); indices.append(1); indices.append(2)
        indices.append(2); indices.append(3); indices.append(0)
        
        display = Mesh(vertices, indices)
        
        // Allocate space for unmanaged texture cache and texture
        self.unmanagedCoreTextureCache = UnsafeMutablePointer<CVOpenGLESTextureCache?>.allocate(capacity: 1)
        self.unmanagedTexture = UnsafeMutablePointer<CVOpenGLESTexture?>.allocate(capacity: 1)
        
        // Initalise opengl texture cache
        let err: CVReturn = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, nil, context, nil, self.unmanagedCoreTextureCache!)
        self.coreTextureCache = self.unmanagedCoreTextureCache?.pointee
    }
    
    /**  Initalises the shader.
     *
     */
    private func initEffect()
    {
        self.effect = GLKBaseEffect()
        self.effect?.transform.projectionMatrix = GLKMatrix4Identity
        self.effect?.transform.modelviewMatrix = GLKMatrix4Identity
        
        self.effect!.light0.enabled = GLboolean(GL_TRUE)    // Add light
        self.effect!.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0)   // Set light colour
    }
    
    /**  Sets up the Camera capture.
     *
     */
    private func setupCaptureSession()
    {
        // Initalise capture session
        self.captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        // Initalise the capture queue
        self.captureQueue = DispatchQueue(label: "captureQueue")
        
        // Do all setup stuff asyncronously
        captureQueue.async
        {
            // Tell capture session that we are going to make configuration changes
            self.captureSession.beginConfiguration()
            
            // Add capture input to the session
            self.setupCaptureInput()
            
            // Setup capture output
            self.setupCaptureOutput()
            
            // Tell capture session that we are done with configuration changes
            self.captureSession.commitConfiguration()
        }
        
        // Start the capture session
        if(!startCapture())
        {
            print("Could not start camera capture")
        }
        
        
    }
    
    /**  Sets up the camera capture input.
     *
     */
    private func setupCaptureInput()
    {
        // Find rear facing video camera
        let deviceType:AVCaptureDeviceType = AVCaptureDeviceType.builtInWideAngleCamera
        let mediaType:String = AVMediaTypeVideo
        let position:AVCaptureDevicePosition = AVCaptureDevicePosition.back
        let devices = AVCaptureDeviceDiscoverySession(deviceTypes: [deviceType], mediaType: mediaType, position: position)
        
        // Set the captureDevice to the rear facing camera
        self.captureDevice = devices?.devices[0]
        
        // Add capture input to the capture session
        do
        {
            self.captureInput = try AVCaptureDeviceInput(device: self.captureDevice)

            if(self.captureSession.canAddInput(self.captureInput))
            {
                self.captureSession.addInput(self.captureInput)
            }
            
            
        } catch
        {
            print("Could not add device input to capture session")
        }
    }
    
    /**  Sets up the camera capture output.
     *
     */
    private func setupCaptureOutput()
    {
        // Setup capture output
        self.captureOutput = AVCaptureVideoDataOutput()
        self.captureOutput?.alwaysDiscardsLateVideoFrames = true
        self.captureOutput?.videoSettings = NSDictionary(object: Int(kCVPixelFormatType_32BGRA),
                                                         forKey: kCVPixelBufferPixelFormatTypeKey as! NSCopying) as! [AnyHashable : Any]
        self.captureOutput?.videoSettings = nil
        
        // Set the buffer delegate for callbacks
        self.captureOutput?.setSampleBufferDelegate(self, queue: self.captureQueue)
        
        // Add the output to the capture session
        if(self.captureSession.canAddOutput(self.captureOutput))
        {
            self.captureSession.addOutput(self.captureOutput)
        }
        
        // Set the output media type
        self.captureOutput?.connection(withMediaType: AVMediaTypeVideo).isEnabled = true
    }
    
    /**  Starts the camera capture and begins recording
     *
     *  @return Boolean value indicating if the capture started or not.
     */
    public func startCapture() -> Bool
    {
        var didStart: Bool = false
        
        if(!self.captureSession.isRunning)
        {
            self.captureSession.startRunning()
            didStart = true
        }
        
        return didStart
    }
    
    /**  Stops the camera capture and stops recording.
     *
     */
    public func stopCapture()
    {
        if(self.captureSession.isRunning)
        {
            self.captureSession.stopRunning()
        }
    }
    
    private func cleanupVideoTextures() {
        
        if ((self.texture) != nil)
        {
            self.texture = nil
        }
        
        CVOpenGLESTextureCacheFlush(self.coreTextureCache!, 0)
    }
    
    //
    // AVCaptureVideoDataOutputSampleBufferDelegate Methods
    //
    func captureOutput(_: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from: AVCaptureConnection!)
    {
        print("Image Captured!")
        
        self.cleanupVideoTextures()
        
        // Get pixel buffer from sampleBuffer
        let data:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        // Lock the pixel buffer address before accessing
        CVPixelBufferLockBaseAddress(data, CVPixelBufferLockFlags(rawValue: 0))
        
        let textureWidth = CVPixelBufferGetWidth(data)
        let textureHeight = CVPixelBufferGetHeight(data)
        
        let err: CVReturn = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                         self.coreTextureCache!,
                                                                         data,
                                                                         nil,
                                                                         GLenum(GL_TEXTURE_2D),
                                                                         GL_RGBA,
                                                                         GLsizei(textureWidth),
                                                                         GLsizei(textureHeight),
                                                                         GLenum(GL_RGBA),
                                                                         GLenum(GL_UNSIGNED_BYTE),
                                                                         0,
                                                                         self.unmanagedTexture!)
        
        self.texture = self.unmanagedTexture!.pointee
        
        self.textureID = CVOpenGLESTextureGetName(self.texture!);
        glBindTexture(GLenum(GL_TEXTURE_2D), self.textureID);
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        
        // Unlock the pixel buffer now that we're done
        CVPixelBufferUnlockBaseAddress(data, CVPixelBufferLockFlags(rawValue: 0))
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!)
    {
        
        print("Image Discarded!")
    }
    
}
