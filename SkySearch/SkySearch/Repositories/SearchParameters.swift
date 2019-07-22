import Foundation

final class SearchParameters {
    static private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    let outboundDate: Date  = {
        let calendar = Calendar(identifier: .gregorian)
        var nextMonday = DateComponents()
        nextMonday.weekday = 2

        return calendar.nextDate(after: Date(),
                                 matching: nextMonday,
                                 matchingPolicy: .nextTime,
                                 direction: .forward)!
    }()

    var inboundDate: Date {
        var followingDay = DateComponents()
        followingDay.day = 1
        return Calendar.current.date(byAdding: followingDay, to: outboundDate)!
    }

    var inboundDateString: String {
        return SearchParameters.dateFormatter.string(from: inboundDate)
    }

    var outboundDateString: String {
        return SearchParameters.dateFormatter.string(from: outboundDate)
    }
}
