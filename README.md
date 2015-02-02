# Audio-Recording-Playback-and-Upload
Record audio on in iOS and upload it to a server running PHP. Uses NSURLSession, NSURLSessionUploadTask.

This is example code to demonstrate two things:

1. How to record and playback audio in an ios app.

2. How to upload a file using NSURLSession / NSURLSessionUploadTask and save the file using PHP.

Use this code to figure out how to implement the features in your own project. 
I am not repsonsible for any issues arrising form using this code.

#Instructions:
The code that records and uploads audio from the microphone is in ViewController.m.

To use this code:

1. Download the iOS code and open in Xcode. 

2. Change the constant at the top of ViewController.m to reflect your server address: #define kDestinationURL @"https://yourURL.com/fileUpload.php"
  
3. Place the fileUpload.php file in an accessible directory on your webserver.

4. Edit the $file = 'uploads/recording.m4a'; line in the PHP to the file path you want to save the recording.

5. Compile the iOS application.

6. Press the record button. Choose allow if prompted for access to the microphone.

7. When you have finished recording the audio, pless the stop button. You can then press play to hear the recording.

8. Press the 'Send' button to upload the file to your server.

Now you can point your browser to the location you saved your file to listen to your recorded message.


