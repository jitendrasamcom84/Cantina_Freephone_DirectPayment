import UIKit

class CountryInfo: NSObject {
    
    class func parseJSON(code : String) -> String {
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [[String : Any]]
                for dict in jsonResult{
                    if dict["code"] as! String == code{
                        return dict["dial_code"] as! String
                    }
                }
            } catch {
                
            }
        }
        return "+972"
    }
}

