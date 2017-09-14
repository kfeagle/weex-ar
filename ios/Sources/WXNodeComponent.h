//
//  WXNodeComponent.h
//  WeexAr
//
//  Created by 齐山 on 2017/9/13.
//

#import <WeexSDK/WeexSDK.h>
#import <ARKit/ARKit.h>

@interface WXNodeComponent : WXComponent
@property (nonatomic, strong) SCNNode *node;
@property (nonatomic, strong) id<WXImageOperationProtocol> imageOperation;
- (id<WXImgLoaderProtocol>)imageLoader;
@end
