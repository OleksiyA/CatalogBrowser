//
//  RDItemDetailsViewController.m
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/19/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RDItemDetailsViewController.h"
#import "CatalogItemDetails.h"

@implementation RDItemDetailsViewController

#pragma mark Internal interface
-(void)showWaitingView:(BOOL)animated
{
    [self.navigationController.view addSubview:self.waitingView];
    
    self.waitingView.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    
    if(animated)
    {
        self.waitingView.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.waitingView.alpha = 1;
        }];
    }
}

-(void)hideWaitingView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.waitingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.waitingView removeFromSuperview];
    }];
}

-(void)setupContents
{
    [self showWaitingView:NO];
    
    self.titleTextLabel.text = self.itemDetails.title;
    self.authorTextLabel.text = self.itemDetails.author;
    
    if(self.itemDetails.price)
    {
        if([self.itemDetails.price doubleValue] != round([self.itemDetails.price doubleValue]))
        {
            self.priceTextLabel.text = [NSString stringWithFormat:@"%.2f $",[self.itemDetails.price doubleValue]];
        }
        else
        {
            self.priceTextLabel.text = [NSString stringWithFormat:@"%.0f $",[self.itemDetails.price doubleValue]];
        }
    }
    
    NSURL* url = [NSURL URLWithString:self.itemDetails.image];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData* dataForImage = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitingView];
        });
        
        if([dataForImage length])
        {
            UIImage* image = [UIImage imageWithData:dataForImage];
            if(image.size.width>0 && image.size.height>0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.itemCoverImageView.alpha = 0;
                    self.itemCoverImageView.image = image;
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        self.itemCoverImageView.alpha = 1;
                    }];
                    
                });
            }
        }
    });
}

#pragma mark Allocation and Deallocation
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //remove debug values from UI
    self.titleTextLabel.text = nil;
    self.authorTextLabel.text = nil;
    self.priceTextLabel.text = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setItemCoverImageView:nil];
    [self setTitleTextLabel:nil];
    [self setAuthorTextLabel:nil];
    [self setPriceTextLabel:nil];
    [self setWaitingView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupContents];
}

@end
