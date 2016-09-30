//
//  ResponseParserProtocol.swift
//  Wibree
//
//  Created by 村上幸雄 on 2016/09/30.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

import Foundation

public let kResponseParserNoError: Int = 0
public let kResponseParserGenericError: Int = 1

public enum ResponseParserNetworkSate {
    case NotConnected
    case InProgress
    case Finished
    case Error
    case Canceled
}

public typealias ResponseParserCompletionHandler = (ResponseParserProtocol)

public protocol ResponseParserDelegate {
    func parserDidReceiveResponse(parser: ResponseParserProtocol, response: URLResponse)
    func parserDidReceiveData(parser: ResponseParserProtocol, data: NSData)
    func parserDidFinishLoading(parser: ResponseParserProtocol)
    func parserDidFailWithError(parser: ResponseParserProtocol, error: NSError)
    func parserDidCancel(parser: ResponseParserProtocol)
}

public protocol ResponseParserProtocol {
    var networkState: ResponseParserNetworkSate { get }
    var error: NSError? { get set }
    var queue: OperationQueue { get set }
    var delegate: ResponseParserDelegate { get set }
    var completionHandler: ResponseParserCompletionHandler { get set }
    
    func parse()
    func cancel()
}
