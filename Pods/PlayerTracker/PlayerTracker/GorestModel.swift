//
//  GorestModel.swift
//  PlayerTracker
//
//  Created by Elisabet Massó on 10/11/2020.
//

import Foundation

class GorestDataModel: Codable {
    
    var data: [GorestUserModel]?
    
}

class GorestUserModel: Codable {
    
    var id: Int
    var name: String?
    var email: String?
    var gender: String?
    var status: String?
    var created_at: String?
    var updated_at: String?
    
}
