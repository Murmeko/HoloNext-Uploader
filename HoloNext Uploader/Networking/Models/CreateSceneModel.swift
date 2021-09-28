//
//  CreateSceneModel.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 25.09.2021.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let createSceneModel = try? newJSONDecoder().decode(CreateSceneModel.self, from: jsonData)

import Foundation

// MARK: - CreateSceneModel
struct CreateSceneModel: Codable {
    let body: CreateSceneBody?
        let error: CreateSceneError?

        enum CodingKeys: String, CodingKey {
            case body = "body"
            case error = "error"
        }
}

// MARK: - Body
struct CreateSceneBody: Codable {
    let scene: Scene?

    enum CodingKeys: String, CodingKey {
        case scene = "scene"
    }
}

// MARK: - Scene
struct Scene: Codable {
    let deleted: Bool?
    let shared: Bool?
    let publicWebpageLinkRelative: String?
    let publicWebpageLinkAbsolute: String?
    let isPublic: Bool?
    let isUsdzValid: Bool?
    let variantsGenerated: Bool?
    let id: String?
    let user: String?
    let name: String?
    let lastSavedDate: String?
    let createdDate: String?

    enum CodingKeys: String, CodingKey {
        case deleted = "deleted"
        case shared = "shared"
        case publicWebpageLinkRelative = "publicWebpageLinkRelative"
        case publicWebpageLinkAbsolute = "publicWebpageLinkAbsolute"
        case isPublic = "isPublic"
        case isUsdzValid = "isUsdzValid"
        case variantsGenerated = "variantsGenerated"
        case id = "_id"
        case user = "user"
        case name = "name"
        case lastSavedDate = "lastSavedDate"
        case createdDate = "createdDate"
    }
}

// MARK: - Error
struct CreateSceneError: Codable {
    let toast: String?

    enum CodingKeys: String, CodingKey {
        case toast = "toast"
    }
}
