//
//  TaskController.swift
//  kgs-assignment
//
//  Created by Minhazur Rahman on 4/29/17.
//  Copyright © 2017 MinhazHome. All rights reserved.
//

import UIKit

protocol TaskControllerDelegate {
    func showAlert(title: String, message: String)
    func showLoader()
    func hideLoader(completion: (() -> Swift.Void)?)
}

class TaskController: NSObject {
    
    private var taskControllerDelegate: TaskControllerDelegate
    
    init(taskControllerDelegate: TaskControllerDelegate) {
        self.taskControllerDelegate =  taskControllerDelegate
    }
    
     func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
     func saveImageToPhotoLibrary(image: UIImage) {
        DispatchQueue.global(qos: .background).async {
            
            self.taskControllerDelegate.showLoader()
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(TaskController.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var message = "Color popped image has been saved to your photos."
        var title = "Saved!"
        
        if let error = error {
            title = "Error!"
            message = error.localizedDescription
        }
        
        taskControllerDelegate.showAlert(title: title, message: message)
    }
}
