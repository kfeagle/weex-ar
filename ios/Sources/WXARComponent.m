//
//  WXARComponent.m
//  WeexAr
//
//  Created by 齐山 on 2017/9/13.
//

#import "WXARComponent.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <WeexSDK/WXUtility.h>
#import <WeexSDK/WXImgLoaderProtocol.h>
#import "WXNodeComponent.h"
#import "SCNNode+Weex.h"

WX_PlUGIN_EXPORT_COMPONENT(ar,WXARComponent)

@interface WXARComponent()<ARSCNViewDelegate,SCNPhysicsContactDelegate,UIGestureRecognizerDelegate,ARSessionDelegate>
@property(nonatomic, strong) ARSCNView* arView;
@property(nonatomic) BOOL planeDetection;
@property(nonatomic) BOOL isDebug;
@property(nonatomic) BOOL lightEstimationEnabled;
@property (nonatomic, strong) id<WXImageOperationProtocol> imageOperation;
@property (nonatomic, strong) ARSession* session;
@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *configuration;
@property (nonatomic, strong) SCNNode *localOrigin;
@property (nonatomic, strong) SCNNode *cameraOrigin;
@property (nonatomic, strong)NSMutableDictionary *nodes; // nodes added to the scene
@property (nonatomic, strong)NSMutableDictionary *planes; // plane detected

@end

@implementation WXARComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        _isDebug = NO;
        _planeDetection = NO;
        _lightEstimationEnabled = NO;
        if (attributes[@"planeDetection"]) {
            _planeDetection = [WXConvert BOOL:attributes[@"planeDetection"]];
        }
        if (attributes[@"lightEstimation"]) {
            _lightEstimationEnabled = [WXConvert BOOL:attributes[@"lightEstimation"]];
        }
        if (attributes[@"debug"]) {
            _isDebug = [WXConvert BOOL:attributes[@"debug"]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    self.arView.delegate = self;
    self.arView.session.delegate = self;
    
    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
    configuration.worldAlignment = ARWorldAlignmentGravity;
    configuration.lightEstimationEnabled = _lightEstimationEnabled;
    configuration.planeDetection = _planeDetection;
    [self.arView.session runWithConfiguration:configuration];
    [self setDebug:_isDebug];
    // configuration(s)
    self.arView.autoenablesDefaultLighting = YES;
    self.arView.scene.rootNode.name = @"root";
    
    // init cahces
    self.nodes = [NSMutableDictionary new];
    self.planes = [NSMutableDictionary new];

    // start ARKit
}

- (BOOL)debug {
    return self.arView.showsStatistics;
}

- (void)setDebug:(BOOL)debug {
    if (debug) {
        self.arView.showsStatistics = YES;
        self.arView.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
    } else {
        self.arView.showsStatistics = NO;
        self.arView.debugOptions = SCNDebugOptionNone;
    }
}

- (UIView *)loadView
{
    if(!_arView){
        ARSCNView *arView = [[ARSCNView alloc] init];
        
        arView.delegate = self;
        _arView = arView;
        _arView.showsStatistics = YES;
        
    }
    return self.arView;
}

- (void)insertSubview:(WXNodeComponent *)subcomponent atIndex:(NSInteger)index
{
    if([subcomponent isKindOfClass:[WXNodeComponent class]]){
        [self addNodeToScene:subcomponent.node key:subcomponent.ref];
    }else{
        [super insertSubview:subcomponent atIndex:index];
    }
}


- (void)addNodeToScene:(SCNNode *)node key:(NSString *)key {
    if (key) {
        node.wx_Identifier = key;
        [self registerNode:node forKey:key];
    }
    [self.arView.scene.rootNode addChildNode:node];
}


#pragma mark -tap
- (void)onClick:(__unused UITapGestureRecognizer *)recognizer
{
    SCNView *sceneView = (SCNView *)recognizer.view ;
    CGPoint touchLocation =  [recognizer locationInView:sceneView];
    NSArray *hitResults = [self.arView hitTest:touchLocation options:nil];
    
    if(hitResults&& [hitResults count]>0){
        
        SCNHitTestResult *res = hitResults[0];
        SCNNode *node =res.node;
        if(node.wx_Identifier){
            [self fireEvent:@"click" params:@{@"key":node.wx_Identifier}];
        }
    }
}

#pragma mark node register

- (void)registerNode:(SCNNode *)node forKey:(NSString *)key {
    [self removeNodeForKey:key];
    [self.nodes setObject:node forKey:key];
}

- (SCNNode *)nodeForKey:(NSString *)key {
    return [self.nodes objectForKey:key];
}

- (void)removeNodeForKey:(NSString *)key {
    SCNNode *node = [self.nodes objectForKey:key];
    if (node == nil) {
        return;
    }
    [node removeFromParentNode];
    [self.nodes removeObjectForKey:key];
}

@end
