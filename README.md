<h2>Wildcard iOS SDK</h2>

<h3>Building</h3>

All targets are included in **WildcardSDKProject.xcodeproj**

<h4>TARGETS</h4>

<h5>Framework</h5>
* Set target to **Framework**
* Clean/Build
* **WildcardSDK.framework** should be placed in project directory and your desktop
* This is a multiplatform framework that should be distributed

<h5>WildcardSDK</h5>

Core SDK

<h5>WildcardSDKTests</h5>

Unit tests on Core SDK

<h5>WildcardSDKTestApp</h5>

Simple app in the project to test and dev the framework


<h3>How to add WildcardSDK.framework to any Xcode proj</h3>

Documenting these steps, since it turned out to be kind of tricky ...

- Go to Project Manager->Chose your Target->General Tab
- In Embedded Binaries, drag and drop **WildcardSDK.framework**
- Go to **Build Settings**, search for **Embedded Content Contains Swift Code** and set it to **YES**

If your project is already Swift-enabled you're done.

Else,

- First try building and running, it might just work. 
- If not, open up a terminal and find your target executable
- Check which Swift dynamic Libraries are being using by ```otool -L <target>```
- Should see paths to a bunch of **libSwift*** stuff
- If you don't see it, add dummy Swift File to your target from Xcode, and add

```
import Foundation
import UIKit
```

- This should enable your target executable to try to link the Swift dynamic libraries, you can check again with the otool command
- Double check your app runs with WildcardSDK.framework on simulator and device
