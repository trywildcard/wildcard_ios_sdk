//
//  WCAnalytics.h
//  WildcardSDKProject
//
//  Created by David Xiang on 1/28/15.
//
//

#import <Foundation/Foundation.h>

@class Card;

@interface WCAnalytics : NSObject

- (instancetype)initWithKey:(NSString *)apiKey;

-(void)trackEvent:(NSString*)event withProperties:(NSDictionary*)properties withCard:(Card*)card;
-(void)trackEvent:(NSString*)event withProperties:(NSDictionary*)properties;
-(void)timeEvent:(NSString*)event;

@end
