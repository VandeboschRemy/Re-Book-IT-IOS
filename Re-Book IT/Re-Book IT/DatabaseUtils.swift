//
//  DatabaseUtils.swift
//  Re-Book IT
//
//  Created by Remy vandebosch on 9/07/18.
//  Copyright © 2018 Remy vandebosch. All rights reserved.
//

import Foundation
import SwiftyJSON
import SQLite

let path = NSSearchPathForDirectoriesInDomains(
    .documentDirectory, .userDomainMask, true
    ).first!

var db : Connection? = nil

func createTable(){
    do{
        
        db = try Connection("\(path)/db.sqlite3")
        try db?.run(Constants.table.drop(ifExists: true))
        try db?.run(Constants.table.create() {
            t in
            t.column(Constants.id, primaryKey: true)
            t.column(Constants.title)
            t.column(Constants.subTitle)
            t.column(Constants.count)
            t.column(Constants.authors)
            t.column(Constants.courses)
            t.column(Constants.coursesFullName)
            t.column(Constants.price)
            t.column(Constants.createdAt)
            t.column(Constants.institutions)
            t.column(Constants.imageUrl)
            t.column(Constants.quality)
            t.column(Constants.edition)
            t.column(Constants.isbn)
        })
    }
    catch{
        print("Error creating table \(error)")
    }
}


func saveToDB(dataFromWebsite: String){
    createTable()
    do{
        let json  = try JSON(data: dataFromWebsite.data(using: .utf8, allowLossyConversion: false)!)
        for book in json.arrayValue{
           try db?.run(Constants.table.insert(
                                        Constants.title <- book["title"].stringValue,
                                        Constants.subTitle <- book["subtitle"].stringValue,
                                        Constants.count <- book["count"].stringValue,
                                        Constants.authors <- book["authors"].stringValue,
                                        Constants.courses <- book["courses"].stringValue,
                                        Constants.coursesFullName <- book["courses_full_name"].stringValue,
                                        Constants.price <- book["price"].doubleValue,
                                        Constants.createdAt <- book["created_at"].stringValue,
                                        Constants.institutions <- book["institutions"].stringValue,
                                        Constants.imageUrl <- book["image_url"].stringValue,
                                        Constants.quality <- book["quality"].stringValue,
                                        Constants.edition <- book["edition"].stringValue,
                                        Constants.isbn <- book["isbn"].stringValue))
        }
        
    }
    catch{
        print("Error opening or inserting into DB \(error)")
    }
}
    
func getDataFromDB() -> AnySequence<Row>{
    return sortByDate()
}

func getDataFromDBBySearch(query: String, searchBy: Expression<String>) -> AnySequence<Row>{
    var query: AnySequence<Row>? = nil
    do{
        query = try db?.prepare(Constants.table.filter(searchBy))
    }
    catch{
        print(error)
    }
}
    
func sortByDate() -> AnySequence<Row>{
    var query : AnySequence<Row>? = nil
    do{
            query = (try db?.prepare(Constants.table.order(Constants.createdAt.desc)))!
    }
    catch{
        print(error)
    }
    return query!
}
