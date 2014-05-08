//
//  LINEActivity.m
//
//  Created by Noda Shimpei on 2012/12/04.
//  Copyright (c) 2012年 @noda_sin. All rights reserved.
//

#import "LINEActivity.h"

@implementation LINEActivity

- (NSString *)activityType {
    return @"jp.naver.LINEActivity";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"LINEActivityIcon.png"];
}

- (NSString *)activityTitle
{
    return @"LINE";
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSString class]] || [activityItem isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([self openLINEWithItem:activityItem])
            break;
    }
}

- (BOOL)isUsableLINE
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]];
}

- (void)openLINEOnITunes
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/jp/app/line/id443904275?ls=1&mt=8"]];
}

- (BOOL)openLINEWithItem:(id)item
{
    if (![self isUsableLINE]) {
        [self openLINEOnITunes];
        return NO;
    }
    
    NSString *LINEURLString = nil;
    if ([item isKindOfClass:[NSString class]]) {
        NSString *urlEncodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)item, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
        LINEURLString = [NSString stringWithFormat:@"line://msg/text/%@", urlEncodeString];
    } else if ([item isKindOfClass:[UIImage class]]) {
        UIPasteboard *pasteboard;
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
            pasteboard = [UIPasteboard generalPasteboard];
        } else {
            pasteboard = [UIPasteboard pasteboardWithUniqueName];
        }
        [pasteboard setData:UIImagePNGRepresentation(item) forPasteboardType:@"public.png"];
        LINEURLString = [NSString stringWithFormat:@"line://msg/image/%@", pasteboard.name];
    } else {
        return NO;
    }
    
    NSURL *LINEURL = [NSURL URLWithString:LINEURLString];
    [[UIApplication sharedApplication] openURL:LINEURL];
    return YES;
}

@end
