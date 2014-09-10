//
//  YSTableViewController.m
//  SampleProject
//
//  Created by Federico Erostarbe on 5/12/13.
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import "YSTableViewController.h"
#import "UIScrollView+YSPanel.h"
#import "YSTableViewCell.h"
#import "NSArray+JSON.h"

#define kCellIdentifier @"YSCell"

@interface YSTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *stories;

@end

@implementation YSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"works" ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    _stories = [NSArray arrayWithJSONString:content];

    __weak YSTableViewController *weakSelf = self;
    [_tableView addTableViewPanelWithBlock:^(CGPoint location, NSIndexPath *indexPath) {
        NSDictionary *storyDictionary = _stories[indexPath.row];
        weakSelf.tableView.panelView.titleLabel.text = [NSString stringWithFormat:@"written in \n%@", storyDictionary[@"written"]];
    }];
}

#pragma mark UITableView protocol

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _stories.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSTableViewCell *cell = (YSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[YSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    NSDictionary *storyDictionary = _stories[indexPath.row];
    cell.storyLabel.text = storyDictionary[@"name"];
    cell.coauthorLabel.text = storyDictionary[@"coauthor"];
    return cell;
}

@end
