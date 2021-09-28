//
//  CompleteFileUploadUrlModel.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 28.09.2021.
//

import Foundation

// MARK: - CompleteFileUploadUrlModel
struct CompleteFileUploadUrlModel: Codable {
    let body: CompleteFileUploadUrlBody?

    enum CodingKeys: String, CodingKey {
        case body = "body"
    }
}

// MARK: - Body
struct CompleteFileUploadUrlBody: Codable {
    let toast: String?

    enum CodingKeys: String, CodingKey {
        case toast = "toast"
    }
}
