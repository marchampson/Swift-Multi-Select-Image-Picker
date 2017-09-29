//
//  AlbumModel.swift
//  Multi Select Image Picker
//
//  Created by Marc Hampson on 29/09/2017.
//  Copyright © 2017 Marc Hampson. All rights reserved.
//
import Photos

class AlbumModel {
    let name:String
    let count:Int
    let collection:PHAssetCollection
    init(name:String, count:Int, collection:PHAssetCollection) {
        self.name = name
        self.count = count
        self.collection = collection
    }
}
