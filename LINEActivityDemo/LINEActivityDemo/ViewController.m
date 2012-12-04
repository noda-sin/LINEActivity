//
//  ViewController.m
//  LINEActivityDemo
//
//  Created by Noda Shimpei on 2012/12/04.
//  Copyright (c) 2012年 @noda_sin. All rights reserved.
//

#import "ViewController.h"
#import "LINEActivity.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareText:(id)sender {
    [self shareItem:@"test"];
}

- (IBAction)shareImage:(id)sender {
    [self shareItem:[UIImage imageNamed:@"test.png"]];
}

- (void)shareItem:(id)item
{
    NSArray *activityItems = @[item];
    NSArray *applicationActivities = @[[[LINEActivity alloc] init]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    [self presentViewController:activityViewController animated:YES completion:NULL];

}

@end
