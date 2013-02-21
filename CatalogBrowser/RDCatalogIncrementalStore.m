//
//  RDCatalogIncrementalStore.m
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/21/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RDCatalogIncrementalStore.h"
#import "RDCatalogClient.h"

@implementation RDCatalogIncrementalStore

+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

+ (NSManagedObjectModel *)model {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Catalog" withExtension:@"xcdatamodeld"]];
}

- (id<AFIncrementalStoreHTTPClient>)HTTPClient {
    return [RDCatalogClient sharedClient];
}

@end
