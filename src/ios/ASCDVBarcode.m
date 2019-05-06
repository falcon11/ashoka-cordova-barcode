/********* ASCDVBarcode.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

typedef NS_ENUM (NSUInteger, ImageType) {
    URI,
    BASE64,
};

@interface ASCDVBarcode : CDVPlugin
{
    // Member variables go here.
}

- (void)readBarcode:(CDVInvokedUrlCommand *)command;
@end

@implementation ASCDVBarcode

- (NSArray *)decodeImage:(UIImage *)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    NSDictionary *options = @{
        CIDetectorAccuracy: CIDetectorAccuracyHigh,
    };
    CIContext *context = [CIContext context];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:options];
    if ([[ciImage properties] valueForKey:(NSString *)kCGImagePropertyOrientation] == nil) {
        options = @{ CIDetectorImageOrientation: @1 };
    } else {
        options = @{ CIDetectorImageOrientation: [ciImage.properties valueForKey:(NSString *)kCGImagePropertyOrientation] };
    }
    NSArray *features = [detector featuresInImage:ciImage options:options];
    if (features == nil) {
        return @[];
    }
    NSMutableArray *results = @[].mutableCopy;
    for (CIQRCodeFeature *feature in features) {
        [results addObject:feature.messageString];
    }
    return results;
}

- (void)readBarcode:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult = nil;
    NSDictionary *options = [command.arguments objectAtIndex:0];
    ImageType imageType = [[options objectForKey:@"imageType"] integerValue];
    UIImage *image = nil;
    switch (imageType) {
        case URI: {
            NSString *uri = [options objectForKey:@"uri"];
            image = [UIImage imageWithContentsOfFile:uri];
            break;
        }
        case BASE64: {
            NSString *base64 = [options objectForKey:@"base64"];
            if (![base64 hasPrefix:@"data:image/jpg;base64,"]) {
                base64 = [NSString stringWithFormat:@"data:image/jpg;base64,%@", base64];
            }
            NSURL *url = [NSURL URLWithString:base64];
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
            break;
        }
        default:
            break;
    }
    NSArray *results = [self decodeImage:image];
    if (results != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:results];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
