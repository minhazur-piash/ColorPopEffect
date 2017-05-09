//
//  PopperFactory.swift
//  kgs-assignment
//
//  Created by Minhazur Rahman on 5/9/17.
//  Copyright © 2017 MinhazHome. All rights reserved.
//

import UIKit


class PopperFactory {
    private init(){}
    
    public static func createPopper(type: ColorPopMode, withImage: UIImage) -> Popper {
        switch type {
        case .masking:
            return MaskingPopper(originalImage: withImage)
            
        case .cropping:
            return CroppingPopper(originalImage: withImage)
        }
    }
    
}
