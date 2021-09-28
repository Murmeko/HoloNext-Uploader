//
//  NetworkManager.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 25.09.2021.
//

import Moya
import Combine

struct NetworkManager {
    let holoNextAPIProvider = MoyaProvider<HoloNextAPI>()

    typealias LoginDataCompletion = (LoginModel?) -> ()
    typealias CreateSceneDataCompletion = (CreateSceneModel?) -> ()
    typealias GetFileUploadUrlCompletion = (GetFileUploadUrlModel?) -> ()
    typealias UploadModelCompletion = (Bool?) -> ()
    typealias CompleteFileUploadUrlCompletion = (Bool?) -> ()
    typealias CheckSceneCompletion = (CheckSceneModel?) -> ()
    typealias DownloadConvertedSceneCompletion = (URL) -> ()

    func login(username: String, password: String, completion: @escaping LoginDataCompletion) {
        holoNextAPIProvider.request(.loginRequest(username, password)) { result in
            switch result {
            case .success(let data):
                do {
                    let filteredData = try data.filterSuccessfulStatusCodes()
                    let loginData = try filteredData.map(LoginModel.self)
                    completion(loginData)
                }
                catch let error {
                    print("Unable to decode HoloNextAPI response: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    func createScene(_ token: String, _ sceneName: String, completion: @escaping CreateSceneDataCompletion) {
        holoNextAPIProvider.request(.createSceneRequest(token, sceneName)) { result in
            switch result {
            case .success(let data):
                do {
                    if data.statusCode == 403 {
                        let filteredData = try data.filter(statusCode: 403)
                        let createSceneData = try filteredData.map(CreateSceneModel.self)
                        completion(createSceneData)
                    } else {
                        let filteredData = try data.filterSuccessfulStatusCodes()
                        let createSceneData = try filteredData.map(CreateSceneModel.self)
                        completion(createSceneData)
                    }
                }
                catch let error {
                    print("Unable to decode HoloNextAPI response: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    func getFileUploadUrl(_ token: String, sceneId: String, fileName: String, completion: @escaping GetFileUploadUrlCompletion) {
        holoNextAPIProvider.request(.getFileUploadUrlRequest(token, sceneId, fileName)) { result in
            switch result {
            case .success(let data):
                do {
                    let filteredData = try data.filterSuccessfulStatusCodes()
                    let getFileUploadUrlData = try filteredData.map(GetFileUploadUrlModel.self)
                    completion(getFileUploadUrlData)
                }
                catch let error {
                    print("Unable to decode HoloNextAPI response: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    func uploadModel(_ uploadUrl: String, _ file: Data, completion: @escaping UploadModelCompletion) {
        let url = URL(string: uploadUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let headers = ["x-ms-blob-type": "BlockBlob"]
        request.allHTTPHeaderFields = headers

        URLSession.shared.uploadTask(with: request, from: file) { (responseData, response, error) in
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                guard responseCode == 201 else {
                    print("Invalid response code: \(responseCode)")
                    completion(false)
                    return
                }
                completion(true)
            }
        }.resume()
    }

    func completeFileUploadUrl(_ token: String, modelId: String, fileName: String, completion: @escaping (Bool) -> ()) {
        holoNextAPIProvider.request(.completeFileUploadUrl(token, modelId, fileName)) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    func checkScene(_ token: String, _ sceneId: String, completion: @escaping CheckSceneCompletion) {
        holoNextAPIProvider.request(.checkScene(token, sceneId)) { result in
            switch result {
            case .success(let data):
                do {
                    let filteredData = try data.filterSuccessfulStatusCodes()
                    let checkSceneData = try filteredData.map(CheckSceneModel.self)
                    completion(checkSceneData)
                }
                catch let error {
                    print("Unable to decode HoloNextAPI response: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    func downloadConvertedScene(url: String, completion: @escaping DownloadConvertedSceneCompletion) {
        let downloadUrl = URL(string: url)!
        let downloadTask = URLSession.shared.downloadTask(with: downloadUrl) {
            urlOrNil, responseOrNil, errorOrNil in

            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent).deletingPathExtension().appendingPathExtension(".usdz")
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                completion(savedURL)

            } catch {
                print ("file error: \(error)")
            }
        }
        downloadTask.resume()
    }
}
