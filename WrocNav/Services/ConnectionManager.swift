//
//  ConnectionManager.swift
//  WrocNav
//
//  Created by Kacper Raczy on 07.08.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyBeaver

protocol Route: URLRequestConvertible {
    var path: String { get }
    var needsAuth: Bool { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Any? { get }
}

extension Route {
    var basePath: String {
        return ConnectionManager.enviroment.basePath
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if body != nil {
            return try JSONEncoding().encode(request, withJSONObject: body!)
        }
        
        return request
    }
}

typealias DecodingStrategy<Response> = (Data, AnyObserver<Response>) -> ()

class ConnectionManager: RequestAdapter {
    enum Enviroment {
        case localhost(port: Int)
        case test
        case production
        case custom(path: String)
        
        var basePath: String {
            switch self {
            // simulator only
            case .localhost(port: let port):
                return "localhost:\(port)"
            case .test:
                return "<url>" //TODO: test url
            case .production:
                return "<url>" //TODO: prod url
            case .custom(path: let path):
                return path
            }
        }
    }
    
    enum ApiError: Error {
        case authorization
        case deserialization
    }
    
    static let enviroment: Enviroment = .localhost(port: 1337)
    private let sessionManager: SessionManager
    private(set) var decoder: JSONDecoder = JSONDecoder()

    init() {
        let configuration = URLSessionConfiguration.default
        sessionManager = SessionManager(configuration: configuration)
        sessionManager.adapter = self
    }
    
    func execute(route: Route) -> Observable<Void> {
        return execute(route: route, decodingStrategy: nil)
    }
    
    func execute<Response: Decodable>(route: Route) -> Observable<Response> {
        return execute(route: route, decodingStrategy: { (data, observer) in
            do {
                let decoded = try self.decoder.decode(Response.self, from: data)
                observer.onNext(decoded)
            } catch let error {
                observer.onError(error)
            }
        })
    }
    
    func execute(route: Route) -> Observable<[String: Any]> {
        return execute(route: route, decodingStrategy: { (data, observer) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dict = json as? [String: Any] {
                    observer.onNext(dict)
                } else {
                    throw ApiError.deserialization
                }
            } catch let error {
                observer.onError(error)
            }
        })
    }
    
    private func execute<Response>(route: Route, decodingStrategy: DecodingStrategy<Response>?) -> Observable<Response> {
        return Observable.create({ (observer) -> Disposable in
            let request = self.sessionManager.request(route)
            request
                .validate(statusCode: 200..<300)
                .responseData(completionHandler: { (response) in
                log.responseBody(response)
                switch response.result {
                case .failure(let error):
                    observer.onError(error)
                case .success(let value):
                    decodingStrategy?(value, observer)
                }
                observer.onCompleted()
            })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    //MARK: Request adapter
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        // custom request customization if needed
        // for now just return unmodified request
        return urlRequest
    }
    
}

extension SwiftyBeaver {
    class func responseBody<T>(_ response: DataResponse<T>?) {
        responseBody(response?.data)
    }
    
    class func responseBody(_ data: Data?) {
        if let bodyData = data, let body = String.init(data: bodyData, encoding: .utf8) {
            log.debug("Response body: \(body)")
        } else {
            log.debug("Response body: Empty")
        }
    }
}
