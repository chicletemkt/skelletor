//
//  iTunesModel.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 23/03/17.
//  Copyjson © 2017 Nineteen Apps. All jsons reserved.
//

import Foundation
import UIKit

public struct Price {
    public var amount = 0.0
    public var currency = ""
}

public struct Artist {
    public var label = ""
    public var link : URL?
}

/// iTunes JSON model. The JSON parser will generate collections of such a class for an app consumption. 
/// - important: This implementation is not complete or generic. It is specific to solve Nineteen's problems
/// regarding affiliate links
public class iTunesModel {
    /// Feed entry name
    public var name: String?
    /// Image URL list associated with the feed entry
    public var images: [URL]?
    /// Summary about iTunes item
    public var summary: String?
    /// URL to iTunes item on store
    public var link: URL?
    /// Item price
    public var price: Price?
    /// Artist, i.e., item vendor
    public var artist: Artist?
    
    /// Parses a JSON dictionary
    func parse (from json: [String:Any]) {
        name = (json["im:name"] as? [String:Any])?["label"] as? String
        if let jsonImages = json["im:image"] as? [[String:Any]] {
            images = []
            for image in jsonImages {
                if let path = image["label"] as? String {
                    if let url = URL(string: path) {
                        images?.append(url)
                    }
                }
            }
        }
        summary = (json["summary"] as? [String:String])?["label"]
        if let linkPath = ((json["link"] as? [String:Any])?["attributes"] as? [String:String])?["href"] {
            link = URL(string: linkPath)
        }
        if let jsonPrice = (json["im:price"] as? [String:Any])?["attributes"] as? [String:String] {
            price = Price()
            price?.currency = jsonPrice["currency"]!
            let fmt = NumberFormatter()
            fmt.currencyCode = price?.currency
            price?.amount = fmt.number(from: jsonPrice["amount"]!)!.doubleValue
        }
        if let jsonArtist = json["im:artist"] as? [String:Any] {
            artist = Artist()
            artist?.label = jsonArtist["label"] as! String
            if let linkPath = (jsonArtist["attributes"] as? [String:String])?["href"] {
                artist?.link = URL(string: linkPath)!
            }
        }
    }
}
