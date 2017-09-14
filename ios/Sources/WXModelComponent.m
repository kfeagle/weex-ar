//
//  WXModelComponent.m
//  WeexAr
//
//  Created by 齐山 on 2017/9/14.
//

#import "WXModelComponent.h"
#import <WeexPluginLoader/WeexPluginLoader.h>

WX_PlUGIN_EXPORT_COMPONENT(model,WXModelComponent)

@implementation WXModelComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        self.componentType = WXComponentTypeVirtual;
        
        self.node = [self loadModel:styles[@"src"] nodeName:@"" withAnimation:YES];
        self.node.position =SCNVector3Make([WXConvert CGFloat: [styles objectForKey:@"x"]] , [WXConvert CGFloat: [styles objectForKey:@"y"]], [WXConvert CGFloat: [styles objectForKey:@"z"]]);
        if(styles[@"scale"]){
            CGFloat scale = [WXConvert CGFloat:styles[@"scale"]];
            self.node.scale = SCNVector3Make(scale, scale, scale);
        }
    }
    return self;
}

- (SCNNode *)loadModel:(NSURL *)url nodeName:(NSString *)nodeName withAnimation:(BOOL)withAnimation {
    SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:nil];
    
    SCNNode *node;
    if (nodeName) {
        node = [scene.rootNode childNodeWithName:nodeName recursively:YES];
    } else {
        node = [[SCNNode alloc] init];
        NSArray *nodeArray = [scene.rootNode childNodes];
        for (SCNNode *eachChild in nodeArray) {
            [node addChildNode:eachChild];
        }
    }
    
    if (withAnimation) {
        NSMutableArray *animationMutableArray = [NSMutableArray array];
        SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:url options:@{SCNSceneSourceAnimationImportPolicyKey:SCNSceneSourceAnimationImportPolicyPlayRepeatedly}];
        
        NSArray *animationIds = [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
        for (NSString *eachId in animationIds){
            CAAnimation *animation = [sceneSource entryWithIdentifier:eachId withClass:[CAAnimation class]];
            [animationMutableArray addObject:animation];
        }
        NSArray *animationArray = [NSArray arrayWithArray:animationMutableArray];
        
        int i = 1;
        for (CAAnimation *animation in animationArray) {
            NSString *key = [NSString stringWithFormat:@"ANIM_%d", i];
            [node addAnimation:animation forKey:key];
            i++;
        }
    }
    
    return node;
}

- (void)updateStyles:(NSDictionary *)styles
{
    if(styles[@"color"]){
        SCNNode *node =self.node;
        NSArray *materials= node.geometry.materials;
        for (SCNMaterial *m in materials) {
            m.diffuse.contents = [WXConvert UIColor:styles[@"color"]];
        }
    }
}

@end
