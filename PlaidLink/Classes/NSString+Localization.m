//
//  NSString+Localization.m
//  Pods
//
//  Created by Simon Levy on 1/14/16.
//
//

#import "NSString+Localization.h"

#import "PLDLinkResourceBundle.h"

static NSString * const kStringsFile = @"Localizable";

@implementation NSString (Localization)

+ (NSString *)stringWithIdentifier:(NSString *)identifier {
  NSBundle *resource = [PLDLinkResourceBundle mainBundle];
  return [resource localizedStringForKey:identifier value:identifier table:kStringsFile];
}

@end
