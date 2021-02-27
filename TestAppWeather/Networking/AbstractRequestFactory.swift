//
//  AbstractRequestFactory.swift
//  Shop
//
//  Created by Максим Вечирко on 20.12.2020.
//  Copyright © 2020 Максим Вечирко. All rights reserved.
//

import Alamofire

protocol AbstractRequestFactory {
    var errorParser: AbstractErrorParser {get}
    var sessionManager: Session {get}
    var queue: DispatchQueue {get}
    @discardableResult
    func request<T: Decodable>(request: URLRequestConvertible, completionHandler: @escaping(AFDataResponse<T>) -> ()) -> DataRequest
}

extension AbstractRequestFactory {
    @discardableResult
    public func request<T: Decodable>(
    request: URLRequestConvertible,
    completionHandler: @escaping (AFDataResponse<T>) -> Void)
        -> DataRequest {
            return sessionManager.request(request).responseCodable(errorParser: errorParser, queue: queue, completionHandler: completionHandler)
    }
}
