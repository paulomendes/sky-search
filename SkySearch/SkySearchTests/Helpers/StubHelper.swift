import Foundation

extension Decodable {
    public static func stubbed(from filename: String) -> Self {
        let data = Stub.response(from: filename)
        return try! JSONDecoder().decode(Self.self, from: data)
    }
}

class Stub {
    static func response(from filename: String) -> Data {
        guard let path = Stub.path(from: filename, ofType: "json") else {
            fatalError("Could not find a stubbed archive with filename: \(filename)")
        }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            fatalError("Could not load a stubbed response with filename: \(filename)\n" +
                "At path: \(path)\nError: \(error.localizedDescription)")
        }
    }

    static func path(from filename: String, ofType type: String) -> String? {
        let bundle = Bundle(for: Stub.self)
        if let path = bundle.path(forResource: filename, ofType: type, inDirectory: "DataManagerTests.bundle") {
            return path
        }
        if let path = bundle.path(forResource: filename, ofType: type) {
            return path
        }
        return nil
    }
}
