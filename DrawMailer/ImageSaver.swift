import UIKit
import SwiftUI

class ImageSaver: NSObject, ObservableObject {
    @Published var saveSuccess: Bool? = nil
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            self.saveSuccess = (error == nil)
        }
    }
}

