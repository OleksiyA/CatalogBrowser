//
//  RDCatalogClient.h
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/21/13.
//  Copyright (c) 2013 Oleksiy Ivanov.
//  The MIT License (MIT).
//

#import <UIKit/UIKit.h>
#import "AFRESTClient.h"
#import "AFIncrementalStore.h"

@interface RDCatalogClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (RDCatalogClient *)sharedClient;

@end
