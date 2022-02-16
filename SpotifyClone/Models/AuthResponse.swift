//
//  AuthResponse.swift
//  SpotifyClone
//
//  Created by Sen Lin on 14/2/2022.
//

import Foundation

struct AuthResponse: Codable{
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}



//{
//    "access_token" = "BQAepl8lj9RjJ9pErnhLUV0HmY9NOHRa3EPLx5D8xhJsHnJvjDqm7cNt9ZeiY22XVgFj-kG1thPQTzSia6A3rCIyBtk_zaZxb-BMNXtz2P6Zc4sgKgcUbdgAQfpAC9yGr5k556xt4QYxlnbQL6Uzbup98ohnf1w4HA0XlNiId5mcuKSjPZw";
//    "expires_in" = 3600;
//    "refresh_token" = "AQAZFxq3U7uUYfGWzp2SMnyfD5agg69vmnUeKRZixokCr9wQtF77oBA7m3e9v_zyLFr0ROjf8oVfHsZtvE-gOB8x_eaXt-lX_0NUGkWmLkF2-pDujtnR5mVZbwFQK5-cnsA";
//    scope = "user-read-private";
//    "token_type" = Bearer;
//}
