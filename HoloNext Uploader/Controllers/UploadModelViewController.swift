//
//  UploadModelViewController.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 28.09.2021.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import QuickLook
import ARKit

class UploadModelViewController: UIViewController, UIDocumentPickerDelegate, QLPreviewControllerDataSource {
    @IBOutlet weak var modelnameTextField: UITextField!
    @IBOutlet weak var processingModelIndicator: UIActivityIndicatorView!
    @IBOutlet weak var displayModelButton: UIButton!
    
    let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "glb")!])
    let previewController = QLPreviewController()

    var loginToken: String?

    var uploadModelViewModel = UploadModelViewModel()

    var NM = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        documentPickerController.delegate = self
        processingModelIndicator.isHidden = true
        previewController.dataSource = self

        uploadModelViewModel.token = loginToken
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        //self.present(documentPickerController, animated: true)
        
        self.uploadModelViewModel.checkSceneReady() {
            DispatchQueue.main.async {
                self.processingModelIndicator.stopAnimating()
                self.processingModelIndicator.isHidden = true
                self.displayModelButton.isEnabled = true
            }
        }
    }

    @IBAction func displayModelButtonPressed(_ sender: UIButton) {
        present(previewController, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadModelViewModel.selectedFileUrl = urls[0]
        if modelnameTextField.text?.isEmpty != true {
            uploadModelViewModel.uploadModel(sceneName: modelnameTextField.text!, fileName: urls[0].lastPathComponent, file: try! Data(contentsOf: urls[0])) {
                self.displayModelButton.isEnabled = false
                self.processingModelIndicator.isHidden = false
                self.processingModelIndicator.startAnimating()
                self.uploadModelViewModel.checkSceneReady() {
                    DispatchQueue.main.async {
                        self.processingModelIndicator.stopAnimating()
                        self.processingModelIndicator.isHidden = true
                        self.displayModelButton.isEnabled = true
                    }
                    self.performSegue(withIdentifier: K.uploadModelToQuickLookSegue, sender: self)
                }
            }
        }
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return uploadModelViewModel.selectedFileUrl! as QLPreviewItem
    }
}
