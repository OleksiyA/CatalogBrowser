//
//  RDItemCell.m
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/21/13.
//  Copyright (c) 2013 Oleksiy Ivanov.
//  The MIT License (MIT).
//

#import "RDItemCell.h"
#import "CatalogItem.h"

@implementation RDItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNewItem:(CatalogItem *)item
{
    if (item == self.catalogItem) {
        return;
    }
    
    self.catalogItem = item;
    
    self.textLabel.text = self.catalogItem.title;
}

@end
