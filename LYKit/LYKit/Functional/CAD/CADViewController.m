//
//  CADViewController.m
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "CADViewController.h"
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>



@interface CADViewController ()

@property (weak, nonatomic) IBOutlet SCNView *sceneView;


@end

@implementation CADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCNScene *scene = [SCNScene new];
    self.sceneView.scene = scene;
    self.sceneView.allowsCameraControl = YES;

    SCNBox *box = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
    SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
    [scene.rootNode addChildNode:boxNode];

    // Set up the camera node
    SCNCamera *camera = [SCNCamera new];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 5);
    [scene.rootNode addChildNode:cameraNode];

    self.sceneView.backgroundColor = [UIColor blackColor];
    self.sceneView.autoenablesDefaultLighting = YES;

}




@end
