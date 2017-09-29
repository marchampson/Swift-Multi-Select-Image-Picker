//
//  ViewController.swift
//  Multi Select Image Picker
//
//  Created by Marc Hampson on 29/09/2017.
//  Copyright © 2017 Marc Hampson. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var albums:[AlbumModel] = [AlbumModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        listAlbums()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = albums[indexPath.row].name
        cell.detailTextLabel?.text = "\(albums[indexPath.row].count) Photos"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showPhotoCollectionView", sender: indexPath);
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showPhotoCollectionView") {
            let controller = segue.destination as! PhotoCollectionViewController
            let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
            let selectedAlbum = albums[row]
            controller.selectedAlbum = selectedAlbum
        }
        
    }
    
    func listAlbums() {
        
        let options = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: options)
        userAlbums.enumerateObjects({ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                let obj:PHAssetCollection = object as! PHAssetCollection
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                
                let newAlbum = AlbumModel(name: obj.localizedTitle!, count: obj.estimatedAssetCount, collection:obj)
                
                // Ignore albums with 0 photos
                if obj.estimatedAssetCount > 0 {
                    self.albums.append(newAlbum)
                }
            }
        })
        
        for item in albums {
            print("Item \(item)")
            print(item.name)
        }
    }


}

