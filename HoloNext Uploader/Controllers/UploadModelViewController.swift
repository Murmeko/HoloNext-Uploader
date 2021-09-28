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

class UploadModelViewController: UIViewController, UITextFieldDelegate, UIDocumentPickerDelegate, QLPreviewControllerDataSource {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var modelnameTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var processingModelIndicator: UIActivityIndicatorView!
    @IBOutlet weak var displayModelButton: UIButton!
    
    let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "glb")!])
    let previewController = QLPreviewController()

    var loginToken: String?

    var uploadModelViewModel = UploadModelViewModel()

    var quickLookLocalUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true

        uploadModelViewModel.token = loginToken

        modelnameTextField.delegate = self
        documentPickerController.delegate = self
        previewController.dataSource = self

        self.logoutButton.isEnabled = true
        self.modelnameTextField.isEnabled = true
        self.uploadButton.isEnabled = true
        self.processingModelIndicator.isHidden = true
        self.displayModelButton.isEnabled = false
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        if modelnameTextField.text?.isEmpty != true {
            self.present(documentPickerController, animated: true)
        }
    }

    @IBAction func displayModelButtonPressed(_ sender: UIButton) {
        present(previewController, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadModelViewModel.selectedFileUrl = urls[0]

        let canAccess = urls[0].startAccessingSecurityScopedResource()
        guard canAccess else {
            return
        }
        let fileData = try! Data(contentsOf: urls[0])
        urls[0].stopAccessingSecurityScopedResource()

        uploadModelViewModel.uploadModel(sceneName: modelnameTextField.text!, fileName: urls[0].lastPathComponent, file: fileData) {
            self.logoutButton.isEnabled = false
            self.modelnameTextField.isEnabled = false
            self.uploadButton.isEnabled = false
            self.processingModelIndicator.isHidden = false
            self.displayModelButton.isEnabled = false
            self.processingModelIndicator.startAnimating()

            self.uploadModelViewModel.checkSceneReady() { url in
                self.quickLookLocalUrl = url
                DispatchQueue.main.async {
                    self.processingModelIndicator.stopAnimating()
                    self.displayModelButton.isEnabled = true
                    self.processingModelIndicator.isHidden = true
                    self.uploadButton.isEnabled = true
                    self.modelnameTextField.isEnabled = true
                    self.logoutButton.isEnabled = true
                }
            }
        }
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return quickLookLocalUrl! as QLPreviewItem
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
