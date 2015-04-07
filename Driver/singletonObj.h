//
//  singletonObj.h
//  Driver
//
//  Created by  on 2012/8/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface singletonObj : NSObject

@property(nonatomic) BOOL setting;
@property(nonatomic) BOOL unfold;
@property(nonatomic) BOOL showHidepassengerUpBtn;
@property(nonatomic) BOOL setstarton;



+(singletonObj *)singleObj;

@end
