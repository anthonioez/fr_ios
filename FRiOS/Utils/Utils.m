

#import "Utils.h"

@implementation Utils

+ (void) message:(NSString *)title :(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}


+ (void) showMessage: (NSString *) title message:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

+ (NSString *) dateFormat: (long) stamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSString *) dateTimeFormat: (long) stamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSString *)durationFormat:(long)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = (int)(totalSeconds / 3600);
 
    if(hours == 0)
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    else
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

+ (NSString *) byteFormat:(long)value;
{
    NSString *str;
    
    double fvalue = (float)value;
    long long v = (long long)fabs(fvalue);
    //long long tb = GB;
    
    //tb *= KB;
    
    /*if(v >= tb)
     {
     fvalue = fvalue / (float)(tb);
     str = [NSString stringWithFormat:@"%.02f TBB", fvalue];
     }
     else */
    if(v >= GB)
    {
        fvalue = fvalue / (float)(GB);
        str = [NSString stringWithFormat:@"%.02f GB", fvalue];
    }
    else if(v >= MB)
    {
        fvalue = fvalue / (float)(MB);
        str = [NSString stringWithFormat:@"%.02f MB", fvalue];
    }
    else if(v >= KB)
    {
        fvalue = fvalue / (float)(KB);
        str = [NSString stringWithFormat:@"%.02f KB", fvalue];
    }
    else
    {
        str = [NSString stringWithFormat:@"%.00f B", fvalue];
    }
    return str;
}



+ (BOOL) doAction: (NSString *) action mesaage:(NSString *)message
{
    if([action isEqualToString:@"alert"])
    {
        [Utils showMessage:@"Alert!" message:message];
    }
    else if([action isEqualToString:@"error"])
    {
        [Utils showMessage:@"Error!" message:message];
        return NO;
    }
    
    return YES;
}

// A function for parsing URL parameters returned by the Feed Dialog.
+ (NSDictionary*)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

+(NSString*) getSHA1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

+(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL) connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

+ (NSString *) encodeParam:(NSString*)param
{
    NSString *str = [param stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2b"];
    str = [str stringByReplacingOccurrencesOfString:@"=" withString:@"%3b"];
    
    return str;
}

@end

