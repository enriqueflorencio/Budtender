//
//  Question.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/18/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation

///A struct that will be used to display questions
public struct Question {
    ///The question we're asking
    public let questionText: String
    ///The specific weedmaps tag that is associated with this question
    public let weedmapsTag: String
    ///Boolean that checks whether or not this question was answered
    public var isAnswered: Bool
    ///Each button has its own tag 
    public var buttonTag: Int?
}
