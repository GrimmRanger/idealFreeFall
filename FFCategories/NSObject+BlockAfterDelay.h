//
//  NSObject+BlockAfterDelay.h
//  Live
//
//  Created by Frank Grimmer on 1/28/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(BlockAfterDelay)

- (void)performBlock:(void (^)(void))block 
          afterDelay:(NSTimeInterval)delay;

@end
