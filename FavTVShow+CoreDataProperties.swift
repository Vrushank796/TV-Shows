//
//  FavTVShow+CoreDataProperties.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-14.
//
//

import Foundation
import CoreData


extension FavTVShow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavTVShow> {
        return NSFetchRequest<FavTVShow>(entityName: "FavTVShow")
    }

    @NSManaged public var showName: String?
    @NSManaged public var ratings: Float
    @NSManaged public var genres: String?
    @NSManaged public var imgURL: NSObject?

}

extension FavTVShow : Identifiable {

}
