//
//  PersistentLocale+CoreDataProperties.swift
//  Rift
//
//  Created by Varun Chitturi on 10/2/21.
//
//

import Foundation
import CoreData


extension PersistentLocale {
    
    private static let entityName = "PersistentLocale"

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistentLocale> {
        return NSFetchRequest<PersistentLocale>(entityName: entityName)
    }

    @nonobjc class func getLocale() -> Locale? {
        let viewContext = PersistenceController.shared.container.viewContext
        guard let fetchedPersistentLocales = try? viewContext.fetch(PersistentLocale.fetchRequest()),
              let persistentLocale = fetchedPersistentLocales.first
        else { return nil }
        return persistentLocale.locale
    }
    
    @nonobjc class func saveLocale(locale: Locale) throws {
        try clearLocale()
        let viewContext = PersistenceController.shared.container.viewContext
        _ = PersistentLocale(locale: locale, context: viewContext)
        try viewContext.save()
    }
    
    @nonobjc class func clearLocale() throws {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try viewContext.execute(batchDeleteRequest)
    }
    
    @NSManaged public var id: String
    @NSManaged public var districtName: String
    @NSManaged public var districtAppName: String
    @NSManaged public var districtBaseURL: URL
    @NSManaged public var districtCode: String
    @NSManaged public var state: String
    @NSManaged public var staffLogInURL: URL
    @NSManaged public var studentLogInURL: URL
    @NSManaged public var parentLogInURL: URL
    
    var locale: Locale? {
        guard let state = Locale.USTerritory(rawValue: state) else { return nil }
        return Locale(id: id,
               districtName: districtName,
               districtAppName: districtAppName,
               districtBaseURL: districtBaseURL,
               districtCode: districtCode,
               state: state,
               staffLogInURL: staffLogInURL,
               studentLogInURL: studentLogInURL,
               parentLogInURL: parentLogInURL
        )
    }
    
    convenience init(locale: Locale, context: NSManagedObjectContext) {
        self.init(context: context)
        id = locale.id
        districtName = locale.districtName
        districtBaseURL = locale.districtBaseURL
        districtAppName = locale.districtAppName
        districtCode = locale.districtCode
        state = locale.state.rawValue
        staffLogInURL = locale.staffLogInURL
        studentLogInURL = locale.studentLogInURL
        parentLogInURL = locale.parentLogInURL
        
    }

}

extension PersistentLocale : Identifiable {

}
