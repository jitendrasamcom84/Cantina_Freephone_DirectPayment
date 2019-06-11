// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QuestionAnswer.swift instead.

import Foundation
import CoreData

public enum QuestionAnswerAttributes: String {
    case answer = "answer"
    case dateAdded = "dateAdded"
    case entity_id = "entity_id"
    case is_deleted = "is_deleted"
    case is_free_phone = "is_free_phone"
    case question = "question"
}

open class _QuestionAnswer: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "QuestionAnswer"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _QuestionAnswer.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var answer: String?

    @NSManaged open
    var dateAdded: Date?

    @NSManaged open
    var entity_id: String?

    @NSManaged open
    var is_deleted: NSNumber?

    @NSManaged open
    var is_free_phone: NSNumber?

    @NSManaged open
    var question: String?

    // MARK: - Relationships

}

