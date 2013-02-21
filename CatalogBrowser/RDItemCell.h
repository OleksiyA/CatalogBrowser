//
//  RDItemCell.h
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/21/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CatalogItem;

@interface RDItemCell : UITableViewCell

@property(strong)CatalogItem*           catalogItem;

-(void)setNewItem:(CatalogItem*)item;

@end
