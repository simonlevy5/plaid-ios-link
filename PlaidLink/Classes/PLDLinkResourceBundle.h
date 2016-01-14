//
//  PLDLinkResourceBundle.h
//  Pods
//
//  Created by Simon Levy on 1/14/16.
//
//

#import <Foundation/Foundation.h>

/**
 This subclass of NSBundle overrides |mainBundle| to load the packaged resource bundle for this
 pod. To load the bundle containined assets and strings for the plaid-ios-link use the following
 code:
 
 #import "PLDLinkResourceBundle.h"
 
 // method def
 NSBundle *resources = [PLDLinkResourceBundle mainBundle];
 
 // end method def
 
 */
@interface PLDLinkResourceBundle : NSBundle
@end
