import Foundation
import FastEasyMapping
import MagicalRecord

@objc(QuestionAnswer)
open class QuestionAnswer: _QuestionAnswer {
    
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: QuestionAnswer.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: QuestionAnswer.self) as! [String : String]
        dict.removeValue(forKey: "dateAdded");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(QuestionAnswer.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getAll() -> [QuestionAnswer] {
        return QuestionAnswer.mr_findAllSorted(by: "dateAdded", ascending: true) as! [QuestionAnswer]
    }
    
    class func getbyId(pId : String) -> QuestionAnswer{
        return QuestionAnswer.mr_findFirst(with: NSPredicate(format: "entity_id ==%@", pId))!
    }
    
    class func getCantinaList() -> [QuestionAnswer] {
        let pre = NSPredicate(format: "is_free_phone == false")
        return QuestionAnswer.mr_findAllSorted(by: "dateAdded", ascending: true, with: pre) as! [QuestionAnswer]
    }
    
    class func getFreePhoneList() -> [QuestionAnswer] {
        let pre = NSPredicate(format: "is_free_phone == true")
        return QuestionAnswer.mr_findAllSorted(by: "dateAdded", ascending: true, with: pre) as! [QuestionAnswer]
    }
}
