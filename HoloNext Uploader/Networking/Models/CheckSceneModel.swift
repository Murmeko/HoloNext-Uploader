//
//  CheckSceneModel.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 28.09.2021.
//

import Foundation

// MARK: - CheckSceneModel
struct CheckSceneModel: Codable {
    let body: Body?

    enum CodingKeys: String, CodingKey {
        case body = "body"
    }
}

// MARK: - Body
struct Body: Codable {
    let usdzModel: String?

    enum CodingKeys: String, CodingKey {
        case usdzModel = "usdzModel"
    }
}
