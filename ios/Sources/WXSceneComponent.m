//
//  WXSceneComponent.m
//  WeexDemo
//
//  Created by 齐山 on 2017/6/21.
//  Copyright © 2017年 taobao. All rights reserved.
//

#import "WXSceneComponent.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <WeexSDK/WXUtility.h>
#import <WeexSDK/WXImgLoaderProtocol.h>

@interface WXSceneComponent()<ARSCNViewDelegate,SCNPhysicsContactDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong) ARSCNView* sceneView;
@property (nonatomic, strong) NSString *src;
@property (nonatomic, strong) NSString *file;
@property(nonatomic) NSInteger index;
@property(nonatomic) BOOL isViewDidLoad;
@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) id<WXImageOperationProtocol> imageOperation;

@end

@implementation WXSceneComponent
WX_PlUGIN_EXPORT_COMPONENT(scene,WXSceneComponent)
WX_EXPORT_METHOD(@selector(addNode:))
WX_EXPORT_METHOD(@selector(updateNode:))
WX_EXPORT_METHOD(@selector(removeNode:))


- (id<WXImgLoaderProtocol>)imageLoader
{
    static id<WXImgLoaderProtocol> imageLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageLoader = [WXSDKEngine handlerForProtocol:@protocol(WXImgLoaderProtocol)];
    });
    return imageLoader;
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        if (attributes[@"src"]) {
            _src = attributes[@"src"];
        }
        if (attributes[@"file"]) {
            _file = attributes[@"file"];
        }
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    SCNScene *scene = [SCNScene new];
    _sceneView.scene = scene;
    // Run the view's session
    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
    configuration.worldAlignment = ARWorldAlignmentGravity;
    //    configuration.lightEstimationEnabled = YES;
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration:configuration];
    if(self.tasks){
        for (NSDictionary *option in self.tasks) {
            [self addNodeTask:option];
        }
        [self.tasks removeAllObjects];
    }
    
    self.isViewDidLoad = YES;
}

#pragma mark -
#pragma mark Private Method

-(NSUInteger)getMask:(NSInteger)index
{
    return 1 << index;
}

#pragma mark -
#pragma mark AR

-(void)addNode:(NSDictionary *)options
{
    
    if(!self.isViewDidLoad){
        if(!_tasks){
            _tasks = [NSMutableArray new];
        }
        [_tasks addObject:options];
        return;
    }
    [self addNodeTask:options];
    
}

-(void)updateNode:(NSDictionary *)options
{
    CGPoint touchLocation =  CGPointMake([WXConvert CGFloat: [options objectForKey:@"x"]], [WXConvert CGFloat: [options objectForKey:@"y"]]);
    NSArray *hitResults = [_sceneView hitTest:touchLocation options:nil];
    
    if(hitResults&& [hitResults count]>0){
        
        SCNHitTestResult *res = hitResults[0];
        SCNNode *node =res.node;
        NSArray *materials= node.geometry.materials;
        for (SCNMaterial *m in materials) {
            if([m.name isEqualToString:[WXConvert NSString:[options objectForKey:@"name"]]]){
                m.diffuse.contents = [WXConvert UIColor:[options objectForKey:@"color"]];
            }
        }
    }
}

-(void)addNodeTask:(NSDictionary *)options
{
    SCNScene *scene = _sceneView.scene;
    
    SCNMaterial * material = [SCNMaterial new];
    material.name = [WXConvert NSString: [options objectForKey:@"name"]];
    NSDictionary *contents = [options objectForKey:@"contents"];
    NSString *type = [WXConvert NSString:[contents objectForKey:@"type"]];
    NSString *src = [WXConvert NSString:[contents objectForKey:@"src"]];
    if([@"color" isEqualToString:type])
    {
        material.diffuse.contents = [WXConvert UIColor:[contents objectForKey:@"name"]];
    }
    if([@"image" isEqualToString:type])
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageOperation = [[weakSelf imageLoader] downloadImageWithURL:src imageFrame:CGRectZero userInfo:@{} completed:^(UIImage *image, NSError *error, BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        return ;
                    }
                    //需要继续优化
                    material.diffuse.contents = image;
                });
            }];
        });
        material.diffuse.contents = [WXConvert UIColor:[contents objectForKey:@"name"]];
    }
    SCNNode *node = [SCNNode new];
    node.name = [WXConvert NSString: [options objectForKey:@"name"]];
    SCNGeometry *geometry ;
    if([@"sphere" isEqualToString:[WXConvert NSString: [options objectForKey:@"type"]]] ){
        geometry = [self getSphere:options];
    }else{
        geometry = [self getBox:options];
    }
    node.geometry =  geometry;
    NSMutableArray *materials = [NSMutableArray arrayWithObject:material];
    if([WXConvert NSInteger:[options objectForKey:@"materialsCount"]]>0){
        materials = [NSMutableArray new];
        for (NSInteger i=0; i< [WXConvert NSInteger:[options objectForKey:@"materialsCount"]]; i++) {
            [materials addObject:material];
        }
    }
    node.geometry.materials =materials;
    SCNPhysicsShape *shape = [SCNPhysicsShape shapeWithGeometry:geometry options:nil];
    node.physicsBody = [SCNPhysicsBody bodyWithType:[WXConvert NSInteger:[options objectForKey:@"PhysicsBodyType"]] shape:shape];
    node.physicsBody.affectedByGravity = [WXConvert BOOL:[options objectForKey:@"affectedByGravity"]];
    node.physicsBody.categoryBitMask= [self getMask:[WXConvert NSInteger:[options objectForKey:@"categoryBitMask"]]];
    node.physicsBody.contactTestBitMask= [self getMask:[WXConvert NSInteger:[options objectForKey:@"contactTestBitMask"]]];
    if([options objectForKey:@"vector"]){
        NSDictionary *vector = [options objectForKey:@"vector"];
        node.position =SCNVector3Make([WXConvert CGFloat: [vector objectForKey:@"x"]] , [WXConvert CGFloat: [vector objectForKey:@"y"]], [WXConvert CGFloat: [vector objectForKey:@"z"]]);
    }
    if([@"sphere" isEqualToString:[WXConvert NSString: [options objectForKey:@"type"]]] ){
        ARFrame *frame = self.sceneView.session.currentFrame;
        SCNVector3 dir = SCNVector3Make(0, 0, -1);
        SCNVector3 pos = SCNVector3Make(0, 0, -0.2);
        if(frame){
            SCNMatrix4 mat = SCNMatrix4FromMat4(frame.camera.transform);
            dir = SCNVector3Make(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33);
            pos = SCNVector3Make(mat.m41, mat.m42, mat.m43);
        }
        node.position = pos;
        [node.physicsBody applyForce:dir impulse:true];
    }
    [scene.rootNode addChildNode:node];
    _sceneView.scene.physicsWorld.contactDelegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.sceneView addGestureRecognizer:tapGestureRecognizer];
    
    
}

-(SCNBox *)getBox:(NSDictionary *)options
{
    SCNBox *box = [SCNBox boxWithWidth:[WXConvert CGFloat: [options objectForKey:@"width"]] height:[WXConvert CGFloat: [options objectForKey:@"height"]] length:[WXConvert CGFloat: [options objectForKey:@"length"]] chamferRadius:[WXConvert CGFloat: [options objectForKey:@"chamferRadius"]]];
    return box;
}

-(SCNSphere *)getSphere:(NSDictionary *)options
{
    SCNSphere *sphere = [SCNSphere sphereWithRadius:[WXConvert CGFloat: [options objectForKey:@"radius"]]];
    return sphere;
}

-(void)tapped:(UITapGestureRecognizer *)recognizer
{
    SCNView *sceneView = (SCNView *)recognizer.view ;
    CGPoint touchLocation =  [recognizer locationInView:sceneView];
    [self fireEvent:@"tap" params:@{@"touchLocation":@{@"x":@(touchLocation.x),@"y":@(touchLocation.y)}}];
}

- (UIView *)loadView
{
    if(!_sceneView){
        ARSCNView *sceneView = [[ARSCNView alloc] init];
        
        sceneView.delegate = self;
        NSString *p = [[NSBundle mainBundle]resourcePath];
        NSLog(@"%@",p);
        _sceneView = sceneView;
        _sceneView.showsStatistics = YES;
        
    }
    return self.sceneView;
}

-(NSInteger)getIndexByMask:(NSInteger )mask
{
    NSInteger index = 0;
    NSInteger record = 1;
    for (int i = 0; i<32; i++) {
        if(record<<i == mask){
            return index;
        }
        index ++;
    }
    return 32;
}

- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact
{
//    @([self getIndexByMask:contact.nodeA.physicsBody.categoryBitMask])
    NSDictionary *nodeA = @{@"name":contact.nodeA.name,@"mask":@([self getIndexByMask:contact.nodeA.physicsBody.categoryBitMask])};
    NSDictionary *nodeB = @{@"name":contact.nodeB.name,@"mask":@([self getIndexByMask:contact.nodeB.physicsBody.categoryBitMask])};
    [self fireEvent:@"contact" params:@{@"nodes":@{@"nodeA":nodeA,@"nodeB":nodeB}}];
     NSLog(@"hit test");
}

-(void)removeNode:(NSString *)name
{
    for(SCNNode *node in _sceneView.scene.rootNode.childNodes){
        if([node.name isEqualToString:name]){
            [self removeNodeWithAnimation:node];
            
        }
    }
}

-(void)removeNodeWithAnimation:(SCNNode *)node
{
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [node removeFromParentNode];
        NSLog(@"%@",node.name);
        [self fireEvent:@"removeNode" params:@{@"node":@{@"name":node.name}}];
        
    });
    
}

@end
