//
//  GetFileUploadUrlModel.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 28.09.2021.
//

import Foundation

// MARK: - GetFileUploadUrlModel
struct GetFileUploadUrlModel: Codable {
    let body: GetFileUploadUrlBody?

    enum CodingKeys: String, CodingKey {
        case body = "body"
    }
}

// MARK: - Body
struct GetFileUploadUrlBody: Codable {
    let uploadUrl: String?

    enum CodingKeys: String, CodingKey {
        case uploadUrl = "uploadUrl"
    }
}
