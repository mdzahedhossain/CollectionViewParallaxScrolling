//
//  PhotosCollectionViewController.m
//  ParallaxScrolling
//
//  Created by Ole Begemann on 01.05.14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "ParallaxFlowLayout.h"
#import "ParallaxPhotoCell.h"

@interface PhotosCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSArray *photos;

@end


@implementation PhotosCollectionViewController

- (id)init
{
    ParallaxFlowLayout *layout = [[ParallaxFlowLayout alloc] init];
    layout.minimumLineSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    
    self = [super initWithCollectionViewLayout:layout];
    
    if (self == nil) {
        return nil;
    }
    
    self.title = @"Photos";

    NSDictionary *photosDict = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Photos" withExtension:@"plist"]];
    self.photos = photosDict[@"photos"];
    
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ParallaxPhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ParallaxPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.item];
    NSString *photoFilename = photo[@"filename"];
    UIImage *image = [UIImage imageNamed:photoFilename];
    cell.imageView.image = image;

    // Pass the maximum parallax offset to the cell.
    // The cell needs this information to configure the constraints for its image view.
    ParallaxFlowLayout *layout = (ParallaxFlowLayout *)self.collectionViewLayout;
    cell.maxParallaxOffset = layout.maxParallaxOffset;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photo = self.photos[indexPath.item];
    CGFloat imageWidth = [photo[@"width"] floatValue];
    CGFloat imageHeight = [photo[@"height"] floatValue];
    
    // Compute cell size according to image aspect ratio.
    // Cell height must take maximum possible parallax offset into account.
    ParallaxFlowLayout *layout = (ParallaxFlowLayout *)self.collectionViewLayout;
    CGFloat cellWidth = CGRectGetWidth(self.collectionView.bounds) - layout.sectionInset.left - layout.sectionInset.right;
    CGFloat cellHeight = floor(cellWidth / imageWidth * imageHeight) - (2 * layout.maxParallaxOffset);
    return CGSizeMake(cellWidth, cellHeight);
}

@end
