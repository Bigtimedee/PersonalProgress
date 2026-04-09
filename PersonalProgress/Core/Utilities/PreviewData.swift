import Foundation
import SwiftData

/// Seed data for SwiftUI previews and development.
/// All data is for a fictional 2026 planning year.
/// This file is compiled into the main app target but only used by previews.
enum PreviewData {

    @MainActor
    static func populate(in context: ModelContext) {

        // MARK: - Annual Letter

        let letter = AnnualLetter(
            year: 2026,
            title: "My 2026 Letter",
            rawText: sampleLetterText,
            themeStatement: "2026 is the year I stop deferring the life I mean to live. I will be fully present with my family, relentless in my work, and disciplined in my body.",
            yearWord: "Presence",
            isSealed: false
        )
        context.insert(letter)

        // MARK: - Domains

        let domains: [(name: String, icon: DomainIcon, sort: Int)] = [
            ("Spouse", .heart, 0),
            ("Children", .personTwo, 1),
            ("Work", .briefcase, 2),
            ("Health", .leaf, 3),
            ("Mind", .brain, 4),
            ("Faith", .star, 5),
        ]

        for (name, icon, sort) in domains {
            let domain = Domain(name: name, iconName: icon.rawValue, sortOrder: sort)
            context.insert(domain)
            let plan = seedDomainPlan(name: name, domain: domain, in: context)
            _ = plan
        }

        // MARK: - Weekly Reflection (current week)

        let reflection = WeeklyReflection(
            weekStartDate: Date.now.startOfISOWeek,
            year: Date.now.calendarYear,
            weekNumber: Date.now.isoWeekNumber,
            weeklyPriorities: [
                "Ship the new onboarding flow",
                "Tuesday dinner with Sarah — no phones",
                "Thursday morning run"
            ]
        )
        reflection.weekReflectionText = "Strong week overall. The work block in the mornings is working well. I slipped on exercise mid-week but recovered on Friday."
        reflection.weekHighlight = "Had an uninterrupted two-hour conversation with my daughter about her future."
        context.insert(reflection)

        // MARK: - Quarterly Review (Q1 2026)

        let q1Review = QuarterlyReview(year: 2026, quarter: .q1, letterWasReRead: true)
        q1Review.overallReflectionText = "Q1 was strong in Work and Health. Marriage fell short — I was too distracted in January and February. I course-corrected in March."
        q1Review.quarterHighlight = "Closed the largest deal of my career in February."
        q1Review.quarterGap = "Missed most of my Sunday evening rituals due to travel in January."
        q1Review.keyAdjustment = "Schedule travel so I am home on Sunday evenings except for true exceptions."
        context.insert(q1Review)
    }

    // MARK: - Domain Plan Seed

    private static func seedDomainPlan(name: String, domain: Domain, in context: ModelContext) -> DomainPlan {
        let data = domainSeedData[name] ?? domainSeedData["Work"]!
        let plan = DomainPlan(
            year: 2026,
            domain: domain,
            identityStatement: data.identity
        )
        context.insert(plan)

        for (index, text) in data.successDefinitions.enumerated() {
            let def = SuccessDefinition(domainPlan: plan, text: text, sortOrder: index)
            context.insert(def)
            plan.successDefinitions.append(def)
        }

        for (index, item) in data.intentions.enumerated() {
            let intention = Intention(
                domainPlan: plan,
                type: item.type,
                title: item.title,
                note: item.note,
                sortOrder: index,
                frequency: item.frequency
            )
            context.insert(intention)
            plan.intentions.append(intention)
        }

        return plan
    }

    // MARK: - Seed Data Definitions

    private struct IntentionSeed {
        let type: IntentionType
        let title: String
        let note: String?
        let frequency: IntentionFrequency?
    }

    private struct DomainSeed {
        let identity: String
        let successDefinitions: [String]
        let intentions: [IntentionSeed]
    }

    private static let domainSeedData: [String: DomainSeed] = [
        "Spouse": DomainSeed(
            identity: "I am a fully present, engaged, and intentional partner. I choose Sarah every day.",
            successDefinitions: [
                "I will know I succeeded if we complete two extended trips alone together this year.",
                "I will know I succeeded if she tells me at year-end that I was truly present.",
            ],
            intentions: [
                IntentionSeed(type: .ritual, title: "Weekly date night — phones away", note: nil, frequency: .weekly),
                IntentionSeed(type: .commitment, title: "Never cancel a date night for work unless it is a genuine emergency", note: nil, frequency: nil),
                IntentionSeed(type: .goal, title: "Plan and take the Italy trip we have talked about for five years", note: "Target: September", frequency: nil),
                IntentionSeed(type: .habit, title: "End each evening with a 10-minute check-in", note: nil, frequency: .daily),
            ]
        ),
        "Children": DomainSeed(
            identity: "I am a deeply engaged father who shows up with full attention and genuine curiosity.",
            successDefinitions: [
                "I will know I succeeded if each child says at year-end that they felt truly seen by me.",
                "I will know I succeeded if I miss zero of their milestone events this year.",
            ],
            intentions: [
                IntentionSeed(type: .commitment, title: "Never miss a school performance, recital, or game", note: nil, frequency: nil),
                IntentionSeed(type: .ritual, title: "One-on-one outing with each child monthly", note: nil, frequency: .monthly),
                IntentionSeed(type: .habit, title: "Be home for dinner 4 nights per week", note: nil, frequency: .weekly),
            ]
        ),
        "Work": DomainSeed(
            identity: "I am a focused, decisive, and high-output professional who does the most important work first.",
            successDefinitions: [
                "I will know I succeeded if I hit my annual revenue target.",
                "I will know I succeeded if I complete my two strategic initiatives by Q3.",
                "I will know I succeeded if I do my most important work before 10am every day.",
            ],
            intentions: [
                IntentionSeed(type: .habit, title: "Deep work block 7–10am, no interruptions", note: "Phone on Do Not Disturb", frequency: .weekdays),
                IntentionSeed(type: .goal, title: "Launch the new product line by June 1", note: nil, frequency: nil),
                IntentionSeed(type: .ritual, title: "Weekly review every Friday at 4pm", note: "30 minutes: what worked, what didn't, priorities next week", frequency: .weekly),
                IntentionSeed(type: .actionItem, title: "Read 'The Great CEO Within'", note: nil, frequency: nil),
            ]
        ),
        "Health": DomainSeed(
            identity: "I am a person who treats my body as the vehicle for everything I care about. I do not negotiate on this.",
            successDefinitions: [
                "I will know I succeeded if I exercise at least 4 times per week for 48 of 52 weeks.",
                "I will know I succeeded if I complete my annual physical and all recommended follow-ups.",
                "I will know I succeeded if I average 7+ hours of sleep per night.",
            ],
            intentions: [
                IntentionSeed(type: .habit, title: "Exercise 4x per week minimum", note: "Running, lifting, or tennis", frequency: .weekly),
                IntentionSeed(type: .habit, title: "In bed by 10:30pm on weeknights", note: nil, frequency: .weekdays),
                IntentionSeed(type: .actionItem, title: "Complete annual physical by end of February", note: nil, frequency: nil),
                IntentionSeed(type: .ritual, title: "Sunday morning long run", note: "Non-negotiable — this is my reset", frequency: .weekly),
            ]
        ),
        "Mind": DomainSeed(
            identity: "I am a continuous learner who protects time for thinking, reading, and reflection.",
            successDefinitions: [
                "I will know I succeeded if I read 20 books this year.",
                "I will know I succeeded if I maintain a weekly review practice for the full year.",
            ],
            intentions: [
                IntentionSeed(type: .habit, title: "Read 30 minutes before bed", note: nil, frequency: .daily),
                IntentionSeed(type: .goal, title: "Complete 20 books", note: nil, frequency: nil),
                IntentionSeed(type: .ritual, title: "Monthly half-day thinking retreat", note: "No phone, no meetings — just thinking and journaling", frequency: .monthly),
            ]
        ),
        "Faith": DomainSeed(
            identity: "I am a man of quiet but serious faith. I make time for what I believe matters most.",
            successDefinitions: [
                "I will know I succeeded if I maintain a consistent morning practice for the year.",
            ],
            intentions: [
                IntentionSeed(type: .ritual, title: "20 minutes of morning prayer and reflection", note: nil, frequency: .daily),
                IntentionSeed(type: .commitment, title: "Attend weekly service with my family", note: nil, frequency: .weekly),
            ]
        ),
    ]

    // MARK: - Sample letter text

    private static let sampleLetterText = """
    January 2026

    This is the year I stop deferring the life I mean to live.

    I have spent too many years meaning to be present and too many evenings distracted. That ends now.

    My word for 2026 is Presence.

    SPOUSE

    Sarah deserves a husband who is actually here. Not physically present while mentally somewhere else. Actually here. I am committing to weekly dates, nightly check-ins, and the Italy trip we have talked about for five years.

    CHILDREN

    Each of my children needs to feel genuinely seen by their father. I will be home for dinner. I will never miss a performance. I will take each of them on a dedicated one-on-one outing every month.

    WORK

    My deep work block is sacred. 7 to 10am, every weekday, on my most important project. The rest of the day can be reactive. Those three hours cannot.

    HEALTH

    Four workouts per week. In bed by 10:30. Annual physical done by February. No negotiation.

    MIND

    Twenty books. Weekly reflection. One half-day per month to think without interruption.

    FAITH

    Twenty minutes every morning. No exceptions.

    This is the year.
    """
}
