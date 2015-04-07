//
//  UIImage+NSCoder.m
//  Driver
//
//  Created by  on 2012/8/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+NSCoder.h"

@implementation UIImage (MyExtensions)

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDataObject:UIImagePNGRepresentation(self)];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    return [self initWithData:[decoder decodeDataObject]];
}

@end