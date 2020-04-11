//
//  ViewController.m
//  PEPhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/22.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "ViewController.h"
#import "PECropViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cameraButton;

@property (nonatomic) UIPopoverController *popover;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Disable edit button if there is no selected image.
    [self updateEditButtonEnabled];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = croppedImage;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Action methods

- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.imageView.image;
    
    UIImage *image = self.imageView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)cameraButtonAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // camera action
            [self showCamera];
        }];
        
        [actionSheet addAction:cameraAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:cancelAction];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Photo Album", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // album action
        [self openPhotoAlbum];
    }];
    
    [actionSheet addAction:albumAction];
    
    [self presentViewController:actionSheet animated:YES completion:^{}];
}

#pragma mark - Private methods

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)updateEditButtonEnabled
{
    self.editButton.enabled = !!self.imageView.image;
}

#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        [self updateEditButtonEnabled];
        
        [self openEditor:nil];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self openEditor:nil];
        }];
    }
}

@end
