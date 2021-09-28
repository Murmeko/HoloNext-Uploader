//
//  LoginModel.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 25.09.2021.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let body: LoginBody?

    enum CodingKeys: String, CodingKey {
        case body = "body"
    }
}

// MARK: - Body
struct LoginBody: Codable {
    let token: String?
    let userName: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case token = "token"
        case userName = "userName"
        case email = "email"
    }
}
