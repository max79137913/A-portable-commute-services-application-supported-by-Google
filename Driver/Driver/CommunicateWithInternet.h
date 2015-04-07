//
//  CommunicateWithInternet.h
//  MentorReservation
//
//  Created by ej04xjp6 on 12/10/7.
//  Copyright (c) 2012年 Robert Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunicateWithInternet : NSObject

+(NSData*)getJsonDataFromUrl:(NSString*)url WithPostParams:(NSDictionary*)params;
+(NSData*)getJsonDataFromUrl:(NSString*)url WithGetParams:(NSDictionary*)params;
@end
