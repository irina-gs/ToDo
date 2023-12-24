//
//  ImagePicker.swift
//  todo
//
//  Created by admin on 18.12.2023.
//

import UIKit

final class ImagePicker: NSObject {
    private var imagePickerController: UIImagePickerController?

    private var completion: ((UIImage) -> Void)?

    func show(in viewController: UIViewController, completion: ((UIImage) -> Void)?) {
        imagePickerController = UIImagePickerController()
        imagePickerController?.allowsEditing = true
        imagePickerController?.sourceType = .photoLibrary
        imagePickerController?.mediaTypes = ["public.image"]
        imagePickerController?.delegate = self
        self.completion = completion

        if let imagePickerController {
            viewController.present(imagePickerController, animated: true)
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        completion?(image)
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ImagePicker: UINavigationControllerDelegate {}
