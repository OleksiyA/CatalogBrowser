//
//  RDListOfItemsViewController.m
//  CatalogBrowser
//
//  Created by Oleksiy Ivanov on 2/19/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RDListOfItemsViewController.h"
#import "CatalogItem.h"
#import "RDItemCell.h"
#import "RDItemDetailsViewController.h"
#import "RDAppDelegate.h"
#import "RDCatalogModel.h"

@interface RDListOfItemsViewController()<NSFetchedResultsControllerDelegate>

@property(strong)NSFetchedResultsController*        fetchResultController;

@end

@implementation RDListOfItemsViewController

#pragma mark Internal interface
-(void)setupFetchResultController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CatalogItem"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"itemID" ascending:NO]];
    
    //fetchRequest.fetchLimit = 50;
    
    self.fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[(RDAppDelegate*)[[UIApplication sharedApplication] delegate]model] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchResultController.delegate = self;
}

#pragma mark Allocation and Deallocation
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupFetchResultController];
}

-(void)viewDidUnload
{
    self.fetchResultController.delegate = nil;
    self.fetchResultController = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError* error = nil;
        [self.fetchResultController performFetch:&error];
        if(error)
        {
            NSLog(@"fetch error [%@].",error);
        }
        
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showItemDetails"])
    {
        //extract activated item
        RDItemCell* cell = (RDItemCell*)sender;
        
        CatalogItem* catalogItem = cell.catalogItem;
        
        //configure item details view controller
        RDItemDetailsViewController* itemDetailsVC = (RDItemDetailsViewController*)[segue destinationViewController];
        
        CatalogItemDetails* details = catalogItem.itemDetails;
        
        itemDetailsVC.itemDetails = details;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchResultController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"itemCell";
    RDItemCell *cell = (RDItemCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CatalogItem* catalogItem = (CatalogItem*)[self.fetchResultController objectAtIndexPath:indexPath];
    
    [cell setNewItem:catalogItem];
    
    return cell;
}

#pragma mark - Table view delegate

#if 0
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#endif

#pragma mark NSFetchedResultsControllerDelegate methods
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
