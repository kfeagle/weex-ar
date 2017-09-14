//
//  SCNNode+Weex.m
//  WeexAr
//
//  Created by 齐山 on 2017/9/13.
//

#import "SCNNode+Weex.h"

static char wx_IdentifierKey;

@implementation SCNNode (Weex)

-(void)setWx_Identifier:(NSString *)wx_Identifier
{
    objc_setAssociatedObject(self, &wx_IdentifierKey, wx_Identifier, OBJC_ASSOCIATION_COPY);
}

-(NSString *)wx_Identifier
{
    return objc_getAssociatedObject(self, &wx_IdentifierKey);
}
@end
