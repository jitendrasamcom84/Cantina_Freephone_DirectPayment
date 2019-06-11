
import Foundation
import UIKit
class webAPI:NSObject  {
    
    func callApi(request:NSDictionary, url:String, perameter:String) -> NSDictionary {
        let url = URL(string: "https://api.wheniwork.com/2/login")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["W-Key": "xxxxxxxxxxx","Content-Type":"application/json"]
        let parameters = ["username": "ss@xxx.ca", "password": "sssdsds"]
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return ["":""]
    }
}
