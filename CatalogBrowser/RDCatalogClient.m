//
//  RDCatalogClient.m
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/21/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RDCatalogClient.h"
#import "RDDefinitions.h"
#import "CatalogItem.h"

@implementation RDCatalogClient

+ (RDCatalogClient *)sharedClient {
    static RDCatalogClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAFCatalogAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - AFIncrementalStore

- (NSURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest
                             withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *mutableURLRequest = nil;
    if ([fetchRequest.entityName isEqualToString:@"CatalogItem"])
    {
        mutableURLRequest = [self requestWithMethod:@"GET" path:@"/api/v10/items" parameters:nil];
    }
    else if([fetchRequest.entityName isEqualToString:@"CatalogItemDetails"])
    {
        NSLog(@"Requesting CatalogItemDetails, fetch request [%@].",fetchRequest);
    }
    
    return mutableURLRequest;
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
                                 fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    if ([entity.name isEqualToString:@"CatalogItem"])
    {
        [mutablePropertyValues setValue:[NSNumber numberWithInteger:[[representation valueForKey:@"id"] integerValue]] forKey:@"itemID"];
        [mutablePropertyValues setValue:[representation valueForKey:@"link"] forKey:@"link"];
        [mutablePropertyValues setValue:[representation valueForKey:@"title"] forKey:@"title"];
    }
    else if ([entity.name isEqualToString:@"CatalogItemDetails"])
    {
        [mutablePropertyValues setValue:[NSNumber numberWithInteger:[[representation valueForKey:@"id"] integerValue]] forKey:@"itemID"];
        [mutablePropertyValues setValue:[representation valueForKey:@"image"] forKey:@"image"];
        [mutablePropertyValues setValue:[representation valueForKey:@"title"] forKey:@"title"];
        [mutablePropertyValues setValue:[representation valueForKey:@"author"] forKey:@"author"];
        [mutablePropertyValues setValue:[NSNumber numberWithDouble:[[representation valueForKey:@"price"] doubleValue]] forKey:@"price"];
    }
    
    return mutablePropertyValues;
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription * destinationEntity = relationship.destinationEntity;
    
    if([[destinationEntity name]isEqualToString:@"CatalogItemDetails"])
    {
        return YES;
    }
    
    return NO;
}

- (NSURLRequest *)requestWithMethod:(NSString *)method
                pathForRelationship:(NSRelationshipDescription *)relationship
                    forObjectWithID:(NSManagedObjectID *)objectID
                        withContext:(NSManagedObjectContext *)context
{
    NSEntityDescription * destinationEntity = relationship.destinationEntity;
    
    if([[destinationEntity name]isEqualToString:@"CatalogItemDetails"])
    {
        NSManagedObject *object = [context objectWithID:objectID];
        if([object isKindOfClass:[CatalogItem class]])
        {
            CatalogItem* catalogItemRelationSource = (CatalogItem*)object;
            
            return [self requestWithMethod:method path:catalogItemRelationSource.link parameters:nil];
        }
    }
    
    return [super requestWithMethod:method
                pathForRelationship:relationship
                    forObjectWithID:objectID
                        withContext:context];
}

@end
