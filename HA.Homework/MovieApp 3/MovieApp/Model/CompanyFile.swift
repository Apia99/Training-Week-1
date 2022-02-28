//
//  CompanyFile.swift
//  MovieApp
//
//  Created by Admin on 26/02/2022.
//


import Foundation

struct Company: Codable {
    let logoPath: String?
    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
    }
}
