//
//  WXModelComponent.m
//  WeexAr
//
//  Created by 齐山 on 2017/9/14.
//

#import "WXModelComponent.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import "SSZipArchive.h"

WX_PlUGIN_EXPORT_COMPONENT(model,WXModelComponent)

@interface WXModelComponent()
@property (nonatomic, copy) NSString *path;
@end


@implementation WXModelComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        self.componentType = WXComponentTypeVirtual;
        self.node = [SCNNode new];
        [self _downloadAssentsWithURL:[NSURL URLWithString:attributes[@"src"]]];
        self.path = attributes[@"path"];
        self.node.position =SCNVector3Make([WXConvert CGFloat: [styles objectForKey:@"x"]] , [WXConvert CGFloat: [styles objectForKey:@"y"]], [WXConvert CGFloat: [styles objectForKey:@"z"]]);
        
        if(styles[@"scale"]){
            CGFloat scale = [WXConvert CGFloat:styles[@"scale"]];
            self.node.scale = SCNVector3Make(scale, scale, scale);
        }
    }
    return self;
}

- (void )_downloadAssentsWithURL:(NSURL *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url
                                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    
                                                    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                    NSString *documentsDirectory = [paths objectAtIndex:0];
                                                    NSString *inputPath = [documentsDirectory stringByAppendingPathComponent:@"/test.zip"];
                                                    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:inputPath] error:nil];
                                                    
                                                    NSError *zipError = nil;
                                                    
                                                    [SSZipArchive unzipFileAtPath:inputPath toDestination:documentsDirectory overwrite:YES password:nil error:&zipError];
                                                    
                                                    if( zipError ){
                                                        NSLog(@"Something went wrong while unzipping: %@", zipError.debugDescription);
                                                    }else {
                                                        NSLog(@"Archive unzipped successfully");
                                                        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:self.path];
                                                        
                                                        SCNScene *scene = [SCNScene sceneWithURL:documentsDirectoryURL options:nil error:nil];
                                                        NSArray *nodeArray = [scene.rootNode childNodes];
                                                        for (SCNNode *eachChild in nodeArray) {
                                                            [self.node addChildNode:eachChild];
                                                        }
                                                    
                                                    }
                                                }];
    [task resume];

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
