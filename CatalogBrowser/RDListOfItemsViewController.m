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

-(void)activateDetailsViewControllerCatalogItem:(CatalogItem*)catalogItem
{
    [self performSegueWithIdentifier:@"showItemDetails" sender:catalogItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isKindOfClass:[CatalogItem class]])
    {
        CatalogItem* catalogItem = (CatalogItem*)object;
        if(catalogItem.itemDetails)
        {
            [catalogItem removeObserver:self forKeyPath:@"itemDetails" context:NULL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideWaitingView];
                [self activateDetailsViewControllerCatalogItem:catalogItem];
                
            });
        }
    }
}

-(void)handleUserRequestedDetailsForNotYetLoadedItemForCell:(RDItemCell*)cell
{
    if(!cell)
    {
        NSLog(@"Nil cell was passed.");
        return;
    }
    
    [self showWaitingView:YES];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForCell:cell] animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        CatalogItem* catalogItem = cell.catalogItem;
        
        if(!catalogItem.itemDetails)
        {
            [catalogItem addObserver:self forKeyPath:@"itemDetails" options:0 context:NULL];
        }
        else
        {
            [self activateDetailsViewControllerCatalogItem:catalogItem];
        }
        
    });
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
    
    [self setWaitingView:nil];
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

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"showItemDetails"])
    {
        //extract activated item
        CatalogItem* catalogItem = nil;
        RDItemCell* cell = nil;
        
        if([sender isKindOfClass:[RDItemCell class]])
        {
            cell = (RDItemCell*)sender;
            
            catalogItem = cell.catalogItem;
        }
        else
        {
            catalogItem = (CatalogItem*)sender;
        }
        
        CatalogItemDetails* details = catalogItem.itemDetails;
        
        if(!details)
        {
            [self handleUserRequestedDetailsForNotYetLoadedItemForCell:cell];
            
            return NO;
        }
    }
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showItemDetails"])
    {
        //extract activated item
        CatalogItem* catalogItem = nil;
        
        if([sender isKindOfClass:[RDItemCell class]])
        {
            RDItemCell* cell = (RDItemCell*)sender;
            
            catalogItem = cell.catalogItem;
        }
        else
        {
            catalogItem = (CatalogItem*)sender;
        }
        
        //configure item details view controller
        RDItemDetailsViewController* itemDetailsVC = (RDItemDetailsViewController*)[segue destinationViewController];
        
        CatalogItemDetails* details = catalogItem.itemDetails;
        
        if(details)
        {
            NSLog(@"Relationship are not loaded.");
        }
        
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
    RDItemCell *cell = nil;
    
    if([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)])
    {
        cell = (RDItemCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        cell = (RDItemCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    CatalogItem* catalogItem = (CatalogItem*)[self.fetchResultController objectAtIndexPath:indexPath];
    
    [cell setNewItem:catalogItem];
    
    return cell;
}

#pragma mark NSFetchedResultsControllerDelegate methods
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
