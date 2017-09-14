//
//  WXBoxCompnent.m
//  WeexAr
//
//  Created by 齐山 on 2017/9/13.
//

#import "WXBoxCompnent.h"
#import <WeexPluginLoader/WeexPluginLoader.h>

WX_PlUGIN_EXPORT_COMPONENT(box,WXBoxCompnent)

@implementation WXBoxCompnent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        self.componentType = WXComponentTypeVirtual;
        
        SCNBox *box = [SCNBox boxWithWidth:[WXConvert CGFloat: [styles objectForKey:@"width"]] height:[WXConvert CGFloat: [styles objectForKey:@"height"]] length:[WXConvert CGFloat: [styles objectForKey:@"length"]] chamferRadius:[WXConvert CGFloat: [styles objectForKey:@"chamferRadius"]]];
        self.node = [SCNNode nodeWithGeometry:box];
        self.node.position =SCNVector3Make([WXConvert CGFloat: [styles objectForKey:@"x"]] , [WXConvert CGFloat: [styles objectForKey:@"y"]], [WXConvert CGFloat: [styles objectForKey:@"z"]]);
        SCNMaterial * material = [SCNMaterial new];
        if(styles[@"color"]){
            material.diffuse.contents = [WXConvert UIColor:styles[@"color"]];
            NSMutableArray *materials = [NSMutableArray arrayWithObject:material];
            self.node.geometry.materials =materials;
        }
        if(attributes[@"texture"]){
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageOperation = [[weakSelf imageLoader] downloadImageWithURL:attributes[@"texture"] imageFrame:CGRectZero userInfo:@{} completed:^(UIImage *image, NSError *error, BOOL finished) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            return ;
                        }
                        //需要继续优化
                        material.diffuse.contents = image;
                        NSMutableArray *materials = [NSMutableArray arrayWithObject:material];
                        weakSelf.node.geometry.materials =materials;
                    });
                }];
            });
        }
    }
    return self;
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
