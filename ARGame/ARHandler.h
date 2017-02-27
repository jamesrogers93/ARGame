//
//  ARMarkerTracker.h
//  ARGame
//
//  Created by James Rogers on 21/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#ifndef ARHandler_h
#define ARHandler_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#include <AR/ar.h>
#include <AR/video.h>
#include <AR/gsub_es2.h>
#import <AR/sys/CameraVideo.h>

/*!  ARHandler is the handle to the camera feed and marker tracking defined in ARToolKit. */
@interface ARHandler: NSObject <CameraVideoTookPictureDelegate>
{}

/*!  This initalises the ARHandler. */
- (void) onViewLoad;

/*!  Starts the camera feed and marker tracking. */
- (void) start;

/*! Stops the camera feed and marker tracking. */
- (void) stop;

/*!  Draws the camera feed to the screen using OpenGL ES2. */
- (void) draw;

/*! Camera projection calculated from the screen size and camera lens. */
@property (readonly) GLKMatrix4 camProjection;

/*! The camera view matrix retrived from the tracked marker. 
 If multiple markers are found, the marker that has the most confidence will be used. If no markers are found, this will be an identity matrix. */
@property (readonly) GLKMatrix4 camPose;

@end

#endif /* ARMarkerTracker_h */
