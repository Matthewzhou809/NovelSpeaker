//
//  NarouSearchViewController.h
//  NovelSpeaker
//
//  Created by 飯村卓司 on 2014/07/03.
//  Copyright (c) 2014年 IIMURA Takuji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyAlert.h"

@interface NarouSearchViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* m_SearchResult;
    
    dispatch_queue_t m_MainQueue;
    dispatch_queue_t m_SearchQueue;
    
    EasyAlert* m_EasyAlert;
    
    NSArray* m_SearchOrderTargetList;
    NSDictionary* m_SearchOrderTargetTextMap;
}
@property (weak, nonatomic) IBOutlet UITextField *SearchTextBox;
@property (weak, nonatomic) IBOutlet UISwitch *WriterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *TitleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *ExSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *KeywordSwitch;
@property (weak, nonatomic) IBOutlet UIPickerView *SearchOrderPickerView;

@end
