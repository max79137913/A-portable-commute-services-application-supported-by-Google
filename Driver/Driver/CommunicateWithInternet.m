#import "CommunicateWithInternet.h"

@implementation CommunicateWithInternet

+(NSData*)getJsonDataFromUrl:(NSString*)url WithGetParams:(NSDictionary*)params {
    
    NSString *myRequestString = @"?";
    for (NSString *key in [params allKeys]) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]];
        myRequestString = [myRequestString stringByAppendingString:keyValue];
        NSLog(@"keyValur:%@ strign:%@", keyValue, myRequestString);
    }
    
    url = [url stringByAppendingString:myRequestString];
    
    NSLog(@"%@", url);
    
    NSURL *_url = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:_url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setTimeoutInterval:30.0];
    
    NSLog(@"1");
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //NSString* strRet = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", strRet);
    
    return data;
}

+(NSData*)getJsonDataFromUrl:(NSString*)url WithPostParams:(NSDictionary*)params
{
    
    NSString *itemAddress= url;
    NSMutableString *post= [[NSMutableString alloc] init];
    
    //building parameters
    for (NSString* key in params) {
        
        NSString *strValue = [NSString stringWithFormat:@"%@",[params objectForKey:key]];
        
        //here we should escape / = + , otherwise, the url parse will going wrong
        strValue = [strValue stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        strValue = [strValue stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        strValue = [strValue stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        //if you need more char escapes refere to http://www.december.com/html/spec/esccodes.html
        
        NSString *current = [NSString stringWithFormat:@"&%@=%@",key,strValue];
        [post appendString: current];
    }
    
    NSURL *urlObj = [NSURL URLWithString: itemAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: urlObj];
    
    NSData *requestData = [NSData dataWithBytes:[post UTF8String] length:strlen([post UTF8String])];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* strRet = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strRet);
    
    return data;
}

@end