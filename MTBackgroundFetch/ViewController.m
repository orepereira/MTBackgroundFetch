//
//  ViewController.m
//  MTBackgroundFetch
//
//  Created by Jorge Costa on 10/14/13.
//  Copyright (c) 2013 MobileTuts. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.possibleTableData = [NSArray arrayWithObjects:@"Spicy garlic Lime Chicken",@"Apple Crisp II",@"Eggplant Parmesan II",@"Pumpkin Ginger Cupcakes",@"Easy Lasagna", @"Puttanesca", @"Alfredo Sauce", nil];
    
    self.navigationItem.title = @"Delicious Dishes";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(insertNewObject:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
}

- (void)insertNewObject:(id)sender
{
    self.numberOfnewPosts = [self getRandomNumberBetween:0 to:4];
    NSLog(@"%d new fetched objects",self.numberOfnewPosts);
    
    for(int i = 0; i < self.numberOfnewPosts; i++){
        int addPost = [self getRandomNumberBetween:0 to:(int)([self.possibleTableData count]-1)];
        [self insertObject:[self.possibleTableData objectAtIndex:addPost]];
    }
    [self.refreshControl endRefreshing];
    
}

- (void)insertObject:(id)newObject
{
    [self.objects insertObject:newObject atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}


-(NSMutableArray *)objects
{
    if (_objects == nil) {
        _objects = [[NSMutableArray alloc] init];
    }
    return _objects;
}

#pragma mark - Table view delegate/data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.objects[indexPath.row];
    
    if(indexPath.row < self.numberOfnewPosts){
        cell.backgroundColor = [UIColor yellowColor];
    }
    else
        cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)insertNewObjectForFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Update the tableview.");
    
    self.numberOfnewPosts = [self getRandomNumberBetween:0 to:4];
    NSLog(@"%d new fetched objects",self.numberOfnewPosts);

    for(int i = 0; i < self.numberOfnewPosts; i++){
        int addPost = [self getRandomNumberBetween:0 to:(int)([self.possibleTableData count]-1)];
        [self insertObject:[self.possibleTableData objectAtIndex:addPost]];
    }

    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
