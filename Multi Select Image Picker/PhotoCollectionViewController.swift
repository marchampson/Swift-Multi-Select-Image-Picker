//
//  PhotoCollectionViewController.swift
//  Multi Select Image Picker
//
//  Created by Marc Hampson on 29/09/2017.
//  Copyright © 2017 Marc Hampson. All rights reserved.
//

import UIKit
import Photos

class CollectionPhotoCell: UICollectionViewCell {
    @IBOutlet weak var collectionPhotoView: UIImageView!
}

class PhotoCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedAlbum: AlbumModel!
    var photoAssets = PHFetchResult<PHAsset>()
    var selectedAssets:[PHAsset] = [PHAsset]()
    var selectedIndices:[Int] = [Int]()
    
    let imageManager = PHCachingImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        photoAssets = PHAsset.fetchAssets(in: selectedAlbum.collection, options: nil)
        
        // Cache images
        for i in 0...photoAssets.count - 1 {
            let asset = photoAssets[i]
            let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            imageManager.startCachingImages(for: [asset], targetSize: imageSize, contentMode: .default, options: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionPhotoCell", for: indexPath) as! CollectionPhotoCell
        
        imageManager.requestImage(for: photoAssets[indexPath.row], targetSize: CGSize(width: 100, height: 100), contentMode: .default, options: nil) { (img, _) in
            cell.collectionPhotoView.image = img!
            if self.selectedIndices.contains(indexPath.row) {
                cell.layer.borderWidth = 3.0
                cell.layer.borderColor = UIColor.red.cgColor
            } else {
                cell.layer.borderWidth = 0
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            selectCell(index: indexPath.row, cell: cell)
        }
    }
    
    func selectCell(index: Int, cell: UICollectionViewCell) {
        
        if selectedIndices.contains(index) {
            cell.layer.borderWidth = 0
            if let idx = selectedIndices.index(of: index) {
                selectedIndices.remove(at: idx)
            }
            if let assetIdx = selectedAssets.index(of: photoAssets[index]) {
                selectedAssets.remove(at: assetIdx)
            }
        } else {
            cell.layer.borderWidth = 3.0
            cell.layer.borderColor = UIColor.red.cgColor
            selectedIndices.append(index)
            selectedAssets.append(photoAssets[index])
        }
     
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
        
    } 
}
