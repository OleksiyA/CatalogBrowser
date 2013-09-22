//
//  RDItemCell.h
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/21/13.
//  Copyright (c) 2013 Oleksiy Ivanov.
//  The MIT License (MIT).
//

#import <UIKit/UIKit.h>

@class CatalogItem;

@interface RDItemCell : UITableViewCell

@property (strong, nonatomic) CatalogItem *catalogItem;

- (void)setNewItem:(CatalogItem *)item;

@end
