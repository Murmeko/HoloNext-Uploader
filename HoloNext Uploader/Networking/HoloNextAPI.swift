//
//  HoloNextAPI.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 25.09.2021.
//

import Moya

public enum HoloNextAPI {
    case loginRequest(_ username: String, _ password: String)
    case createSceneRequest(_ token: String, _ sceneName: String)
    case getFileUploadUrlRequest(_ token: String, _ sceneId: String, _ fileName: String)
    case completeFileUploadUrl(_ token: String, _ modelId: String, _ fileName: String)
    case checkScene(_ token: String, _ sceneId: String)
}

extension HoloNextAPI: TargetType {

    public var baseURL: URL {
        return URL(string: "https://holonext.azurewebsites.net/api/v1")!
    }

    public var path: String {
        switch self {
        case .loginRequest(_, _):
            return "/user/login"
        case .createSceneRequest(token: _):
            return "/scene/createScene"
        case .getFileUploadUrlRequest(token: _):
            return "/scene/getSceneFileUploadUrl"
        case .completeFileUploadUrl(token: _):
            return "/scene/completeSceneFileUpload"
        case .checkScene(token: _):
            return "/scene/checkModelWithSceneId"
        }
    }

    public var method: Method {
        switch self {
        case .loginRequest(_, _):
            return .post
        case .createSceneRequest(_, _):
            return .post
        case .getFileUploadUrlRequest(_, _, _):
            return .post
        case .completeFileUploadUrl(_, _, _):
            return .post
        case .checkScene(_, _):
            return .post
        }
    }

    public var task: Task {
        switch self {
        case .loginRequest(let email, let password):
            return .requestParameters(parameters: ["email": email,
                                                   "password": password
                                                  ],
                                      encoding: JSONEncoding.default)
        case .createSceneRequest(_, let sceneName):
            return .requestParameters(parameters: ["sceneName": "\(sceneName)",
                                                   "shared": "true"],
                                      encoding: JSONEncoding.default)
        case .getFileUploadUrlRequest(_, let sceneId, let fileName):
            return .requestParameters(parameters: ["sceneId": "\(sceneId)", "fileName": "\(fileName)"],
                                       encoding: JSONEncoding.default)
        case .completeFileUploadUrl(_, let modelId, let fileName):
            return .requestParameters(parameters: ["modelId": "\(modelId)", "fileName": "\(fileName)"],
                                      encoding: JSONEncoding.default)
        case .checkScene(_, let sceneId):
            return .requestParameters(parameters: ["sceneId": "\(sceneId)"],
                                       encoding: JSONEncoding.default)
        }
    }

    public var headers: [String : String]? {
        switch self {
        case .loginRequest(_, _):
            return ["Content-Type": "application/json"]
        case .createSceneRequest(let token, _):
            return ["Auth": "Bearer \(token)",
                    "Content-Type": "application/json"]
        case .getFileUploadUrlRequest(let token, _, _):
            return ["Auth": "Bearer \(token)",
                    "Content-Type": "application/json"]
        case .completeFileUploadUrl(let token, _, _):
            return ["Auth": "Bearer \(token)",
                    "Content-Type": "application/json"]
        case .checkScene(let token, _):
            return ["Auth": "Bearer \(token)",
                    "Content-Type": "application/json"]
        }
    }
}
