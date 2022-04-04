//
//  PlaylistTrack.swift
//  SpotifyClone
//
//  Created by Sen Lin on 4/4/2022.
//

import Foundation

struct PlaylistTracks: Codable{
    let items: [UserPlaylistTrackDetail]
}

struct UserPlaylistTrackDetail: Codable{
    let track: AudioTrack
}

//
//items =     (
//            {
//        "added_at" = "2021-11-14T06:43:28Z";
//        "added_by" =             {
//            "external_urls" =                 {
//                spotify = "https://open.spotify.com/user/21d7xkunhjd5hopj2rz3ahfaa";
//            };
//            href = "https://api.spotify.com/v1/users/21d7xkunhjd5hopj2rz3ahfaa";
//            id = 21d7xkunhjd5hopj2rz3ahfaa;
//            type = user;
//            uri = "spotify:user:21d7xkunhjd5hopj2rz3ahfaa";
//        };
//        "is_local" = 0;
//        "primary_color" = "<null>";
//        track =             {
//            album =                 {
//                "album_type" = album;
//                artists =                     (
//                                            {
//                        "external_urls" =                             {
//                            spotify = "https://open.spotify.com/artist/7y97mc3bZRFXzT2szRM4L4";
//                        };
//                        href = "https://api.spotify.com/v1/artists/7y97mc3bZRFXzT2szRM4L4";
//                        id = 7y97mc3bZRFXzT2szRM4L4;
//                        name = "Fr\U00e9d\U00e9ric Chopin";
//                        type = artist;
//                        uri = "spotify:artist:7y97mc3bZRFXzT2szRM4L4";
//                    },
//                                            {
//                        "external_urls" =                             {
//                            spotify = "https://open.spotify.com/artist/2VIdKQmRHnWofsR4odfFOh";
//                        };
//                        href = "https://api.spotify.com/v1/artists/2VIdKQmRHnWofsR4odfFOh";
//                        id = 2VIdKQmRHnWofsR4odfFOh;
//                        name = "Maurizio Pollini";
//                        type = artist;
//                        uri = "spotify:artist:2VIdKQmRHnWofsR4odfFOh";
//                    }
//                );
//                "available_markets" =                     (
//                    VE,
//                    VN,
//                    WS,
//                    XK,
//                    ZA,
//                    ZM,
//                    ZW
//                );
//                "external_urls" =                     {
//                    spotify = "https://open.spotify.com/album/6beqQKZ9CiKs8MHUuShzN3";
//                };
//                href = "https://api.spotify.com/v1/albums/6beqQKZ9CiKs8MHUuShzN3";
//                id = 6beqQKZ9CiKs8MHUuShzN3;
//                images =                     (
//                                            {
//                        height = 640;
//                        url = "https://i.scdn.co/image/ab67616d0000b2737ab1b51f3a37b29b782b3e94";
//                        width = 640;
//                    },
//                                            {
//                        height = 300;
//                        url = "https://i.scdn.co/image/ab67616d00001e027ab1b51f3a37b29b782b3e94";
//                        width = 300;
//                    },
//                                            {
//                        height = 64;
//                        url = "https://i.scdn.co/image/ab67616d000048517ab1b51f3a37b29b782b3e94";
//                        width = 64;
//                    }
//                );
//                name = "Chopin: Etudes; Pr\U00e9ludes; Polonaises";
//                "release_date" = "1984-01-01";
//                "release_date_precision" = day;
//                "total_tracks" = 55;
//                type = album;
//                uri = "spotify:album:6beqQKZ9CiKs8MHUuShzN3";
//            };
//            artists =                 (
//                                    {
//                    "external_urls" =                         {
//                        spotify = "https://open.spotify.com/artist/7y97mc3bZRFXzT2szRM4L4";
//                    };
//                    href = "https://api.spotify.com/v1/artists/7y97mc3bZRFXzT2szRM4L4";
//                    id = 7y97mc3bZRFXzT2szRM4L4;
//                    name = "Fr\U00e9d\U00e9ric Chopin";
//                    type = artist;
//                    uri = "spotify:artist:7y97mc3bZRFXzT2szRM4L4";
//                },
//                                    {
//                    "external_urls" =                         {
//                        spotify = "https://open.spotify.com/artist/2VIdKQmRHnWofsR4odfFOh";
//                    };
//                    href = "https://api.spotify.com/v1/artists/2VIdKQmRHnWofsR4odfFOh";
//                    id = 2VIdKQmRHnWofsR4odfFOh;
//                    name = "Maurizio Pollini";
//                    type = artist;
//                    uri = "spotify:artist:2VIdKQmRHnWofsR4odfFOh";
//                }
//            );
//            "available_markets" =                 (
//                AD,
//                AE,
//                AG,
