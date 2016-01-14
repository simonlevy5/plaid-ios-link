//
//  NSString+Localization.h
//  Pods
//
//  Created by Simon Levy on 1/14/16.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Localization)

/**
 Loads a localized string with the given identifier from the Localizable.strings file.

 @param The identifier for the desired string.
 @return The localized string.
 */
+ (NSString *)stringWithIdentifier:(NSString *)identifier;

@end
