//
//  WXModelComponent.m
//  WeexAr
//
//  Created by 齐山 on 2017/9/14.
//

#import "WXModelComponent.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <ZipArchive/ZipArchive.h>
#import <WeexSDK/WXUtility.h>

WX_PlUGIN_EXPORT_COMPONENT(model,WXModelComponent)
#define WX_MODEL_DOWNLOAD_DIR [NSString stringWithFormat:@"%@/wxdownload",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@interface WXModelComponent()
    @property (nonatomic, copy) NSString *path;
    @property (nonatomic, copy) NSString *fileName;
    @end


@implementation WXModelComponent
    
- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
    {
        self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
        if (self) {
            
            self.componentType = WXComponentTypeVirtual;
            self.node = [SCNNode new];
            self.path = attributes[@"path"];
            [self _downloadAssentsWithURL:[NSURL URLWithString:attributes[@"src"]]];
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
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.zip",[WXUtility md5:[url absoluteString]]]];
        self.fileName = [WXUtility md5:[url absoluteString]];
        NSString *download = [NSString stringWithFormat:@"%@/%@",WX_MODEL_DOWNLOAD_DIR,self.fileName];
        if ([WXUtility isFileExist:download]) {
            [self parseNode];
            return;
        }
        typeof(self) __weak weakSelf = self;
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url
                                                    completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:zipPath] error:nil];
                                                        ZipArchive* zip = [[ZipArchive alloc] init];
                                                        if( [zip UnzipOpenFile:zipPath] )
                                                        {
                                                            BOOL ret = [zip UnzipFileTo:download overWrite:YES];
                                                            [zip UnzipCloseFile];
                                                            if( NO==ret) {
                                                                WXLogError(@"Something went wrong while unzipping");
                                                            }else{
                                                                [weakSelf parseNode];
                                                            }
                                                        }
                                                    }];
        [task resume];
    }
    
-(void)parseNode
    {
        NSString *documentsDirectory = [NSString stringWithFormat:@"%@/%@/%@",WX_MODEL_DOWNLOAD_DIR,self.fileName,self.path];
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsDirectory];
        SCNScene *scene = [SCNScene sceneWithURL:documentsDirectoryURL options:nil error:nil];
        NSArray *nodeArray = [scene.rootNode childNodes];
        for (SCNNode *eachChild in nodeArray) {
            [self.node addChildNode:eachChild];
        }
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

