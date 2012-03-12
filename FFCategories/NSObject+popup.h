//
//  NSObject+popup.h
//  Firefly Logic iOS Foundation
//
//  Created by Daniel Norton on 10/19/10.
//  Copyright 2010 Firefly Logic. All rights reserved.
//


@interface NSObject(popup)
- (void)popup:(NSString *)message;
- (void)popup:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate;
@end
