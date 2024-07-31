//
//  AddMusicItemViewModel.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import CoreGraphics
import UniformTypeIdentifiers

@MainActor
class FirestoreViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage: String?
    private let database = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    private let storage = Storage.storage()
    @Published var genres = [String]()
    @Published var countries = [String]()
    @Published var styles = [String]()
    @Published var uploadStatus: String?
    init() { loadStyles()
        loadGenres()
        loadCountries()
    }
    private func loadCountries() {
        countries = [
            "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda",
            "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas",
            "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize",
            "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana",
            "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cabo Verde",
            "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad",
            "Chile", "China", "Colombia", "Comoros", "Congo (Congo-Brazzaville)",
            "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czechia (Czech Republic)",
            "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominica",
            "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea",
            "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Fiji",
            "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana",
            "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana",
            "Haiti", "Holy See", "Honduras", "Hungary", "Iceland", "India", "Indonesia",
            "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan",
            "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan", "Laos", "Latvia",
            "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia", "Maldives",
            "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico",
            "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco",
            "Mozambique", "Myanmar (formerly Burma)", "Namibia", "Nauru", "Nepal",
            "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea",
            "North Macedonia (formerly Macedonia)", "Norway", "Oman", "Pakistan",
            "Palau", "Palestine State", "Panama", "Papua New Guinea", "Paraguay", "Peru",
            "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda",
            "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines",
            "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal",
            "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia",
            "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan",
            "Spain", "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago",
            "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates",
            "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela",
            "Vietnam", "Yemen", "Zambia", "Zimbabwe"
            
        ]
    }
    private func loadStyles() {
        styles = [
            // Populate the array with all styles
            "Pop Rock", "House", "Vocal", "Experimental", "Punk", "Synth-pop",
            "Alternative Rock", "Techno", "Indie Rock", "Soul", "Disco", "Ambient",
            "Hardcore", "Folk", "Hard Rock", "Ballad", "Country", "Electro",
            "Rock & Roll", "Chanson", "Heavy Metal", "Trance", "Psychedelic Rock",
            "Romantic", "Folk Rock", "Soundtrack", "Downtempo", "Noise", "Classic Rock",
            "Prog Rock", "Schlager", "Funk", "Easy Listening", "Black Metal", "Blues Rock",
            "Tech House", "New Wave", "Rhythm & Blues", "Industrial", "Deep House",
            "Classical", "Death Metal", "Progressive House", "Drum n Bass", "Euro House",
            "Soft Rock", "Abstract", "Garage Rock", "Gospel", "Europop", "Minimal",
            "Acoustic", "Thrash", "Baroque", "Swing", "Modern", "Big Band", "Country Rock",
            "Contemporary Jazz", "Dub", "Indie Pop", "Drone", "Breakbeat", "Progressive Trance",
            "Opera", "Holiday", "Contemporary", "Dancehall", "RnB/Swing", "IDM", "Breaks",
            "African", "Art Rock", "Reggae", "Fusion", "Dark Ambient", "Gangsta", "Post-Punk",
            "Religious", "Doom Metal", "Pop Rap", "Avantgarde", "Dance-pop", "Electro House",
            "Beat", "Hard Trance", "Rockabilly", "Contemporary R&B", "Jazz-Funk", "Score",
            "Instrumental", "Lo-Fi", "Roots Reggae", "Comedy", "Acid", "Theme", "Grindcore",
            "Leftfield", "Ska", "Dubstep", "Spoken Word", "Soul-Jazz", "Glam", "Post Rock",
            "Psy-Trance", "Power Pop", "Hip Hop", "Bop", "Bolero", "Modern Classical",
            "New Age", "Salsa", "Goth Rock", "Jazz-Rock", "Conscious", "Hard House",
            "Free Improvisation", "Cumbia", "Trip Hop", "Musical", "Emo", "Latin Jazz",
            "Stoner Rock", "Italo-Disco", "Hard Bop", "J-pop", "Volksmusik", "EBM", "MPB",
            "Surf", "Free Jazz", "Shoegaze", "Field Recording", "Hardstyle", "Story", "Jungle",
            "Doo Wop", "Pop Punk", "Cool Jazz", "Tango", "Garage House", "Samba", "Synthwave",
            "Oi", "Post Bop", "Celtic", "Choral", "Darkwave", "Radioplay", "Happy Hardcore",
            "Bluegrass", "Eurodance", "UK Garage", "Vaporwave", "Laïkó", "Smooth Jazz",
            "Trap", "Tribal", "Metalcore", "Polka", "Grunge", "Novelty", "Flamenco",
            "Arena Rock", "Hardcore Hip-Hop", "Italodance", "Progressive Metal",
            "Symphonic Rock", "Southern Rock", "Dixieland", "Nu Metal", "AOR", "Hindustani",
            "Latin", "Harsh Noise Wall", "Parody", "Future Jazz", "Glitch", "Rumba",
            "Audiobook", "Boom Bap", "Cha-Cha", "Power Metal", "Space Rock", "Krautrock",
            "Merengue", "Bossa Nova", "Speed Metal", "Dub Techno", "Gabber", "Kayōkyoku",
            "Thug Rap", "Breakcore", "Hi NRG", "Neo-Classical", "Poetry"]
    }
    private func loadGenres() {
        genres = ["Rock", "Electronic", "Pop", "Folk, World, & Country", "Jazz", "Funk / Soul", "Classical", "Hip Hop", "Latin", "Stage & Screen", "Reggae", "Blues", "Non-Music", "Children's", "Brass & Military"]
    }
    func addMusicItemWithImage(ownerUID: String, title: String, year: String, country: String, label: String, genre: String, style: String, barcode: String, catno: String, imageData: Data?, isPublic: Bool, inTrash: Bool, retryCount: Int = 3) async {
        isLoading = true        
        // Check if image data is provided, if not, create Music Item without an image
        guard let imageData = imageData else {
            await createMusicItem(ownerUID: ownerUID, title: title, year: year, country: country, label: label, genre: genre, style: style, barcode: barcode, catno: catno, coverImageUrl: nil, isPublic: isPublic, inTrash: inTrash)
            return
        }
        // Reference to the image location in Firebase Storage
        let imageRef = storageRef.child("images/\(ownerUID)/\(UUID().uuidString).jpg")
        for attempt in 1...retryCount {
            do {
                // Attempt to upload the image
                _ = try await imageRef.putDataAsync(imageData)
                // Get the URL for the uploaded image
                let coverImageUrl = try await imageRef.downloadURL().absoluteString
                // Create the MusicItem with the obtained cover image URL
                await createMusicItem(ownerUID: ownerUID, title: title, year: year, country: country, label: label, genre: genre, style: style, barcode: barcode, catno: catno, coverImageUrl: coverImageUrl, isPublic: isPublic, inTrash: inTrash)
                return
            } catch {
                print("Attempt \(attempt) failed with error: \(error.localizedDescription)")
                if attempt == retryCount {
                    print("Max retry attempts reached. Unable to upload image.")
                    alertMessage = "Error uploading image after \(retryCount) attempts: \(error.localizedDescription)"
                    isLoading = false
                    return
                }
                do {
                    // Retry after 2 seconds if an error occurs
                    try await Task.sleep(nanoseconds: UInt64(2_000_000_000))
                } catch {
                    print("Error while sleeping before retry: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    // Helper method to create the music item in Firestore
    private func createMusicItem(ownerUID: String, title: String, year: String, country: String, label: String?, genre: String?, style: String?, barcode: String?, catno: String?, coverImageUrl: String?, isPublic: Bool, inTrash: Bool) async {
        let musicItemRef = database.collection("users").document(ownerUID).collection("userMusicItems").document()
        var data: [String: Any] = [
            "id": musicItemRef.documentID,
            "ownerUID": ownerUID,
            "title": title,
            "year": year,
            "country": country,
            "isPublic": isPublic,
            "addedDate": Timestamp(date: Date()),
            "lastEdited": Timestamp(date: Date()),
            "uri": "",
            "resourceUrl": "",
            "coverImage": coverImageUrl ?? "",
            "format": [],
            "inTrash": inTrash
        ]
        // Add optional fields only if they have values, converting to arrays where needed
        if let label = label, !label.isEmpty { data["label"] = [label] }
        if let genre = genre, !genre.isEmpty { data["genre"] = [genre] }
        if let style = style, !style.isEmpty { data["style"] = [style] }
        if let barcode = barcode, !barcode.isEmpty { data["barcode"] = barcode }
        if let catno = catno, !catno.isEmpty { data["catno"] = catno }
        do {
            // Set data to Firestore
            try await musicItemRef.setData(data)
            alertMessage = "Music Item successfully added."
            print("Music item added successfully with ID: \(musicItemRef.documentID)")
        } catch let error {
            print("Firestore write error: \(error.localizedDescription)")
            alertMessage = "Error writing document: \(error.localizedDescription)"
        }
        isLoading = false
    }
    // Asynchronous method to delete a music item, including its cover image from Firebase Storage
    func deleteMusicItem(itemId: String, ownerUID: String, coverImageUrl: String?) async {
        let userMusicItemsRef = database.collection("users").document(ownerUID).collection("userMusicItems")
        // Attempt to delete the music item document from Firestore
        do {
            try await userMusicItemsRef.document(itemId).delete()
            print("Successfully deleted Firestore document with ID: \(itemId)")
            // If cover image URL exists, attempt to delete the image from Firebase Storage
            if let coverImageUrl = coverImageUrl, !coverImageUrl.isEmpty {
                if coverImageUrl.contains("firebasestorage.googleapis.com") {
                    // Extract the storage path from the URL
                    let regex = try! NSRegularExpression(pattern: "/o/(.*)\\?", options: [])
                    if let match = regex.firstMatch(in: coverImageUrl, options: [], range: NSRange(location: 0, length: coverImageUrl.utf16.count)),
                       let range = Range(match.range(at: 1), in: coverImageUrl) {
                        let storagePath = String(coverImageUrl[range]).removingPercentEncoding ?? ""
                        let coverImageRef = storageRef.child(storagePath)
                        do {
                            try await coverImageRef.delete()
                            print("Successfully deleted cover image from storage.")
                        } catch {
                            print("Error removing cover image from storage: \(error.localizedDescription)")
                        }
                    } else {
                        print("Failed to extract path from cover image URL.")
                    }
                } else {
                    print("Invalid cover image URL.")
                }
            }
        } catch {
            print("Error removing document from Firestore: \(error.localizedDescription)")
        }
    }
    func convertAndSaveToFirestore(apiMusicItem: APIMusicItem, ownerUID: String) async {
        // Fetch detailed information
        guard let resourceUrl = apiMusicItem.resourceUrl else {
            print("Resource URL is missing")
            return
        }
        let detailedItem: DetailedAPIMusicItem
        do {
            detailedItem = try await fetchDetailedMusicItem(resourceUrl: resourceUrl)
        } catch {
            print("Error fetching detailed music item: \(error.localizedDescription)")
            return
        }
        // Convert DetailedAPIMusicItem.Track to MusicItem.Track
        let tracklist: [MusicItem.Track]? = detailedItem.tracklist?.map {
            MusicItem.Track(position: $0.position, title: $0.title, duration: $0.duration)
        }
        // Convert DetailedAPIMusicItem.Video to MusicItem.Video
        let videos: [MusicItem.Video]? = detailedItem.videos?.map {
            MusicItem.Video(uri: $0.uri, title: $0.title)
        }
        // Save the MusicItem to Firestore, let Firestore automatically generate an ID
        let musicItemsRef = database.collection("users").document(ownerUID).collection("userMusicItems")
        
        let musicItem = MusicItem(
            id: "", // Placeholder value, Firestore will assign a proper value
            addedDate: Date(),
            barcode: apiMusicItem.barcode?.first,
            catno: apiMusicItem.catno,
            country: apiMusicItem.country,
            coverImage: apiMusicItem.coverImage ?? apiMusicItem.thumb,
            format: apiMusicItem.format,
            genre: apiMusicItem.genre,
            isPublic: false,
            label: apiMusicItem.label,
            lastEdited: Date(),
            ownerUID: ownerUID,
            resourceUrl: apiMusicItem.resourceUrl,
            style: apiMusicItem.style,
            thumb: apiMusicItem.thumb,
            title: apiMusicItem.title,
            uri: apiMusicItem.uri,
            year: apiMusicItem.year,
            inTrash: false,
            links: [],
            privateNote: "",
            userRating: 0,
            tracklist: tracklist,
            videos: videos
        )
        do {
            let documentReference = try musicItemsRef.addDocument(from: musicItem)
            print("Music item added successfully with ID: \(documentReference.documentID)")
        } catch {
            print("Error saving MusicItem to Firestore: \(error.localizedDescription)")
        }
    }
    // Method to fetch detailed music item
    private func fetchDetailedMusicItem(resourceUrl: String) async throws -> DetailedAPIMusicItem {
        let data = try await NetworkService().fetchData(from: resourceUrl)
        let decodedResponse = try JSONDecoder().decode(DetailedAPIMusicItem.self, from: data)
        return decodedResponse
    }
}
