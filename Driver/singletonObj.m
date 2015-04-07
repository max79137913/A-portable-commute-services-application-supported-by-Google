//
//  singletonObj.m
//  Driver
//
//  Created by  on 2012/8/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "singletonObj.h"

@implementation singletonObj

@synthesize setting;
@synthesize unfold;
@synthesize showHidepassengerUpBtn;
@synthesize setstarton;

+(singletonObj *)singleObj{
    
    static singletonObj * single=nil;
    
    @synchronized(self)
    {
        if(!single)
        {
            single = [[singletonObj alloc] init];
            
        }
        
    }    
    return single;
}


@end
