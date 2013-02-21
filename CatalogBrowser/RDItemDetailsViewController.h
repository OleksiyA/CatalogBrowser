//
//  RDItemDetailsViewController.h
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/19/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CatalogItemDetails;

@interface RDItemDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *itemCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTextLabel;
@property (strong, nonatomic) IBOutlet UIView *waitingView;

@property (strong)CatalogItemDetails*           itemDetails;

@end
