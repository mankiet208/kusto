//
//  Info.swift
//  Kusto
//
//  Created by Kiet Truong on 25/03/2024.
//

import Foundation

struct Info {
    let size: String
    let dimenssion: String
    let format: ImageFormat
    
    init(photo: Photo) {
        self.dimenssion = ""
        self.size = photo.size ?? ""
        self.format = photo.data?.imageFormat ?? .unknown
    }
}

enum ImageFormat {
    case png
    case jpeg
    case gif
    case tiff
    case unknown
    
    init(byte: UInt8) {
        switch byte {
        case 0x89:
            self = .png
        case 0xFF:
            self = .jpeg
        case 0x47:
            self = .gif
        case 0x49, 0x4D:
            self = .tiff
        default:
            self = .unknown
        }
    }
}

extension Data {
    
    var imageFormat: ImageFormat{
        guard let header = map({ $0 as UInt8 })[safe: 0] else {
            return .unknown
        }
        return ImageFormat(byte: header)
    }
}
