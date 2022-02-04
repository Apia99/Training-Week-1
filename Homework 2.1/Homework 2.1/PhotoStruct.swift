//
//  PhotoStruct.swift
//  Homework 2 Get Data from API
//
//  Created by Admin on 03/02/2022.
//

import Foundation

struct Response: Decodable {
    let photos: [MyPhoto]
}
struct MyPhoto: Decodable  {
    let id: Int
    let sol: Int
    let earth_date: String
    let img_src: String
    let rover: Rover
    let camera: Camera
}
struct Rover: Decodable {
    let id: Int
    let name: String
    let  landing_date:String
    let launch_date: String
    let status: String
}
struct Camera: Decodable {
    let full_name: String
    let name: String
    let rover_id: Int
    let id: Int
}

