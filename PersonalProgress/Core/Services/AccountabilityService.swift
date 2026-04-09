import Foundation
import SwiftData

// MARK: - DomainStatus

enum DomainStatus {
    case onTrack    // Rated within the last 14 days
    case atRisk     // Last rated 15–28 days ago
    case neglected  // Not rated in 28+ days
    case new        // Plan created < 14 days ago, no ratings yet

    var statusPillStyle: StatusPillStyle {
        switch self {
        case .onTrack:   return .onTrack
        case .atRisk:    return .atRisk
        case .neglected: return .neglected
        case .new:       return .neutral
        }
    }

    var label: String {
        switch self {
        case .onTrack:   return "On Track"
        case .atRisk:    return "At Risk"
        case .neglected: return "Neglected"
        case .new:       return "Getting Started"
        }
    }

    var systemImage: String {
        switch self {
        case .onTrack:   return "checkmark.circle.fill"
        case .atRisk:    return "exclamationmark.triangle.fill"
        case .neglected: return "minus.circle.fill"
        case .new:       return "sparkles"
        }
    }
}

// MARK: - AccountabilityService

/// Computes accountability status for domains.
/// Local-first, privacy-first. No external servers. Not punitive.
final class AccountabilityService {

    nonisolated(unsafe) static let shared = AccountabilityService()

    // MARK: - Domain Status

    /// Status based on how recently the domain was self-rated in weekly reflections.
    func status(for domain: Domain, year: Int, context: ModelContext) -> DomainStatus {
        guard let plan = domain.plan(forYear: year) else { return .new }

        let descriptor = FetchDescriptor<DomainWeeklyRating>(
            predicate: #Predicate { $0.domainName == domain.name }
        )
        let allRatings = (try? context.fetch(descriptor)) ?? []
        let mostRecent = allRatings.max(by: { $0.createdAt < $1.createdAt })

        let now = Date.now

        if let mostRecent {
            let days = Calendar.current.dateComponents([.day], from: mostRecent.createdAt, to: now).day ?? 0
            switch days {
            case ...14:  return .onTrack
            case ...28:  return .atRisk
            default:     return .neglected
            }
        } else {
            let daysSincePlan = Calendar.current.dateComponents([.day], from: plan.createdAt, to: now).day ?? 0
            return daysSincePlan <= 14 ? .new : .neglected
        }
    }

    // MARK: - Year Summary

    struct YearSummary {
        let onTrackCount: Int
        let atRiskCount: Int
        let neglectedCount: Int
        let newCount: Int
        let totalActive: Int

        var headline: String {
            if totalActive == 0 { return "No active domains" }
            if neglectedCount == 0 && atRiskCount == 0 { return "All domains on track" }
            if atRiskCount + neglectedCount == totalActive { return "Time for a check-in" }
            let healthy = onTrackCount + newCount
            return "\(healthy) of \(totalActive) domains on track"
        }
    }

    func yearSummary(domains: [Domain], year: Int, context: ModelContext) -> YearSummary {
        let active = domains.filter { !$0.isArchived }
        var onTrack = 0, atRisk = 0, neglected = 0, new = 0
        for domain in active {
            switch status(for: domain, year: year, context: context) {
            case .onTrack:   onTrack += 1
            case .atRisk:    atRisk += 1
            case .neglected: neglected += 1
            case .new:       new += 1
            }
        }
        return YearSummary(
            onTrackCount: onTrack,
            atRiskCount: atRisk,
            neglectedCount: neglected,
            newCount: new,
            totalActive: active.count
        )
    }

    // MARK: - Course Correction

    /// A brief, non-judgmental nudge. Returns nil when no action is needed.
    func nudge(for status: DomainStatus, domainName: String) -> String? {
        switch status {
        case .atRisk:
            return "Rate \(domainName) in your next weekly reflection to keep momentum."
        case .neglected:
            return "\(domainName) hasn't been touched in a while. Even a brief note helps."
        default:
            return nil
        }
    }
}
