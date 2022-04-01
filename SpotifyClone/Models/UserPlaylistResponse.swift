//
//  UserPlaylistResponse.swift
//  SpotifyClone
//
//  Created by Sen Lin on 31/3/2022.
//

import Foundation

struct UserPlaylistResponse: Codable{
    let href: String
    let items: [UserPlaylist]
}

struct UserPlaylist: Codable{
    let id: String
    let images: [APIImage]
    let name: String
    let description: String
    let owner: User
    let snapshot_id: String
}

//struct User: Codable{
//    let display_name: String
//    let external_urls: [String: String]
//    let href: String
//    let type: String
//    let uri: String
//}



//{
//    href = "https://api.spotify.com/v1/users/21d7xkunhjd5hopj2rz3ahfaa/playlists?offset=0&limit=2";
//    items =     (
//                {
//            collaborative = 0;
//            description = "";
//            "external_urls" =             {
//                spotify = "https://open.spotify.com/playlist/1351ZM8Y89WDkxx2kSIji8";
//            };
//            href = "https://api.spotify.com/v1/playlists/1351ZM8Y89WDkxx2kSIji8";
//            id = 1351ZM8Y89WDkxx2kSIji8;

//            name = "Let's slow down";
//            owner =             {
//                "display_name" = "\U6797\U68ee";
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/user/21d7xkunhjd5hopj2rz3ahfaa";
//                };
//                href = "https://api.spotify.com/v1/users/21d7xkunhjd5hopj2rz3ahfaa";
//                id = 21d7xkunhjd5hopj2rz3ahfaa;
//                type = user;
//                uri = "spotify:user:21d7xkunhjd5hopj2rz3ahfaa";
//            };
//            "primary_color" = "<null>";
//            public = 1;
//            "snapshot_id" = "MzAsMjNhYTZlNDY0MTIwYTllNmI5Yjc2NGRkYzMzYjUzYTJlMzVkNzdmYw==";
//            tracks =             {
//                href = "https://api.spotify.com/v1/playlists/1351ZM8Y89WDkxx2kSIji8/tracks";
//                total = 28;
//            };
//            type = playlist;
//            uri = "spotify:playlist:1351ZM8Y89WDkxx2kSIji8";
//        },
//                {
//            collaborative = 0;
//            description = "";
//            "external_urls" =             {
//                spotify = "https://open.spotify.com/playlist/1dwGNn4gggRKZjyWddfoJz";
//            };
//            href = "https://api.spotify.com/v1/playlists/1dwGNn4gggRKZjyWddfoJz";
//            id = 1dwGNn4gggRKZjyWddfoJz;
//            images =             (
//                                {
//                    height = 640;
//                    url = "https://i.scdn.co/image/ab67616d0000b2739dedd5f89dfb786cbf648ccb";
//                    width = 640;
//                }
//            );
//            name = "Rachmaninoff Piano Concertos 2 & 3";
//            owner =             {
//                "display_name" = elainamckie;
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/user/elainamckie";
//                };
//                href = "https://api.spotify.com/v1/users/elainamckie";
//                id = elainamckie;
//                type = user;
//                uri = "spotify:user:elainamckie";
//            };
//            "primary_color" = "<null>";
//            public = 0;
//            "snapshot_id" = "MTEsMjc1ZjUxMjUwM2EwZWYyYzExMjRiZjY0YmM3NTUzZWMyYzA0ODI2NQ==";
//            tracks =             {
//                href = "https://api.spotify.com/v1/playlists/1dwGNn4gggRKZjyWddfoJz/tracks";
//                total = 6;
//            };
//            type = playlist;
//            uri = "spotify:playlist:1dwGNn4gggRKZjyWddfoJz";
//        }
//    );
//    limit = 2;
//    next = "https://api.spotify.com/v1/users/21d7xkunhjd5hopj2rz3ahfaa/playlists?offset=2&limit=2";
//    offset = 0;
//    previous = "<null>";
//    total = 15;
//}
