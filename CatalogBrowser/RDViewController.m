//
//  RDViewController.m
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/17/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RDViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.topLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.topLabel.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.topLabel.layer.shadowOpacity = 0.6;
    self.topLabel.layer.shadowRadius = 2.0;
    
    self.buttonGo.layer.shadowColor = [UIColor blackColor].CGColor;
    self.buttonGo.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.buttonGo.layer.shadowOpacity = 0.6;
    self.buttonGo.layer.shadowRadius = 2.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setButtonGo:nil];
    [self setTopLabel:nil];
    [super viewDidUnload];
}
@end
