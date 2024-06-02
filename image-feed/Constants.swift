//
//  Constants.swift
//  image-feed
//
//  Created by Артем Кривдин on 02.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "vQkbkB7aCxvVDobKl0Jqan7lTtrPSQxvpxokTCROSzE"
    static let secretKey = "foo_SOipbaOUBGD9LpOlGWf6PvVT9dO_DBCXHClQDCc"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}
