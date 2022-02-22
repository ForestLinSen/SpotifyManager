//
//  NewReleasesResponse.swift
//  SpotifyClone
//
//  Created by Sen Lin on 22/2/2022.
//

import Foundation

struct NewReleasesResponse: Codable{
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable{
    let items: [Album]
}

struct Album: Codable{
    let album_type: String
    let artists: [Artist]
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let type: String
    let uri: String
}

struct Artist: Codable{
    let id: String
    let name: String
    let type: String
}

//
//Debug: release response error: typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "albums", intValue: nil), CodingKeys(stringValue: "items", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0), CodingKeys(stringValue: "total_tracks", intValue: nil)], debugDescription: "Expected to decode String but found a number instead.", underlyingError: nil))

//Debug: new releases response {
//    albums =     {
//        href = "https://api.spotify.com/v1/browse/new-releases?locale=en-US%2Cen%3Bq%3D0.9&offset=0&limit=2";
//        items =         (
//                        {
//                "album_type" = single;
//                artists =                 (
//                                        {
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/artist/2LIk90788K0zvyj2JJVwkJ";
//                        };
//                        href = "https://api.spotify.com/v1/artists/2LIk90788K0zvyj2JJVwkJ";
//                        id = 2LIk90788K0zvyj2JJVwkJ;
//                        name = "Jack Harlow";
//                        type = artist;
//                        uri = "spotify:artist:2LIk90788K0zvyj2JJVwkJ";
//                    }
//                );
//                "available_markets" =                 (
//                    AD,
//                    AE,
//                    ZW
//                );
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/album/72r4dr0xDsXOWRwP2o7ZIP";
//                };
//                href = "https://api.spotify.com/v1/albums/72r4dr0xDsXOWRwP2o7ZIP";
//                id = 72r4dr0xDsXOWRwP2o7ZIP;
//                images =                 (
//                                        {
//                        height = 640;
//                        url = "https://i.scdn.co/image/ab67616d0000b27378f69f03ed1625da85cb462b";
//                        width = 640;
//                    },
//                                        {
//                        height = 300;
//                        url = "https://i.scdn.co/image/ab67616d00001e0278f69f03ed1625da85cb462b";
//                        width = 300;
//                    },
//                                        {
//                        height = 64;
//                        url = "https://i.scdn.co/image/ab67616d0000485178f69f03ed1625da85cb462b";
//                        width = 64;
//                    }
//                );
//                name = "Nail Tech";
//                "release_date" = "2022-02-18";
//                "release_date_precision" = day;
//                "total_tracks" = 2;
//                type = album;
//                uri = "spotify:album:72r4dr0xDsXOWRwP2o7ZIP";
//            },
