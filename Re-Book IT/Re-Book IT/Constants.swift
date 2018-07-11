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
}
