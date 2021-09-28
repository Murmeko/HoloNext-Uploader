//
//  LoginViewModel.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 27.09.2021.
//

import Foundation
import Alamofire

class UploadModelViewModel {
    var token: String?
    var selectedFileUrl: URL?
    var sceneId: String?
    var isConverted: Bool?

    var networkManager = NetworkManager()

    func uploadModel(sceneName: String, fileName: String, file: Data, completion: @escaping () -> Void) {
        isConverted = false
        networkManager.createScene(token!, sceneName) { createSceneResult in
            self.networkManager.getFileUploadUrl(self.token!, sceneId: (createSceneResult?.body?.scene?.id)!, fileName: fileName) { getFileUploadUrlResult in
                self.networkManager.uploadModel((getFileUploadUrlResult?.body?.uploadUrl)!, file) { uploadModelResult in
                    if uploadModelResult == true {
                        self.networkManager.completeFileUploadUrl(self.token!, modelId: (createSceneResult?.body?.scene?.id)!, fileName: fileName) { completeFileUploadUrlResult in
                            self.sceneId = createSceneResult?.body?.scene?.id
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func checkSceneReady(completion: @escaping (URL) -> ()) {
        isConverted = false
        Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { timer in
            self.networkManager.checkScene(self.token!, self.sceneId!) { checkSceneResult in
                if checkSceneResult?.body?.usdzModel?.isEmpty != true {
                    self.networkManager.downloadConvertedScene(url: (checkSceneResult?.body?.usdzModel)!) { url in
                        timer.invalidate()
                        completion(url)
                    }
                }
            }
        }
    }
}
