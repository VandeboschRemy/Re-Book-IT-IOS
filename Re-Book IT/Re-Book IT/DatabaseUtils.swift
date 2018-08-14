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

var sortBy: Int? = 0
var maxPrice: Double? = 150.0

func createTable(){
    do{
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
                                        Constants.authors <- "\(book["authors"].arrayValue)",
                                        Constants.courses <- "\(book["courses"].arrayValue)",
                                        Constants.coursesFullName <- "\(book["courses_full_name"].arrayValue)",
                                        Constants.price <- book["price"].doubleValue,
                                        Constants.createdAt <- book["created_at"].stringValue,
                                        Constants.institutions <- "\(book["institutions"].arrayValue)",
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
    sortBy = UserDefaults.standard.integer(forKey: "SORTBY_KEY")
    maxPrice = UserDefaults.standard.double(forKey: "MAX_PRICE_KEY")
    
    if(sortBy == 0){
        return sortByDate()
    }
    else if(sortBy == 1){
        return sortByPrice(order: Constants.order_asc)
    }
    else if(sortBy == 2){
        return sortByPrice(order: Constants.order_desc)
    }
    else if(sortBy == 3){
        return sortByTitle()
    }
    else if(sortBy == 4){
        return sortByQuality(order: Constants.order_asc)
    }
    else if(sortBy == 5){
        return sortByQuality(order: Constants.order_desc)
    }
    else{
        return sortByDate()
    }
}

func getDataFromDBBySearch(searchQuery: String, searchBy: Expression<String>) -> AnySequence<Row>{
    var query: AnySequence<Row>? = nil
    do{
        query = try db?.prepare(Constants.table.filter(searchBy.like("%\(searchQuery)%")).filter(Constants.price <= Expression<Double>(value: maxPrice!)))
    }
    catch{
        print(error)
    }
    return query!
}
    
func sortByDate() -> AnySequence<Row>{
    var query : AnySequence<Row>? = nil
    do{
            query = (try db?.prepare(Constants.table.order(Constants.createdAt.desc).filter(Constants.price <= Expression<Double>(value: maxPrice!))))!
    }
    catch{
        print(error)
    }
    return query!
}

func sortByPrice(order:String) -> AnySequence<Row>{
    var query : AnySequence<Row>? = nil
    do{
        if(order == Constants.order_asc){
            query = (try db?.prepare(Constants.table.order(Constants.price.asc).filter(Constants.price <= Expression<Double>(value: maxPrice!))))!
        }
        else if(order == Constants.order_desc){
            query = (try db?.prepare(Constants.table.order(Constants.price.desc).filter(Constants.price <= Expression<Double>(value: maxPrice!))))!
        }
    }
    catch{
        print(error)
    }
    return query!
}

func sortByQuality(order:String) -> AnySequence<Row>{
    var query: AnySequence<Row>? = nil
    do{
        if(order == Constants.order_asc){
            query = (try db?.prepare(Constants.table.order(Constants.quality.asc).filter(Constants.price <= Expression<Double>(value: maxPrice!))))!
        }
        else if(order == Constants.order_desc){
            query = (try db?.prepare(Constants.table.order(Constants.quality.desc).filter(Constants.price <= Expression<Double>(value: maxPrice!))))!
        }
    }
    catch{
        print(error)
    }
    return query!
}

func sortByTitle() -> AnySequence<Row>{
    var query: AnySequence<Row>? = nil
    do{
        query = (try db?.prepare(Constants.table.order(Constants.title.asc).filter(Constants.price <= Expression<Double>(value: maxPrice!))))!
    }
    catch{
        print(error)
    }
    return query!
}

func tableExists() -> Bool{
    do{
        db = try Connection("\(path)/db.sqlite3")
        try db?.scalar(Constants.table.exists)
        return true
    }
    catch{
        return false
    }
}
