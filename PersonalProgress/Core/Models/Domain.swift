import Foundation
import SwiftData

// MARK: - Enums

/// The icon used to visually identify a domain.
enum DomainIcon: String, Codable, CaseIterable {
    case heart = "heart.fill"
    case house = "house.fill"
    case person = "person.fill"
    case personTwo = "person.2.fill"
    case briefcase = "briefcase.fill"
    case chart = "chart.line.uptrend.xyaxis"
    case brain = "brain.head.profile"
    case leaf = "leaf.fill"
    case book = "book.fill"
    case star = "star.fill"
    case flame = "flame.fill"
    case bolt = "bolt.fill"
    case globe = "globe"
    case music = "music.note"
    case camera = "camera.fill"
}

/// The sort order within the domain list.
typealias DomainSortOrder = Int

// MARK: - Domain

/// A persistent life domain that carries across all years.
/// Examples: Spouse, Children, Work, Health, Mind, Faith, Friendships.
/// Domains accumulate history via their DomainPlan relationship.
@Model
final class Domain {
    var name: String
    var iconName: String
    var sortOrder: DomainSortOrder
    var isArchived: Bool
    var createdAt: Date

    /// All yearly plans attached to this domain. One per year.
    @Relationship(deleteRule: .cascade, inverse: \DomainPlan.domain)
    var plans: [DomainPlan] = []

    init(
        name: String,
        iconName: String = DomainIcon.star.rawValue,
        sortOrder: Int = 0,
        isArchived: Bool = false,
        createdAt: Date = .now
    ) {
        self.name = name
        self.iconName = iconName
        self.sortOrder = sortOrder
        self.isArchived = isArchived
        self.createdAt = createdAt
    }

    /// The plan for a specific year, if one exists.
    func plan(forYear year: Int) -> DomainPlan? {
        plans.first { $0.year == year }
    }
}
