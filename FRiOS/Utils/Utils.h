
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

#import <CommonCrypto/CommonDigest.h>

#define KB              (1024)
#define MB              (KB * KB)
#define GB              (KB * KB * KB)
#define TB              (KB * KB * KB * KB)

@interface Utils : NSObject

+ (BOOL)connected;

+ (void) message:(NSString *)title :(NSString *)message;

+ (void) showMessage: (NSString *) title message:(NSString *) message;

+ (BOOL) doAction: (NSString *) action mesaage:(NSString *)message;

+ (NSDictionary*)parseURLParams:(NSString *)query;

+ (NSString *) dateFormat: (long) stamp;

+ (NSString *) dateTimeFormat: (long) stamp;

+ (NSString *) byteFormat:(long)size;

+ (NSString *) durationFormat:(long)totalSeconds;

+ (NSString*) getSHA1:(NSString*)input;

+ (BOOL) isValidEmail:(NSString *)checkString;

+ (NSString *) encodeParam:(NSString*)param;

@end
