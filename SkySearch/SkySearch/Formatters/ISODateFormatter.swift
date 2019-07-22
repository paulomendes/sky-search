import Foundation

struct ISO8601DateTransformer {
    static var dateFormater: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}

extension String {
    func toDate() -> Date {
        guard let date = ISO8601DateTransformer.dateFormater.date(from: self.appending("Z")) else {
            preconditionFailure("Date is not on ISO8601 format")
        }
        return date
    }
}
