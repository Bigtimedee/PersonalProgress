import Foundation
import SwiftData

struct DomainService {

    // MARK: - Domain management

    func createDomain(
        name: String,
        iconName: String = DomainIcon.star.rawValue,
        sortOrder: Int = 0,
        in context: ModelContext
    ) throws -> Domain {
        let domain = Domain(name: name, iconName: iconName, sortOrder: sortOrder)
        context.insert(domain)
        try context.save()
        return domain
    }

    func reorderDomains(_ domains: [Domain], in context: ModelContext) throws {
        for (index, domain) in domains.enumerated() {
            domain.sortOrder = index
        }
        try context.save()
    }

    func archiveDomain(_ domain: Domain, in context: ModelContext) throws {
        domain.isArchived = true
        try context.save()
    }

    // MARK: - DomainPlan management

    func createDomainPlan(
        for domain: Domain,
        year: Int,
        identityStatement: String = "",
        in context: ModelContext
    ) throws -> DomainPlan {
        let plan = DomainPlan(year: year, domain: domain, identityStatement: identityStatement)
        context.insert(plan)
        try context.save()
        return plan
    }

    func domainPlan(for domain: Domain, year: Int) -> DomainPlan? {
        domain.plan(forYear: year)
    }

    func addSuccessDefinition(
        text: String,
        to plan: DomainPlan,
        in context: ModelContext
    ) throws -> SuccessDefinition {
        let sortOrder = plan.successDefinitions.count
        let definition = SuccessDefinition(domainPlan: plan, text: text, sortOrder: sortOrder)
        context.insert(definition)
        plan.successDefinitions.append(definition)
        try context.save()
        return definition
    }

    func addIntention(
        type: IntentionType,
        title: String,
        to plan: DomainPlan,
        in context: ModelContext
    ) throws -> Intention {
        let sortOrder = plan.intentions.count
        let intention = Intention(domainPlan: plan, type: type, title: title, sortOrder: sortOrder)
        context.insert(intention)
        plan.intentions.append(intention)
        try context.save()
        return intention
    }
}
