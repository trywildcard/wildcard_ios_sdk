<h2>Wildcard iOS SDK</h2>

<h3>Building</h3>

All targets are included in **WildcardSDKProject.xcodeproj**

<h4>TARGETS</h4>

<h5>Framework</h5>

Produces framework packages

* Set target to **Framework**
* Clean/Build
* Script produces one framework package for a "fat" binary that is built for Simulator + Device, and another package that is only built for Device.
* Both should appear on the desktop

<h5>WildcardSDK</h5>

Core SDK. This is an iOS Framework target.

<h5>WildcardSDKTestApp</h5>

Development app in the project to test and dev the framework
