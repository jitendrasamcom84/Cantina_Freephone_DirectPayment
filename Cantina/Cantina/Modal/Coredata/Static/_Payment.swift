// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Payment.swift instead.

import Foundation
import CoreData

public enum PaymentAttributes: String {
    case amount = "amount"
    case commission = "commission"
    case dateAdded = "dateAdded"
    case entity_id = "entity_id"
    case payment_type = "payment_type"
    case paymentid = "paymentid"
    case receiver_id = "receiver_id"
    case receiver_name = "receiver_name"
    case status = "status"
    case total_amount = "total_amount"
}

public enum PaymentRelationships: String {
    case rec_id = "rec_id"
    case tranzilapara = "tranzilapara"
    case user_id = "user_id"
}

open class _Payment: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Payment"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Payment.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var amount: NSNumber?

    @NSManaged open
    var commission: NSNumber?

    @NSManaged open
    var dateAdded: Date?

    @NSManaged open
    var entity_id: String?

    @NSManaged open
    var payment_type: String?

    @NSManaged open
    var paymentid: NSNumber?

    @NSManaged open
    var receiver_id: String?

    @NSManaged open
    var receiver_name: String?

    @NSManaged open
    var status: NSNumber?

    @NSManaged open
    var total_amount: NSNumber?

    // MARK: - Relationships

    @NSManaged open
    var rec_id: Receiver?

    @NSManaged open
    var tranzilapara: TranzilaToken?

    @NSManaged open
    var user_id: User?

}

