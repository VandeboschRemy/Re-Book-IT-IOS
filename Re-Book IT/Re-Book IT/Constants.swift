//
//  Constants.swift
//  Re-Book IT
//
//  Created by Remy vandebosch on 10/07/18.
//  Copyright © 2018 Remy vandebosch. All rights reserved.
//

import Foundation
import SQLite

struct Constants {
    
    // Following constants can be translated
    static let searchChoice = ["Title", "Author", "Course", "ISBN"]
    static let noSubTitle = "No subtitle found."
    static let noAuthor = "No author found"
    static let noCourses = "No courses found"
    static let noUniversities = "No universities found"
    static let share = "Share"
    static let shareBegin = "Just found this awesome book: "
    static let shareEnd = "Shared with the Re-Book IT app"
    static let dropDown = ["Settings", "Contact", "Info", "Sell books"]
    static let dropDownTitle = "Menu"
    static let timeTableHeader = "Opening Hours:"
    static let addressHeader = "Address:"
    static let address = "Agoralaan Gebouw D, Kantoor B111\n3590 Diepenbeek, Vlaanderen"
    static let timeTableWait = "Please wait while content is loading..."
    static let priceInfoHeader = "Which price do you pay at Re-Book IT?"
    static let priceInfo = """
Books at Re-Book IT have a qualitylabel which also determines the price.
    The percentage of the quality is also the price wich you pay relative the new price in the campusshop.
    Each book gets it\'s qualitylabel after a physical inspection by our team.
"""
    static let greenInfo = "80% or more / unused"
    static let redInfo = "70% / used without notes"
    static let greyInfo = "50% / with notes"
    static let yellowInfo = "30% / with A LOT of notes or just an old edition"
    static let warrantyHeader = "What warranty is provided at Re-Book IT?"
    static let warrantyInfo = """
Every client gets one month to return a book. This is only valid if a mistake is made on the side on Re-Book IT.
    Specifically this means a wrong qualitylabel or wrong product information.\n\n
"""
    static let noNetwork = "Turn on internet to update content !!"
    static let startUpdate = " Updating content "
    static let updateSuccess = " Content updated "
    static let updateFailed = " Failed updating content "
    static let authorInfo = "Created by Vandebosch Remy"
    
    // Do NOT translate following constants
    static let id = Expression<Int>("id")
    static let title = Expression<String>("title")
    static let subTitle = Expression<String>("subTitle")
    static let count = Expression<String>("count")
    static let authors = Expression<String>("authors")
    static let courses = Expression<String>("courses")
    static let coursesFullName = Expression<String>("coursesFullName")
    static let price = Expression<Double>("price")
    static let createdAt = Expression<String>("createdAt")
    static let institutions = Expression<String>("institutions")
    static let imageUrl = Expression<String>("imageUrl")
    static let quality = Expression<String>("quality")
    static let edition = Expression<String>("edition")
    static let isbn = Expression<String>("isbn")
    static let table = Table("bookData")
    static let order_asc = "ASC"
    static let order_desc = "DESC"
    static let markerTitle = "Re-Book-IT"
}
