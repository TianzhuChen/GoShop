//
//  AudioViewController.h
//  GoShop
//
//  Created by iwinad2 on 13-7-15.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "SwitchControllerBase.h"
#import "ControlPanel.h"
#import "LRCView.h"
#import "AudioPlayer.h"
#import "MusicListView.h"

@interface AudioViewController : SwitchControllerBase<UITableViewDataSource,UITableViewDelegate,LRCViewDelegate>{
//   __strong AVAudioPlayer *player;
    ControlPanel *controlPanel;
    LRCView *lrcPanel;
    AudioPlayer *audioPlayer;
    MusicListView *listPanel;
}
- (IBAction)lrcTest:(id)sender;
- (IBAction)lrcTest1:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
