//
//  WCRedditCardsTableViewController.m
//  WCRedditCards
//
//  Created by David Xiang on 3/18/15.
//  Copyright (c) 2015 com.trywildcard. All rights reserved.
//

#import "WCRedditCardsTableViewController.h"
@import WildcardSDK;

static const NSUInteger WCRedditCardTableViewCellCardViewTag = 1;

@interface WCRedditCardsTableViewController () <CardViewDelegate>

@property NSMutableArray* redditLinks;
@property NSMutableArray* cardViews;

@end

@implementation WCRedditCardsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize card view array
    self.cardViews = [NSMutableArray array];
    
    // init and load reddit links
    self.redditLinks = [NSMutableArray array];
    [self loadRedditLinks];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0f;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardViews.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"redditCardTableCell"];
    CardView* cardView = [self.cardViews objectAtIndex:indexPath.row];
    
    // remove existing content from re-use
    [[cell.contentView viewWithTag:WCRedditCardTableViewCellCardViewTag] removeFromSuperview];
    
    // add the cardview to the cell's content view, center it horizontally and 10 points from top/bottom
    [cell.contentView addSubview:cardView];
    cardView.translatesAutoresizingMaskIntoConstraints = NO;
    cardView.tag = WCRedditCardTableViewCellCardViewTag;
    [cardView horizontallyCenterToSuperView:0];
    [cardView constrainTopToSuperView:10];
    [cardView constrainBottomToSuperView:10];
    
    return cell;
}

#pragma mark - CardViewDelegate

-(void)cardViewRequestedAction:(CardView *)cardView action:(CardViewAction *)action
{
    // defaults
    [self handleCardAction:cardView action:action];
}

#pragma mark - Action

- (IBAction)refreshButtonTapped:(id)sender {
    [self.cardViews removeAllObjects];
    [self.redditLinks removeAllObjects];
    [self.tableView reloadData];
    [self loadRedditLinks];
}

- (IBAction)addButtonTapped:(id)sender {
    if(self.redditLinks.count == 0){
        [[[UIAlertView alloc]initWithTitle:@"No Reddit Links available! Hit the refresh." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else{
        // 1. grab the a reddit link
        NSURL* url = [self.redditLinks firstObject];
        [self.redditLinks removeObjectAtIndex:0];
        
        // 2. attempt to get a card
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [Card getFromUrl:url completion:^(Card *card, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if(card){
                // 3. got a card, create a card view and insert it up top
                CardView* cardview = [CardView createCardView:card];
                cardview.delegate = self;
                [self.cardViews insertObject:cardview atIndex:0];
                NSIndexPath* rowToInsert = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[rowToInsert] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                // 4. couldn't make one -- we'll get better
                [[[UIAlertView alloc]initWithTitle:@"Couldn't make a card for that =/" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }
}


#pragma mark - Private
-(void)loadRedditLinks
{
    // This function grabs 100 recent reddit links that we can try to make cards out of
    
    NSURL *redditNews = [NSURL URLWithString:@"https://www.reddit.com/new.json?limit=100"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionTask * task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:redditNews] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if(error){
            [[[UIAlertView alloc]initWithTitle:@"Could not load reddit links" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else{
            NSDictionary* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * children = response[@"data"][@"children"];
            
            for (NSDictionary* child in children){
                @try{
                    [self.redditLinks addObject:[NSURL URLWithString:child[@"data"][@"url"]]];
                }
                @catch(NSException *e){
                    continue;
                }
            }
            
            [[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%lu Reddit Links waiting to be cardified!", (unsigned long)self.redditLinks.count] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            [self.tableView reloadData];
        }
    }];
    [task resume];
}



@end
