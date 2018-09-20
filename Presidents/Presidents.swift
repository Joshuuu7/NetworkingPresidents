//
//  Presidents.swift
//  Presidents
//
//  Created by Joshua Aaron Flores Stavedahl on 10/31/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

import Foundation

/// 👑 Ruler, mandatary, or leader of a specific region or country with all his descriptive values
class President {
    var name : String!
    var number : Int!
    var startDate : String!
    var endDate : String!
    var nickname : String!
    var politicalParty : String!
    var url: String!
    
    /**
     Initializer list for a specific President.
     
     - Parameters:
        - name: Name of the President.
        - number: What place he occupies in history.
        - startDate: First day on the job.
        - endDate: Last day on the job.
        - nickname: Term of endearment/mockery.
        - politicalParty: What philosophical/ideological belief he belongs to.
        - url: The string for the specific image of a president.
     
     - Returns: A president from the United States with all his descriptive data
 
    */
    init(name: String, number : Int, startDate: String, endDate: String, nickname : String, politicalParty : String, url: String) {
        self.name = name
        self.number = number
        self.startDate = startDate
        self.endDate = endDate
        self.nickname = nickname
        self.politicalParty = politicalParty
        self.url = url
    }
}
