//
//  User.swift
//  JSONParsingDemo
//
//  Created by Yashwant Kumar on 29/10/24.
//

import Foundation

struct User: Codable {
    let id: Int
    let company: Company
    let address: Address
}

struct Company: Codable {
    let name: String
}

struct Address: Codable {
    let geo: Geo
}

struct Geo: Codable {
    let lat: String
    let lng: String
}
