import Foundation
import SwiftData

struct ReviewService {

    func review(forYear year: Int, quarter: Quarter, in context: ModelContext) throws -> QuarterlyReview? {
        let quarterRaw = quarter.rawValue
        let descriptor = FetchDescriptor<QuarterlyReview>(
            predicate: #Predicate { $0.year == year && $0.quarter == quarter }
        )
        return try context.fetch(descriptor).first
    }

    func createReview(forYear year: Int, quarter: Quarter, in context: ModelContext) throws -> QuarterlyReview {
        let review = QuarterlyReview(year: year, quarter: quarter)
        context.insert(review)
        try context.save()
        return review
    }

    func currentOrCreateReview(in context: ModelContext) throws -> QuarterlyReview {
        let now = Date.now
        let year = now.calendarYear
        let month = Calendar.current.component(.month, from: now)
        let quarter = Quarter(rawValue: (month - 1) / 3 + 1) ?? .q1
        if let existing = try review(forYear: year, quarter: quarter, in: context) {
            return existing
        }
        return try createReview(forYear: year, quarter: quarter, in: context)
    }

    func completeReview(_ review: QuarterlyReview, in context: ModelContext) throws {
        review.completedAt = .now
        try context.save()
    }

    func lockExpiredReviews(in context: ModelContext) throws {
        let now = Date.now
        let descriptor = FetchDescriptor<QuarterlyReview>(
            predicate: #Predicate { !$0.isLocked }
        )
        let unlocked = try context.fetch(descriptor)
        for review in unlocked {
            if let lockDate = review.lockDate, lockDate < now {
                review.isLocked = true
            }
        }
        try context.save()
    }
}
