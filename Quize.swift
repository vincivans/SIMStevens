//
//  Quize.swift
//  stevens
//
//  Created by Xin Zou on 11/3/16.
//  Copyright © 2016 Stevens. All rights reserved.
//

import Foundation
import SpriteKit


let quizes : [String] = [
    
"It was the grand entrance through which all guests approached the Castle, a haunting structure built for the Steven's in ___.  ",
"1831",
"1854",
"1870",
"1854",
    
    
    "Edwin A. Stevens Building and DeBaun Auditorium  was designed by ___. ",
    "Rich Stevens",
    "Richard Upjohn",
    "Richard Johnson",
    "Richard Upjohn",
    
"When the Stevens Institute of Technology opened? ",
"1780",
"1807",
"1870",
"1870",

"Which city the Stevens Institute of Technology is located in? ",
"Hoboken, NJ",
"New York, NY",
"Pittsburgh, Pennsylvania",
"Hoboken, NJ",

"Do you know where is the highest point in Hoboken? ",
"Hoboken museum",
"Howe Center in Stevens",
"Stevens Institute of Technology Library",
"Howe Center in Stevens",

"When were women first allowed to enroll in Stevens? ",
"1871",
"1931",
"1971",
"1971",

"What is the meaning of Stevens motto [Per Aspera Ad Astr] in English? ",
"Through adversity to the stars",
"Truth and Virtue",
"Laws without morals are useless",
"Through adversity to the stars",

"Who donated the Gymnasium to Stevens in 1916?  ",
"Carnegie",
"William Hall Walker",
"Richard Upjohn",
"William Hall Walker",

"What function(s) has DeBaun Auditorium been used for? ",
"Theater",
"Laboratory and classroom",
"Gym",
"Theater",

"The sound system for the first 3-D movie was developed in the Stevens Experimental Theater. ",
"True",
"False",
"I dont want to answer",
"True",

"Where is the center for information discovery and preservation at Stevens? ",
"Burchard Building",
"Howe Center",
"Samuel C. Williams Library",
"Samuel C. Williams Library",

"Do you know what is the buiding name of a beautiful six-story, offering panoramic views of the river and the Manhattan skyline structure? ",
"the Babbio Center",
"the Howe Center",
"the Burchard Building",
"the Babbio Center",
    
]

struct Quize {
    var title: String
    var a:String
    var b:String
    var c:String
    // var d:String
    var key:String
    
    let cnt: Int = 5 // 1 title, 3 selections, 1 key, so all is 5
    
    init(quizeNum: Int) { // init by selecting number.
        var getNum = quizeNum
        getNum = max(getNum, 0)
        getNum = min(getNum, (quizes.count) / cnt)
        
        self.title = quizes[getNum * cnt + 0]
        self.a     = quizes[getNum * cnt + 1]
        self.b     = quizes[getNum * cnt + 2]
        self.c     = quizes[getNum * cnt + 3]
        self.key   = quizes[getNum * cnt + 4]
        
    }
    
}


