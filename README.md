## CMPhotoCropEditor

Another fork of [PEPhotoCropEditor](https://github.com/kishikawakatsumi/PEPhotoCropEditor), bugs fixed in Swift.

Image cropping library for iOS, similar to the Photos.app UI.

<img src="https://raw.github.com/imjerrybao/CMPhotoCropEditor/master/Screenshots/ss01.png" alt="ScreenShot 1" width="280px" style="width: 280px;" />&nbsp;<a href="https://vimeo.com/66661806">


## Features
- Both iPhone/iPad available
- Works fine any device orientations
- Support pinch gesture to zoom
- Support rotation gesture

## System requirements
- iOS 5.0 or higher

## Installation
### CocoaPods
`pod 'CMPhotoCropEditor'`

## Usage

**Use view controller component**
```objective-c
 PECropViewController *controller = [[PECropViewController alloc] init];
 controller.delegate = self;
 controller.image = self.imageView.image;
 
 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
 [self presentViewController:navigationController animated:YES completion:NULL];
```

**Or use the crop view directly**
```objective-c
self.cropView = [[PECropView alloc] initWithFrame:contentView.bounds];
[self.view addSubview:self.cropView];
```

### Get the cropped image

**delegate method**
```objective-c
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = croppedImage;
}
```

**retrieve from view directly**
```objective-c
UIImage *croppedImage = self.cropView.croppedImage;
```

### Keep crop aspect ratio while resizing
```objective-c
controller.keepingCropAspectRatio = YES;
```

```objective-c
self.cropView.keepingCropAspectRatio = YES;
```

### Specify crop rect by image size based 
```objective-c
// e.g.) Cropping center square
CGFloat width = image.size.width;
CGFloat height = image.size.height;
CGFloat length = MIN(width, height);
controller.imageCropRect = CGRectMake((width - length) / 2,
                                      (height - length) / 2,
                                      length,
                                      length);
```

```objective-c
// e.g.) Cropping center square
CGFloat width = image.size.width;
CGFloat height = image.size.height;
CGFloat length = MIN(width, height);
self.cropView.imageCropRect = CGRectMake((width - length) / 2,
                                         (height - length) / 2,
                                         length,
                                         length);
```

### Reset back crop rect to original image size and rotation 
```objective-c
[controller resetCropRect];
```

```objective-c
[self.cropView resetCropRect];
```


## License

[Apache]: http://www.apache.org/licenses/LICENSE-2.0
[MIT]: http://www.opensource.org/licenses/mit-license.php
[GPL]: http://www.gnu.org/licenses/gpl.html
[BSD]: http://opensource.org/licenses/bsd-license.php

PEPhotoCropEditor is available under the [MIT license][MIT]. See the LICENSE file for more info.
