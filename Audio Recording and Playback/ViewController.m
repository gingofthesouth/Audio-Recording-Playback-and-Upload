/*
 NOTE:
 
 The final purpose of this code is to stage and test recording audio and
 uploading the audio to a remote server. The remote server is using PHP
 to collect that file, save it, then run some reporting logic.
 
 The Steps to complete this are:
 
 Client Side:
 1. Record some audio.
 2. Stop the recording.
 3. Upload the file using NSURLSession
 
 Server Side:
 4. get the request body
 5. Check the file mime type to ensure it is the type you want
 6. Save the request body to file
*/

#define kDestinationURL @"https://yourURL.com/fileUpload.php"

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize audioRecorder, audioFilePath, defaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // File path where the recording will be saved on the iOS device
    audioFilePath = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"reportAudio.m4a"];
    NSURL *outputFileURL = [NSURL fileURLWithPath:audioFilePath];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    NSError *error = nil;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:&error];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    
    // Deal with any errors
    if (error)
        NSLog(@"error: %@", [error localizedDescription]);
    else
        [audioRecorder prepareToRecord];
    
    // Check to see if we have permission to use the microphone.
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                NSLog(@"Mic access granted");
            }
            else {
                NSLog(@"Mic access NOT granted");
            }
        }];
    }

}
//##################################################################################################//
#pragma mark Record and Playback Methods
//##################################################################################################//
-(IBAction)recordAudio
{
    NSLog(@"Started Recording");
    if (!audioRecorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryRecord error:nil];
        [session setActive:YES error:nil];
        
        // Start recording
        [audioRecorder record];
    }
}
//##################################################################################################//
-(IBAction)stop
{
    NSLog(@"Stop Recording");
    if ([audioRecorder isRecording])
    {
        [audioRecorder stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:NO error:nil];
    }
    else if (audioPlayer.playing)
        [audioPlayer stop];
}
//##################################################################################################//
-(IBAction) playAudio
{
    NSLog(@"Playback");
    if (![audioRecorder isRecording])
    {
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:&error];
        [audioPlayer setDelegate:self];
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [audioPlayer play];
    }
}
//##################################################################################################//
-(IBAction)sendAudio:(id)sender
{
    // Define the Paths
    NSURL *icyURL = [NSURL URLWithString:kDestinationURL];
    
    // Create the Request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:icyURL];
    [request setHTTPMethod:@"POST"];
    
    // Configure the NSURL Session
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.upload"];
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    // Define the Upload task
    NSURLSessionUploadTask *uploadTask = [upLoadSession uploadTaskWithRequest:request fromFile:audioRecorder.url];
    
    // Run it!
    [uploadTask resume];

}
//##################################################################################################//
#pragma mark AVAudioPlayer and AVAudioRecorder Delegate Methods
//##################################################################################################//
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Finished Playing");
}
//##################################################################################################//
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
//##################################################################################################//
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Recorded Successfully");
}
//##################################################################################################//
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}
//##################################################################################################//
#pragma mark NSURLSession Delegate Methods
//##################################################################################################//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received String %@",str);
}
//##################################################################################################//
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    NSLog(@"didSendBodyData: %lld, totalBytesSent: %lld, totalBytesExpectedToSend: %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    
}
//##################################################################################################//
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != NULL) NSLog(@"Error: %@",[error localizedDescription]);
}

//##################################################################################################//
//##################################################################################################//
-(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
//##################################################################################################//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
