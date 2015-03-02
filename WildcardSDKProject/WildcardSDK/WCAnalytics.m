//
//  WCAnalytics.m
//  WildcardSDKProject
//
//  Created by David Xiang on 1/28/15.
//
//

#import "WCAnalytics.h"
#import "Mixpanel.h"
#import <WildcardSDK/WildcardSDK-Swift.h>

static NSString* WildcardSDKMixPanelToken = @"d7250e25e828b7c00158b28ec8d7525f";

@interface WCAnalytics ()

@property Mixpanel* mp;
@property NSString* apiKey;

@end

@implementation WCAnalytics

- (instancetype)initWithKey:(NSString *)apiKey
{
    self = [super init];
    if(self){
        _mp = [[Mixpanel alloc]initWithToken:WildcardSDKMixPanelToken andFlushInterval:0];
        [_mp identify:apiKey];
        _apiKey = apiKey;
        
    }
    return self;
}

-(void)timeEvent:(NSString *)event
{
    [self.mp timeEvent:event];
}

-(void)trackEvent:(NSString*)event withProperties:(NSDictionary*)properties
{
    [self trackEvent:event withProperties:properties withCard:nil];
}

-(void)trackEvent:(NSString*)event withProperties:(NSDictionary*)properties withCard:(Card*)card
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    dictionary[@"apiKey"] = self.apiKey;
    
    if(card != nil){
        dictionary[@"cardType"] = card.cardType;
        dictionary[@"webURL"] = card.webUrl.absoluteString;
        
        if([card isKindOfClass:[ArticleCard class]]){
            ArticleCard* articleCard = (ArticleCard*)card;
            dictionary[@"cardTitle"] = articleCard.title;
        }else if([card isKindOfClass:[SummaryCard class]]){
            SummaryCard* summaryCard = (SummaryCard*)card;
            dictionary[@"cardTitle"] = summaryCard.title;
        }
    }
    [dictionary addEntriesFromDictionary:properties];
    [self.mp track:event properties:dictionary];
}

@end
