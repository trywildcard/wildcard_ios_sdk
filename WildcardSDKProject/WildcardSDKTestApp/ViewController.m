//
//  ViewController.m
//  WildcardTesting
//
//  Created by Daniel Kerbel on 9/21/15.
//  Copyright (c) 2015 Guidesmob. All rights reserved.
//

#import "ViewController.h"
#import "PostLinkCell.h"
#import <Parse/Parse.h>
@import WildcardSDK;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, CardViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController {
    NSArray *_postsArray;
    NSMutableArray *_cardsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    _cardsArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PostLinkCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"postLinkCell"];
    
    [self getPosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_postsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = _postsArray[indexPath.row];
   // CardView *cardView = _cardsArray[indexPath.row];
    
    PostLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postLinkCell" forIndexPath:indexPath];
    [cell.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.nameLbl.text = @"Spartan App";
    cell.dateLbl.text = @"Generic Date";
    cell.postTextLabel.text = dictionary[@"postText"];
    
    CardView *cardView = [CardView createCardView:_cardsArray[indexPath.row]];
    cardView.delegate = self;
    [cell.containerView addSubview:cardView];
    cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView horizontallyCenterToSuperView:0];
    [cardView constrainTopToSuperView:0];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 600;
}

#pragma mark - CardViewDelegate

-(void)cardViewRequestedAction:(CardView *)cardView action:(CardViewAction *)action
{
    [self handleCardAction:cardView action:action];
}


#pragma mark - Helper Methods

-(void)getPosts
{
    PFQuery *query = [PFQuery queryWithClassName:@"Feed"];
    [query orderByDescending:@"postDate"];
    [query setLimit:10];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _postsArray = [NSArray arrayWithArray:objects];
            [self getCards];
        }
    }];
}

-(void)getCards
{
    __block int count = 0;
    for (NSDictionary *dict in _postsArray) {
        NSURL *url = [NSURL URLWithString:dict[@"postLink"]];
        [Card getFromUrl:url completion:^(Card *card, NSError *error) {
            count++;
            if (card) {

                [_cardsArray addObject:card];
                if (count == _postsArray.count) {
                    [self.tableView reloadData];
                }
            }
        }];
    }
}























@end
