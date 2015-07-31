<h2>Wildcard iOS SDK</h2>

Public SDK documents can be found [here](http://www.trywildcard.com/docs/ios-sdk).

<h3>Building</h3>

All targets are included in **WildcardSDKProject.xcodeproj**

<h4>Project Schemes</h4>

<h5>WildcardSDK</h5>

The Core SDK as an iOS Framework. You normally should not have to select this scheme directly.

<h5>WildcardSDKTestApp</h5>

This should be the scheme primarily used for developerment. This depends on the Core SDK and serves as a test bench to run a simple application to test the SDK code. 

This scheme also includes the **WildcardSDKTests** target which includes all the tests for the SDK. 

<h5>Framework</h5>

The Framework scheme should be used when you are ready to package up the SDK and get it ready for distribution. 

1. Select the Framework scheme (Bullseye icon) and choose iOS Device
2. Clean + Build
3. A custom script is executed which produces packaged Framework files which need to be uploaded to S3. Both files should exist on your desktop after the build is done.

*WildcardSDK.framework.tar.gz*

This is a "fat" framework distribution that developers may use for Simulator + Devices. 

*WildcardSDK_iphoneos.framework.tar.gz*

This is a framework distribution only built for Devices. 

<h3>Demo App</h3>

This repo also contains a demo iOS Application (WCRedditCards) that is used to demonstrate the SDK.

When the SDK is updated, the demo app should also be updated to use the latest code.

1. Use the official [installation steps](http://www.trywildcard.com/docs/ios-sdk/installing) to install the latest SDK into the project. 
2. Run the project, and just sanity check that it still works.
3. Inside the repo execute ```./zip_reddit_proj.sh```
4. This should package up the Reddit App and put the *WCRedditCards.tar.gz* onto your desktop. 
5. This file will also need to be uploaded to S3 since the documentation links to it.


<h3>Uploading</h3>

*Internal Wildcard Use Only*

The files can be uploaded directly via browser.

1. Sign into S3 with Wildcard credentials
2. Navigate to coopkanicstang-development -> ios_sdk
3. Three files need to be uploaded: *WCRedditCards.tar.gz*, *WildcardSDK.framework.tar.gz*, and *WildcardSDK_iphoneos.framework.tar.gz*
4. Once you have tested and packaged up these files, feel free to upload them, and also make sure to mark them as *Public* on S3.


<h3>Future</h3>

*Internal Wildcard Use Only*

* At the moment, everytime Xcode updates, the SDK will have to also be updated and re packaged.

* This has been OK for Xcode6, but Xcode 7 includes *Swift 2* which may have some substantial syntax changes to the language. When Xcode 7 is released, there may have to be a pretty big code change depending on how much of the language changes.




