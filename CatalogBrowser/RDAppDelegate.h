//
//  RDAppDelegate.h
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/17/13.
//  Copyright (c) 2013 Oleksiy Ivanov.
//  The MIT License (MIT).
//

#import <UIKit/UIKit.h>

@class RDCatalogModel;

@interface RDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong) RDCatalogModel *model;

@end
