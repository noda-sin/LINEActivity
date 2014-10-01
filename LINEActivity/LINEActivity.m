//
//  LINEActivity.m
//
//  Created by Noda Shimpei on 2012/12/04.
//  Copyright (c) 2012年 @noda_sin. All rights reserved.
//

#import "LINEActivity.h"

@interface LINEActivity ()
@property (copy) NSString *text;
@property (strong) NSURL *url;
@property (strong) UIImage *image;
@end

@implementation LINEActivity
{
    BOOL _performIfLineNotInstalled;
}

- (id)init
{
    if (self = [super init]) {
        _performIfLineNotInstalled = YES;
    }
    return self;
}

- (id)initWithPerformIfLineNotInstalled:(BOOL)performIfLineNotInstalled
{
    if (self = [super init]) {
        _performIfLineNotInstalled = performIfLineNotInstalled;
    }
    return self;
}

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
    if (!_performIfLineNotInstalled && ![self isUsableLINE]) {
        return NO;
    }

    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSString class]] || [activityItem isKindOfClass:[NSURL class]] || [activityItem isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        [self addItem:activityItem];
    }
}

- (void)performActivity
{
    if (!!self.image) {
        [self openLINEWithItem:self.image];
    } else if (!!self.text && !!self.url) {
        NSString *textAndURL = [NSString stringWithFormat:@"%@ %@", self.text, self.url];
        [self openLINEWithItem:textAndURL];
    } else if (!!self.text) {
        [self openLINEWithItem:self.text];
    } else if (!!self.url) {
        [self openLINEWithItem:self.url];
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

- (void)addItem:(id)item
{
    if ([item isKindOfClass:[NSString class]]) {
        self.text = item;
    } else if ([item isKindOfClass:[NSURL class]]) {
        self.url = item;
    } else if ([item isKindOfClass:[UIImage class]]) {
        self.image = item;
    }
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
