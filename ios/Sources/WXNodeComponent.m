//
//  WXNodeComponent.m
//  WeexAr
//
//  Created by 齐山 on 2017/9/13.
//

#import "WXNodeComponent.h"

@implementation WXNodeComponent
- (id<WXImgLoaderProtocol>)imageLoader
{
    static id<WXImgLoaderProtocol> imageLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageLoader = [WXSDKEngine handlerForProtocol:@protocol(WXImgLoaderProtocol)];
    });
    return imageLoader;
}
@end
