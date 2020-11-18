//
//  Strings.swift
//  Budtender
//
//  Created by Enrique Florencio on 11/9/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation

enum QuizQuestions: String, LocalizableDelegate {
    case firstQuestion
    case secondQuestion
    case thirdQuestion
    case fourthQuestion
    case fifthQuestion
    case sixthQuestion
    case seventhQuestion
    case eighthQuestion
    
    var table: String? {
        return "QuizQuestions"
    }
}

enum WeedmapsTags: String, LocalizableDelegate {
    case tagOne
    case tagTwo
    case tagThree
    case tagFour
    case tagFive
    case tagSix
    case tagSeven
    case tagEight
    
    var table: String? {
        return "WeedmapsTags"
    }
}
