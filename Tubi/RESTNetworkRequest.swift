//
//  RESTNetworkRequest.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

enum CompletionData<DataType> {
    case error(Error)
    case success(DataType)
}

class RESTNetworkRequest {
    fileprivate let baseUrl = URL(string: "https://api.tenor.com/")
    fileprivate let command : String
    fileprivate var parameters : [String: String] = [:]
    
    init(command : String, parameters : [String : String]) {
        self.command = command
        self.parameters = parameters
    }
    
    private func makeNetworkRequest(_ url: URL, _ completion: @escaping (CompletionData<Data>) -> Void) {
        let request = URLRequest(url: url)
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.processError(error)
                completion(CompletionData.error(error!))
                return
            }
            completion(CompletionData.success(data))
        }
        task.resume()
    }
    
    public func send(_ completion: @escaping (_ completion : CompletionData<Data>) -> Void) {
        let urlData = command + urlQuery + paramString
        let url = URL(string: urlData, relativeTo: baseUrl!)
        if let url = url {
            makeNetworkRequest(url, completion)
        }
    }
    
    private var urlQuery : String {
        return "?"
    }
    
    private var paramString : String {
        // converts params from dictionary to format of &key=value
        var string = parameters.reduce("") { $0 + "&\($1.0)=\($1.1)" }
        string.removeFirst()
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    private func processError(_ error : Error?) {
        if let error = error {
            // generic error handling maybe for logging.
            print("network response error \(error)")
        }
    }
}
