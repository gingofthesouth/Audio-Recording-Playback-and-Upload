//
//  ViewController.h
//  Audio Recording and Playback
//
//  Created by Ernest Cunningham on 26/01/15.
//  Copyright (c) 2015 Icy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate, NSURLSessionTaskDelegate>
{
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, retain) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, retain) NSString *audioFilePath;


@end

