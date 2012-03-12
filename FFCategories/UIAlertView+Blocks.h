//
//  UIAlertView+Blocks.h
//  Copyright (c) 2011 Firefly Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView(Blocks) <UIAlertViewDelegate>

typedef void (^DismissBlock)(int buttonIndex);
typedef void (^CancelBlock)();

+ (UIAlertView *) alertViewWithTitle:(NSString *)title
							 message:(NSString *)message
				   cancelButtonTitle:(NSString *)cancelButtonTitle
				   otherButtonTitles:(NSArray *)otherButtonTitles
						   onDismiss:(DismissBlock)dismissed
							onCancel:(CancelBlock)cancelled;


@end
