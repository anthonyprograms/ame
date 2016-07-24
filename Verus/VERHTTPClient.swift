//
//  VERHttpClient.swift
//  Verus
//
//  Created by Anthony Williams on 7/23/16.
//  Copyright © 2016 Verus. All rights reserved.
//

import UIKit
import Alamofire

class VERHTTPClient: NSObject {
    
    let sentimentDomain = "https://watson-api-explorer.mybluemix.net/alchemy-api/calls/url/URLGetTextSentiment?apikey=57336f4ed2137157286c4fdf5a24ad8385108209&url=http%3A%2F%2Fwww.greatbigstory.com%2Fstories%2Fthis-man-runs-a-micronation-of-32-people%3Fiid%3Dob_homepage_showcase_pool-test&outputMode=json"
    let titleDomain = "https://watson-api-explorer.mybluemix.net/alchemy-api/calls/url/URLGetTitle?apikey=57336f4ed2137157286c4fdf5a24ad8385108209&url=http%3A%2F%2Fwww.greatbigstory.com%2Fstories%2Fthis-man-runs-a-micronation-of-32-people%3Fiid%3Dob_homepage_showcase_pool-test&outputMode=json"
    let textDomain = "https://watson-api-explorer.mybluemix.net/alchemy-api/calls/url/URLGetText?apikey=57336f4ed2137157286c4fdf5a24ad8385108209&url=http%3A%2F%2Fwww.greatbigstory.com%2Fstories%2Fthis-man-runs-a-micronation-of-32-people%3Fiid%3Dob_homepage_showcase_pool-test&outputMode=json"
    let keywordDomain = "https://watson-api-explorer.mybluemix.net/alchemy-api/calls/url/URLGetRankedKeywords?apikey=57336f4ed2137157286c4fdf5a24ad8385108209&url=http%3A%2F%2Fwww.greatbigstory.com%2Fstories%2Fthis-man-runs-a-micronation-of-32-people%3Fiid%3Dob_homepage_showcase_pool-test&outputMode=json"
    
    
    func postLink(link: String, completion: (data: AnyObject) -> ()) {
        Alamofire.request(.POST, sentimentDomain, parameters: ["url": link])
            .responseJSON { response in
                if let JSON = response.result.value {
                    completion(data: JSON)
                }
            }
    }
    
    func getTitle(link: String, completion: (data: AnyObject) -> ()) {
        Alamofire.request(.POST, titleDomain, parameters: ["url": link])
            .responseJSON { response in
                if let JSON = response.result.value {
                    completion(data: JSON)
                }
        }
    }
    
    func getText(link: String, completion: (data: AnyObject) -> ()) {
        Alamofire.request(.POST, textDomain, parameters: ["url": link])
            .responseJSON { response in
                if let JSON = response.result.value {
                    completion(data: JSON)
                }
        }
    }
    
    func getKeywords(link: String, completion: (data: AnyObject) -> ()) {
        Alamofire.request(.POST, keywordDomain, parameters: ["url": link, "sentiment": 1])
            .responseJSON { response in
                if let JSON = response.result.value {
                    completion(data: JSON)
                    print(JSON)
                }
            }
    }
}

