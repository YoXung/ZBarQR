Read Me About ZBarQR(for 64 bit)
====================================

ZBar bar code reader
--------------------

ZBar is an open source software suite for reading bar codes from various sources, such as video streams, image files and raw intensity sensors. It supports many popular symbologies (types of bar codes) including EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Interleaved 2 of 5 and QR Code.

The flexible, layered implementation facilitates bar code scanning and decoding for any application: use it stand-alone with the included GUI and command line programs, easily integrate a bar code scanning widget into your Qt, GTK+ or PyGTK GUI application, leverage one of the script or programming interfaces (Python, Perl, C++) ...all the way down to a streamlined C library suitable for embedded use.

ZBar is licensed under the GNU LGPL 2.1 to enable development of both open source and commercial projects.


If you want to get more, please visit http://zbar.sourceforge.net/index.html



How to use ZBar for QR code reader ?
------------------------------------
Here for download : https://sourceforge.net/projects/zbar/files/iPhoneSDK/beta/
Here for get API  : http://zbar.sourceforge.net/iphone/sdkdoc/tutorial.html



Nessary frameworks
------------------
AVFoundation.framework
CoreMedia.framework
CoreVideo.framework
QuartzCore.framework
libiconv.dylib(<iOS 9)
libiconv.tbd(>iOS 9)



What this sample solve ?
------------------------
1. We know the latest ZBarSDK version is '1.3.1' (2012).
   which is not support for arm64 iOS devices.
   Since I recompiled the SDK for both simulators and iOS device in arm64, we can
   keep on developing using ZBarSDK.

2. For Chinese users, ZBarSDK cannot read QR Code generating by Chinese sometimes.
   So I recompiled the encoding with GB18030 to solve this embarassment.

Copy the 'libzbar.a' into your project to start QR code work!!


How to generate QR code ?
-------------------------
In this sample, we use "libqrencode".(Something about libqrencode, please Google online)



Credits and Version History
---------------------------
If you find any problems with this sample, please file a bug against it.

<Email : 89034550@qq.com>

1.0 (Nov 2015) was the first shipping version.
1.1 (Jan 2016) added custom view for scanning QR code.
1.2 (May 2016) added custom popView.
1.3 (Jun 2016) use CocoaPods 1.0.1.





Share and Enjoy.

YoXung Support
