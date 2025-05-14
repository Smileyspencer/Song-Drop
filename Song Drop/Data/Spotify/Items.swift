/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Items : Codable {
	let album : Album?
	let artists : [Artists]?
	let disc_number : Int?
	let duration_ms : Int?
	let explicit : Bool?
	let external_ids : External_ids?
	let external_urls : External_urls?
	let href : String?
	let id : String?
	let is_local : Bool?
	let is_playable : Bool?
	let name : String?
	let popularity : Int?
	let preview_url : String?
	let track_number : Int?
	let type : String?
	let uri : String?

	enum CodingKeys: String, CodingKey {

		case album = "album"
		case artists = "artists"
		case disc_number = "disc_number"
		case duration_ms = "duration_ms"
		case explicit = "explicit"
		case external_ids = "external_ids"
		case external_urls = "external_urls"
		case href = "href"
		case id = "id"
		case is_local = "is_local"
		case is_playable = "is_playable"
		case name = "name"
		case popularity = "popularity"
		case preview_url = "preview_url"
		case track_number = "track_number"
		case type = "type"
		case uri = "uri"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		album = try values.decodeIfPresent(Album.self, forKey: .album)
		artists = try values.decodeIfPresent([Artists].self, forKey: .artists)
		disc_number = try values.decodeIfPresent(Int.self, forKey: .disc_number)
		duration_ms = try values.decodeIfPresent(Int.self, forKey: .duration_ms)
		explicit = try values.decodeIfPresent(Bool.self, forKey: .explicit)
		external_ids = try values.decodeIfPresent(External_ids.self, forKey: .external_ids)
		external_urls = try values.decodeIfPresent(External_urls.self, forKey: .external_urls)
		href = try values.decodeIfPresent(String.self, forKey: .href)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		is_local = try values.decodeIfPresent(Bool.self, forKey: .is_local)
		is_playable = try values.decodeIfPresent(Bool.self, forKey: .is_playable)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		popularity = try values.decodeIfPresent(Int.self, forKey: .popularity)
		preview_url = try values.decodeIfPresent(String.self, forKey: .preview_url)
		track_number = try values.decodeIfPresent(Int.self, forKey: .track_number)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
	}

}