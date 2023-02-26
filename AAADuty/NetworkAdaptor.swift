//
//  NetworkAdaptor.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import Foundation
import UIKit


enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

class Headers {
    static func getHeaders() -> [String: String] {
        return ["Content-Type": "application/json", "X-API-KEY": "cpaiYdow0H1N49p4wwnI16H1h3ceEE8X7jsFaPj6"]
    }
}


class NetworkAdaptor {
    static func request(urlString: String, method: NetworkMethod, bodyParameters: [String: Any]? = nil, urlParameters: [String: String]? = nil, headers: [String: String]? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        var urlString1 = urlString
        
        urlString1 = urlString1 + "?"
        
        for (key, value) in urlParameters ?? [:] {
            urlString1 = urlString1 + key + "=" + value + "&"
        }
        
        urlString1.removeLast()
        
        guard let url = URL(string: urlString1) else {
            completionHandler(nil, nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        
        if let bodyParameters = bodyParameters {
            let bodyData = try? JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            request.httpBody = bodyData
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }.resume()
    }
    
    static func requestWithHeaders(urlString: String, method: NetworkMethod, bodyParameters: [String: Any]? = nil, urlParameters: [String: String]? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        request(urlString: urlString, method: method, bodyParameters: bodyParameters, urlParameters: urlParameters, headers: Headers.getHeaders(), completionHandler: completionHandler)
    }
}



