//
//  HttpCode.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 25/07/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation

public struct HttpCode {
    static let messages = [
        100: NSLocalizedString("Your client should continue with its request.", comment: "Http Status Code 100"),
        101: NSLocalizedString("Server wants to switch protocol", comment: "Http Status Code 101"),
        200: NSLocalizedString("Request OK", comment: "Http Status Code 200"),
        201: NSLocalizedString("Resource Created", comment: "Http Status Code 201"),
        202: NSLocalizedString("Request Accepted for Processing", comment: "Http Status Code 202"),
        203: NSLocalizedString("Meta-information returned from server", comment: "Http Status Code 203"),
        204: NSLocalizedString("Server sent no content for the received request", comment: "Http Status Code 204"),
        205: NSLocalizedString("Your client must reset its view content", comment: "Http Status Code 205"),
        206: NSLocalizedString("Server has sent partial content", comment: "Http Status Code 206"),
        300: NSLocalizedString("Redirection has multiple choices", comment: "Http Status Code 300"),
        301: NSLocalizedString("Resource has moved permanently", comment: "Http Status Code 301"),
        302: NSLocalizedString("Resource was found", comment: "Http Status Code 302"),
        303: NSLocalizedString("Resource in on other location", comment: "Http Status Code 303"),
        304: NSLocalizedString("Resource not modified", comment: "Http Status Code 304"),
        305: NSLocalizedString("Resource must be accessed through a proxy", comment: "Http Status Code 305"),
        306: NSLocalizedString("Unused.", comment: "Http Status Code 306"),
        307: NSLocalizedString("Resource is temporarily on other location", comment: "Http Status Code 307"),
        400: NSLocalizedString("Request was not recognized by server", comment: "Http Status Code 400"),
        401: NSLocalizedString("Unauthrozed to access the requested resource", comment: "Http Status Code 401"),
        402: NSLocalizedString("Payment required to access the requested resource", comment: "Http Status Code 402"),
        403: NSLocalizedString("You are forbidden to access this resource", comment: "Http Status Code 403"),
        404: NSLocalizedString("Resource not found on this server", comment: "Http Status Code 404"),
        405: NSLocalizedString("This method is no allowed on server", comment: "Http Status Code 405"),
        406: NSLocalizedString("Resource does not accept the provided method", comment: "Http Status Code 406"),
        407: NSLocalizedString("Authentication on the proxy is necessary", comment: "Http Status Code 407"),
        408: NSLocalizedString("Request has timed out", comment: "Http Status Code 408"),
        409: NSLocalizedString("Found conflict on requested resource state", comment: "Http Status Code 409"),
        410: NSLocalizedString("Resource is not available anymore.", comment: "Http Status Code 410"),
        411: NSLocalizedString("You must provide a request length to continue.", comment: "Http Status Code 411"),
        412: NSLocalizedString("Precondition has failed.", comment: "Http Status Code 412"),
        413: NSLocalizedString("Client request is too large.", comment: "Http Status Code 413"),
        414: NSLocalizedString("Request URI is too long.", comment: "Http Status Code 414"),
        415: NSLocalizedString("Server cannot support the media provided by the request.", comment: "Http Status Code 415"),
        416: NSLocalizedString("Request range cannot be satisfied by the server.", comment: "Http Status Code 416"),
        417: NSLocalizedString("Expectation failed", comment: "Http Status Code 417"),
        500: NSLocalizedString("Server was unable to complete request due to an internal error.", comment: "Http Status Code 500"),
        501: NSLocalizedString("Requested method is not implemented.", comment: "Http Status Code 501"),
        502: NSLocalizedString("Provided gateway is bad.", comment: "Http Status Code 502"),
        503: NSLocalizedString("Service is unavailable.", comment: "Http Status Code 503"),
        504: NSLocalizedString("Gateway has timed out", comment: "Http Status Code 504"),
        505: NSLocalizedString("Request HTTP version is unsupported by the server", comment: "Http Status Code 505"),
    ]
    
    public let code: Int
    public var localizedMessage: String? {
        return HttpCode.messages[code]
    }
    init (code: Int) {
        self.code = code
    }
    
}
