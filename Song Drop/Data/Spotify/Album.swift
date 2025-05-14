/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Album : Codable {
	let album_type : String?
	let artists : [Artists]?
	let external_urls : External_urls?
	let href : String?
	let id : String?
	let images : [Images]?
	let is_playable : Bool?
	let name : String?
	let release_date : String?
	let release_date_precision : String?
	let total_tracks : Int?
	let type : String?
	let uri : String?

	enum CodingKeys: String, CodingKey {

		case album_type = "album_type"
		case artists = "artists"
		case external_urls = "external_urls"
		case href = "href"
		case id = "id"
		case images = "images"
		case is_playable = "is_playable"
		case name = "name"
		case release_date = "release_date"
		case release_date_precision = "release_date_precision"
		case total_tracks = "total_tracks"
		case type = "type"
		case uri = "uri"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		album_type = try values.decodeIfPresent(String.self, forKey: .album_type)
		artists = try values.decodeIfPresent([Artists].self, forKey: .artists)
		external_urls = try values.decodeIfPresent(External_urls.self, forKey: .external_urls)
		href = try values.decodeIfPresent(String.self, forKey: .href)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		images = try values.decodeIfPresent([Images].self, forKey: .images)
		is_playable = try values.decodeIfPresent(Bool.self, forKey: .is_playable)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
		release_date_precision = try values.decodeIfPresent(String.self, forKey: .release_date_precision)
		total_tracks = try values.decodeIfPresent(Int.self, forKey: .total_tracks)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
	}

}