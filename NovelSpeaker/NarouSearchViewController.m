//
//  NarouSearchViewController.m
//  NovelSpeaker
//
//  Created by 飯村卓司 on 2014/07/03.
//  Copyright (c) 2014年 IIMURA Takuji. All rights reserved.
//

#import "NarouSearchViewController.h"
#import "NarouSearchResultTableViewController.h"
#import "NarouLoader.h"

@interface NarouSearchViewController ()

@end

@implementation NarouSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_SearchResult = nil;
    m_MainQueue = dispatch_get_main_queue();
    m_SearchQueue = dispatch_queue_create("com.limuraproducts.novelspeaker.search", NULL);
    self.SearchTextBox.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"next view load!");
    // 次のビューをloadする前に呼び出してくれるらしいので、そこで検索結果を放り込みます。
    if ([[segue identifier] isEqualToString:@"searchResultPushSegue"]) {
        NSLog(@"set SearchResultList!!!");
        NarouSearchResultTableViewController* nextViewController = [segue destinationViewController];
        nextViewController.SearchResultList = m_SearchResult;
    }
}

// 検索ボタンがクリックされた
- (IBAction)SearchButtonClicked:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"searching" message:@"now searching" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    dispatch_async(m_SearchQueue, ^{
        NSArray* searchResult = [NarouLoader Search:self.SearchTextBox.text wname:self.WriterSwitch.on title:self.TitleSwitch.on keyword:self.KeywordSwitch.on ex:self.ExSwitch.on];
        m_SearchResult = searchResult;
        dispatch_async(m_MainQueue, ^{
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            NSLog(@"search end. count: %lu", [m_SearchResult count]);
            [self performSegueWithIdentifier:@"searchResultPushSegue" sender:self];
        });
    });
}

// テキストフィールドでEnterが押された
- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    // キーボードを閉じる
    [sender resignFirstResponder];
    
    return TRUE;
}

@end