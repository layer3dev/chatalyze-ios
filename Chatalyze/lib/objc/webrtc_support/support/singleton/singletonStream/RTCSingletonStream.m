

//
//  RTCSingletonStream.m
//  Chatalyze
//
//  Created by Sumant Handa on 23/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

#import "RTCSingletonStream.h"

@implementation RTCSingletonStream


+(RTCSingletonStream *)sharedInstance
{
    static RTCSingletonStream *myInstance = nil;
    
    if(myInstance == nil)
    {
        myInstance = [[[self class] alloc] init];
        [myInstance initialization];
    }
    
    return myInstance;
}

-(void)initialization{
    
}

@end
