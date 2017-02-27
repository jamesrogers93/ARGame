//
//  ARMarkerTracker.m
//  ARGame
//
//  Created by James Rogers on 21/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//


#import "ARHandler.h"

#define VIEW_DISTANCE_MIN        5.0f          // Objects closer to the camera than this will not be displayed.
#define VIEW_DISTANCE_MAX        2000.0f        // Objects further away from the camera than this will not be displayed.


@implementation ARHandler
{
    // Loop handlers
    BOOL            running;
    BOOL            videoPaused;
    
    // Video acquisition
    AR2VideoParamT *gVid;
    
    // Marker detection.
    ARHandle       *gARHandle;
    ARPattHandle   *gARPattHandle;
    
    // Transformation matrix retrieval.
    AR3DHandle     *gAR3DHandle;
    ARdouble        gPatt_width;            // Per-marker, but we are using only 1 marker.
    ARdouble        gPatt_trans[3][4];      // Per-marker, but we are using only 1 marker.
    int             gPatt_found;            // Per-marker, but we are using only 1 marker.
    int             gPatt_id;               // Per-marker, but we are using only 1 marker.
    BOOL            useContPoseEstimation;
    
    // Drawing
    ARParamLT      *gCparamLT;
    ARGL_CONTEXT_SETTINGS_REF arglContextSettings;
}

@synthesize arglContextSettings;
@synthesize running;
@synthesize camProjection;

- (void) draw
{
    glDisable(GL_DEPTH_TEST);
    arglDispImage(arglContextSettings);
    glEnable(GL_DEPTH_TEST);
}

- (void) onViewLoad
{
    // Loop handlers
    running = FALSE;
    videoPaused = FALSE;
    
    // Video
    gVid = NULL;
    
    // Marker detection
    gARHandle = NULL;
    gARPattHandle = NULL;
    
    // Transform matrix
    gAR3DHandle = NULL;
    
    // Camera
    gCparamLT = NULL;
}

- (void)startRunLoop
{
    if (!running)
    {
        // After starting the video, new frames will invoke cameraVideoTookPicture:userData:.
        if (ar2VideoCapStart(gVid) != 0) {
            NSLog(@"Error: Unable to begin camera data capture.\n");
            [self stop];
            return;
        }
        running = TRUE;
    }
}

- (void)stopRunLoop
{
    if (running)
    {
        ar2VideoCapStop(gVid);
        running = FALSE;
    }
}

- (BOOL) isPaused
{
    if (!running)
        return (NO);
    
    return (videoPaused);
}

- (void) setPaused:(BOOL)paused
{
    if (!running)
        return;
    
    if (videoPaused != paused)
    {
        if (paused)
            ar2VideoCapStop(gVid);
        else
            ar2VideoCapStart(gVid);
        
        videoPaused = paused;
    }
}

static void startCallback(void *userData);

- (void)start
{
    // Open the video path.
    char *vconf = "";
    if (!(gVid = ar2VideoOpenAsync(vconf, startCallback, (__bridge void *)(self)))) {
        NSLog(@"Error: Unable to open connection to camera.\n");
        [self stop];
        return;
    }
}

static void startCallback(void *userData)
{
    ARHandler *vc = (__bridge ARHandler *)userData;
    
    [vc start2];
}

- (void) start2
{
    // Find the size of the window.
    int xsize, ysize;
    if (ar2VideoGetSize(gVid, &xsize, &ysize) < 0)
    {
        NSLog(@"Error: ar2VideoGetSize.\n");
        [self stop];
        return;
    }
    
    // Get the format in which the camera is returning pixels.
    AR_PIXEL_FORMAT pixFormat = ar2VideoGetPixelFormat(gVid);
    if (pixFormat == AR_PIXEL_FORMAT_INVALID)
    {
        NSLog(@"Error: Camera is using unsupported pixel format.\n");
        [self stop];
        return;
    }
    
    // Work out if the front camera is being used. If it is, flip the viewing frustum for
    // 3D drawing.
    BOOL flipV = FALSE;
    int frontCamera;
    if (ar2VideoGetParami(gVid, AR_VIDEO_PARAM_IOS_CAMERA_POSITION, &frontCamera) >= 0)
    {
        if (frontCamera == AR_VIDEO_IOS_CAMERA_POSITION_FRONT) flipV = TRUE;
    }
    
    // Tell arVideo what the typical focal distance will be. Note that this does NOT
    // change the actual focus, but on devices with non-fixed focus, it lets arVideo
    // choose a better set of camera parameters.
    ar2VideoSetParami(gVid, AR_VIDEO_PARAM_IOS_FOCUS, AR_VIDEO_IOS_FOCUS_0_3M); // Default is 0.3 metres. See <AR/sys/videoiPhone.h> for allowable values.
    
    // Load the camera parameters, resize for the window and init.
    ARParam cparam;
    if (ar2VideoGetCParam(gVid, &cparam) < 0)
    {
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"camera_para" ofType:@"dat"];
        
        NSLog(@"Unable to automatically determine camera parameters. Using default.\n");
        if (arParamLoad([filename cStringUsingEncoding:1], 1, &cparam) < 0)
        {
            NSLog(@"Error: Unable to load parameter file %@ for camera.\n", filename);
            [self stop];
            return;
        }
    }
    
    if (cparam.xsize != xsize || cparam.ysize != ysize)
    {
        arParamChangeSize(&cparam, xsize, ysize, &cparam);
    }
    
    if ((gCparamLT = arParamLTCreate(&cparam, AR_PARAM_LT_DEFAULT_OFFSET)) == NULL)
    {
        NSLog(@"Error: arParamLTCreate.\n");
        [self stop];
        return;
    }
    
    // AR init.
    if ((gARHandle = arCreateHandle(gCparamLT)) == NULL)
    {
        NSLog(@"Error: arCreateHandle.\n");
        [self stop];
        return;
    }
    if (arSetPixelFormat(gARHandle, pixFormat) < 0)
    {
        NSLog(@"Error: arSetPixelFormat.\n");
        [self stop];
        return;
    }
    if ((gAR3DHandle = ar3DCreateHandle(&gCparamLT->param)) == NULL)
    {
        NSLog(@"Error: ar3DCreateHandle.\n");
        [self stop];
        return;
    }
    
    // libARvideo on iPhone uses an underlying class called CameraVideo. Here, we
    // access the instance of this class to get/set some special types of information.
    CameraVideo *cameraVideo = ar2VideoGetNativeVideoInstanceiPhone(gVid->device.iPhone);
    if (!cameraVideo)
    {
        NSLog(@"Error: Unable to set up AR camera: missing CameraVideo instance.\n");
        [self stop];
        return;
    }
    
    // The camera will be started by -startRunLoop.
    [cameraVideo setTookPictureDelegate:self];
    [cameraVideo setTookPictureDelegateUserData:NULL];
    
    // Other ARToolKit setup.
    arSetMarkerExtractionMode(gARHandle, AR_USE_TRACKING_HISTORY_V2);
    //arSetMarkerExtractionMode(gARHandle, AR_NOUSE_TRACKING_HISTORY);
    //arSetLabelingThreshMode(gARHandle, AR_LABELING_THRESH_MODE_MANUAL); // Uncomment to use  manual thresholding.
    
    // Allocate the OpenGL view
    ////////////////////////// Not here!
    
    // Set camera projection matrix from calibrated camera paramters
    // Create the OpenGL projection from the calibrated camera parameters.
    // If flipV is set, flip.
    GLfloat frustum[16];
    arglCameraFrustumRHf(&gCparamLT->param, VIEW_DISTANCE_MIN, VIEW_DISTANCE_MAX, frustum);
    
    // Need to change this, This is NOT the Camera Projection!!!!
    camProjection = GLKMatrix4Make(frustum[0], frustum[1], frustum[2], frustum[3], frustum[4], frustum[5], frustum[6], frustum[7], frustum[8], frustum[9], frustum[10], frustum[11], frustum[12], frustum[13], frustum[14], frustum[15]);
    
    // Setup ARGL to draw the background video.
    arglContextSettings = arglSetupForCurrentContext(&gCparamLT->param, pixFormat);
    
    arglSetRotate90(arglContextSettings, FALSE);
    if (flipV)
        arglSetFlipV(arglContextSettings, TRUE);
    int width, height;
    ar2VideoGetBufferSize(gVid, &width, &height);
    arglPixelBufferSizeSet(arglContextSettings, width, height);
    
    // Prepare ARToolKit to load patterns.
    if (!(gARPattHandle = arPattCreateHandle()))
    {
        NSLog(@"Error: arPattCreateHandle.\n");
        [self stop];
        return;
    }
    arPattAttach(gARHandle, gARPattHandle);
    
    // Load marker(s).
    // Loading only 1 pattern in this example.
    //char *patt_name  = "Data2/hiro.patt";
    char *patt_name = [[[NSBundle mainBundle] pathForResource:@"hiro" ofType:@"patt"] UTF8String];
    if ((gPatt_id = arPattLoad(gARPattHandle, patt_name)) < 0) {
        NSLog(@"Error loading pattern file %s.\n", patt_name);
        [self stop];
        return;
    }
    gPatt_width = 40.0f;
    gPatt_found = FALSE;
    
    [self startRunLoop];
    
}

- (void) cameraVideoTookPicture:(id)sender userData:(void *)data
{
    AR2VideoBufferT *buffer = ar2VideoGetImage(gVid);
    if (buffer)
        [self processFrame:buffer];
}

- (void) processFrame:(AR2VideoBufferT *)buffer
{
    if (buffer)
    {
        // Upload the frame to OpenGL.
        if (buffer->bufPlaneCount == 2)
            arglPixelBufferDataUploadBiPlanar(arglContextSettings, buffer->bufPlanes[0], buffer->bufPlanes[1]);
        else
            arglPixelBufferDataUpload(arglContextSettings, buffer->buff);
    }
}

- (void)stop
{
    [self stopRunLoop];
    
    if (gARHandle)
        arPattDetach(gARHandle);
    
    if (gARPattHandle)
    {
        arPattDeleteHandle(gARPattHandle);
        gARPattHandle = NULL;
    }
    
    if (gAR3DHandle)
        ar3DDeleteHandle(&gAR3DHandle);
    
    if (gARHandle)
    {
        arDeleteHandle(gARHandle);
        gARHandle = NULL;
    }
    
    arParamLTFree(&gCparamLT);
    
    if (gVid)
    {
        ar2VideoClose(gVid);
        gVid = NULL;
    }
}

@end
