//
//  PlaylistDetailResponse.swift
//  SpotifyClone
//
//  Created by Sen Lin on 4/3/2022.
//

import Foundation

struct PlaylistDetailResponse: Codable{
    let description: String
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    let snapshot_id: String
    let tracks: PlaylistTrackResponse
}

struct PlaylistTrackResponse: Codable{
    let href: String
    let items: [PlaylistTrack]
}

struct PlaylistTrack: Codable{
    let track: PlaylistTrackDetail
}

struct PlaylistTrackDetail: Codable{
    let artists: [Artist]
    let href: String
    let id: String
    let images: [APIImage]?
    let name: String
    let uri: String
}


//{
//    collaborative = 0;
//    description = "New age music for balancing mind and body.";
//    "external_urls" =     {
//        spotify = "https://open.spotify.com/playlist/37i9dQZF1DX9uKNf5jGX6m";
//    };
//    followers =     {
//        href = "<null>";
//        total = 1711506;
//    };
//    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX9uKNf5jGX6m";
//    id = 37i9dQZF1DX9uKNf5jGX6m;
//    images =     (
//                {
//            height = "<null>";
//            url = "https://i.scdn.co/image/ab67706f000000034ba00eaa7b36e3001a201f8f";
//            width = "<null>";
//        }
//    );
//    name = "Yoga & Meditation";
//    owner =     {
//        "display_name" = Spotify;
//        "external_urls" =         {
//            spotify = "https://open.spotify.com/user/spotify";
//        };
//        href = "https://api.spotify.com/v1/users/spotify";
//        id = spotify;
//        type = user;
//        uri = "spotify:user:spotify";
//    };
//    "primary_color" = "#ffffff";
//    public = 0;
//    "snapshot_id" = MTY0NjM5Nzc1NywwMDAwMDA5ZTAwMDAwMTdmNTRmNDE2YjcwMDAwMDE2ZDE1MzJkNWUy;
//    tracks =     {
//        href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX9uKNf5jGX6m/tracks?offset=0&limit=100&locale=en-US,en;q=0.9";
//        items =         (
//                        {
//                "added_at" = "2022-03-04T12:42:37Z";
//                "added_by" =                 {
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/user/";
//                    };
//                    href = "https://api.spotify.com/v1/users/";
//                    id = "";
//                    type = user;
//                    uri = "spotify:user:";
//                };
//                "is_local" = 0;
//                "primary_color" = "<null>";
//                track =                 {
//                    album =                     {
//                        "album_type" = single;
//                        artists =                         (
//                                                        {
//                                "external_urls" =                                 {
//                                    spotify = "https://open.spotify.com/artist/3cpzUGjbTlToxJzxfWiW1u";
//                                };
//                                href = "https://api.spotify.com/v1/artists/3cpzUGjbTlToxJzxfWiW1u";
//                                id = 3cpzUGjbTlToxJzxfWiW1u;
//                                name = "Zion Llama";
//                                type = artist;
//                                uri = "spotify:artist:3cpzUGjbTlToxJzxfWiW1u";
//                            }
//                        );
//                        "available_markets" =                         (
//                            VU,
//                            WS,
//                            XK,
//                            ZA,
//                            ZM,
//                            ZW
//                        );
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/album/1GgB6wCGMjv9eIWbysYO4x";
//                        };
//                        href = "https://api.spotify.com/v1/albums/1GgB6wCGMjv9eIWbysYO4x";
//                        id = 1GgB6wCGMjv9eIWbysYO4x;
//                        images =                         (
//                                                        {
//                                height = 640;
//                                url = "https://i.scdn.co/image/ab67616d0000b27357cf285c4188618077658f1a";
//                                width = 640;
//                            },
//                                                        {
//                                height = 300;
//                                url = "https://i.scdn.co/image/ab67616d00001e0257cf285c4188618077658f1a";
//                                width = 300;
//                            },
//                                                        {
//                                height = 64;
//                                url = "https://i.scdn.co/image/ab67616d0000485157cf285c4188618077658f1a";
//                                width = 64;
//                            }
//                        );
//                        name = Aura;
//                        "release_date" = "2022-01-15";
//                        "release_date_precision" = day;
//                        "total_tracks" = 2;
//                        type = album;
//                        uri = "spotify:album:1GgB6wCGMjv9eIWbysYO4x";
//                    };
//                    artists =                     (
//                                                {
//                            "external_urls" =                             {
//                                spotify = "https://open.spotify.com/artist/3cpzUGjbTlToxJzxfWiW1u";
//                            };
//                            href = "https://api.spotify.com/v1/artists/3cpzUGjbTlToxJzxfWiW1u";
//                            id = 3cpzUGjbTlToxJzxfWiW1u;
//                            name = "Zion Llama";
//                            type = artist;
//                            uri = "spotify:artist:3cpzUGjbTlToxJzxfWiW1u";
//                        }
//                    );
//                    "available_markets" =                     (
//
//                        UY,
//                        UZ,
//                        VC,
//                        VE,
//                        VN,
//                        VU,
//                        WS,
//                        XK,
//                        ZA,
//                        ZM,
//                        ZW
//                    );
//                    "disc_number" = 1;
//                    "duration_ms" = 175792;
//                    episode = 0;
//                    explicit = 0;
//                    "external_ids" =                     {
//                        isrc = SE4RG2204502;
//                    };
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/track/1eWEJ1JVoyt0nozyAoUPZW";
//                    };
//                    href = "https://api.spotify.com/v1/tracks/1eWEJ1JVoyt0nozyAoUPZW";
//                    id = 1eWEJ1JVoyt0nozyAoUPZW;
//                    "is_local" = 0;
//                    name = Restfulness;
//                    popularity = 60;
//                    "preview_url" = "https://p.scdn.co/mp3-preview/932ed8dd54e17e8518cc0e5c99e02b10ea98a281?cid=2f7ae715677d4329a111ad5ebe51f2a0";
//                    track = 1;
//                    "track_number" = 2;
//                    type = track;
//                    uri = "spotify:track:1eWEJ1JVoyt0nozyAoUPZW";
//                };
//                "video_thumbnail" =                 {
//                    url = "<null>";
//                };
//            },
//                        {
//                "added_at" = "2022-03-04T12:42:37Z";
//                "added_by" =                 {
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/user/";
//                    };
//                    href = "https://api.spotify.com/v1/users/";
//                    id = "";
//                    type = user;
//                    uri = "spotify:user:";
//                };
//                "is_local" = 0;
//                "primary_color" = "<null>";
//                track =                 {
//                    album =                     {
//                        "album_type" = single;
//                        artists =                         (
//                                                        {
//                                "external_urls" =                                 {
//                                    spotify = "https://open.spotify.com/artist/1KOpTTK7jSd3rF41wbjwmx";
//                                };
//                                href = "https://api.spotify.com/v1/artists/1KOpTTK7jSd3rF41wbjwmx";
//                                id = 1KOpTTK7jSd3rF41wbjwmx;
//                                name = Dajwin;
//                                type = artist;
//                                uri = "spotify:artist:1KOpTTK7jSd3rF41wbjwmx";
//                            }
//                        );
//                        "available_markets" =                         (
//                            AD,
//                            AE,
//                            AG,
//                            AL,
//                            AM,
//                            AO,
//                            AR,
//                            AT,
//                            AU,
//                            AZ,
