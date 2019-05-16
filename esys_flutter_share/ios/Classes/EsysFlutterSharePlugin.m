#import "EsysFlutterSharePlugin.h"

@implementation EsysFlutterSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"channel:github.com/orgs/esysberlin/esys-flutter-share"
            binaryMessenger:[registrar messenger]];
  EsysFlutterSharePlugin* instance = [[EsysFlutterSharePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"text" isEqualToString:call.method]){
      [self text:call];
  }else if([@"file" isEqualToString:call.method]){
      [self file:call];
  }else if([@"files" isEqualToString:call.method]){
      [self files:call];
  }else {
    result(FlutterMethodNotImplemented);
  }
}

- (void) text:(FlutterMethodCall*)call
{
    NSString *textToShare =  call.arguments[@"text"];
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
}

- (void) file:(FlutterMethodCall*)call
{
    NSString *textToShare =  call.arguments[@"name"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *pathString = [paths.firstObject stringByAppendingPathComponent:textToShare];
    NSURL *contentUri = [NSURL fileURLWithPath: pathString];
    NSArray *activityItems = @[contentUri];
     NSLog(@"contentUri ---> %@",contentUri);
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
}

- (void) files:(FlutterMethodCall*)call
{
    NSArray *textToShare  =  call.arguments[@"names"];
    NSMutableArray *activityItems = [NSMutableArray new];
    for (NSString *name in textToShare) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *pathString = [paths.firstObject stringByAppendingPathComponent:name];
        NSURL *contentUri = [NSURL fileURLWithPath: pathString];
        [activityItems addObject:contentUri];
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
}

@end
