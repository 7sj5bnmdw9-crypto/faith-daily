import SwiftUI

struct Prayer: Identifiable {
    let id = UUID()
    let title: String
    let text: String
}

let prayers = [
    Prayer(
        title: "Hail Mary",
        text: """
        Hail Mary, full of grace, the Lord is with thee.
        Blessed art thou among women, and blessed is the fruit
        of thy womb, Jesus.

        Holy Mary, Mother of God, pray for us sinners,
        now and at the hour of our death. Amen.
        """
    ),

    Prayer(
        title: "Prayer to St. Michael",
        text: """
        Saint Michael the Archangel, defend us in battle.
        Be our protection against the wickedness and snares
        of the devil.

        May God rebuke him, we humbly pray; and do thou,
        O Prince of the heavenly hosts, by the power of God,
        cast into hell Satan and all the evil spirits who prowl
        about the world seeking the ruin of souls. Amen.
        """
    ),

    Prayer(
        title: "Our Father",
        text: """
        Our Father, who art in heaven,
        hallowed be thy name;
        thy kingdom come;
        thy will be done
        on earth as it is in heaven.

        Give us this day our daily bread,
        and forgive us our trespasses,
        as we forgive those who trespass against us;

        and lead us not into temptation,
        but deliver us from evil. Amen.
        """
    ),

    Prayer(
        title: "Glory Be",
        text: """
        Glory be to the Father,
        and to the Son,
        and to the Holy Spirit,

        as it was in the beginning,
        is now, and ever shall be,
        world without end. Amen.
        """
    ),

    Prayer(
        title: "Guardian Angel Prayer",
        text: """
        Angel of God, my guardian dear,
        to whom God's love commits me here,

        ever this day be at my side,
        to light and guard,
        to rule and guide.

        Amen.
        """
    ),

    Prayer(
        title: "Grace Before Meals",
        text: """
        Bless us, O Lord,
        and these thy gifts,
        which we are about to receive
        from thy bounty,
        through Christ our Lord.

        Amen.
        """
    ),

    Prayer(
        title: "Morning Prayer",
        text: """
        Dear God,

        Thank you for giving me another day.
        Please guide me today, protect me,
        and help me make good choices.

        Help me to be kind, patient, and faithful.
        Help me remember that you are always with me.

        Amen.
        """
    ),

    Prayer(
        title: "Night Prayer",
        text: """
        Dear God,

        Thank you for everything you have given me today.
        Please forgive me for the things I have done wrong.

        Watch over my family and friends tonight.
        Give me peace and help me rest.

        Amen.
        """
    ),

    Prayer(
        title: "Prayer for Strength",
        text: """
        Dear God,

        Give me strength when things are difficult.
        Help me keep going when I want to give up.

        Help me trust you and remember that
        I never have to face hard times alone.

        Amen.
        """
    ),

    Prayer(
        title: "Prayer for Family",
        text: """
        Dear God,

        Please watch over my family.
        Keep them safe, healthy, and close to you.

        Help us love and support one another
        and grow together in faith.

        Amen.
        """
    ),

    Prayer(
        title: "Prayer for Peace",
        text: """
        Dear God,

        Bring peace to my heart and to my life.
        Help me let go of my worries
        and trust in you.

        Give peace to my family,
        my community, and the whole world.

        Amen.
        """
    )
]

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView()
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }
                .tag(0)

            BibleView()
                .tabItem {
                    Label("Bible", systemImage: "book.fill")
                }
                .tag(1)

            StudyView()
                .tabItem {
                    Label("Study", systemImage: "text.book.closed.fill")
                }
                .tag(2)

            PrayersView()
                .tabItem {
                    Label("Prayers", systemImage: "hands.sparkles.fill")
                }
                .tag(3)

            MotivationView()
                .tabItem {
                    Label("Motivation", systemImage: "heart.fill")
                }
                .tag(4)
        }
        .tint(.indigo)
    }
}

// MARK: - Home

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Faith Daily")
                        .font(.largeTitle.bold())

                    Text("Verse of the Day")
                        .font(.title2.bold())

                    VerseCard(
                        verse: "I can do all things through Christ who strengthens me.",
                        reference: "Philippians 4:13"
                    )

                    Text("Daily encouragement")
                        .font(.title2.bold())

                    Text("God has a plan for you. Keep going, keep praying, and remember that you are loved.")
                        .padding()
                        .background(.indigo.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding()
            }
            .navigationTitle("Today")
        }
    }
}

// MARK: - Verse Card

struct VerseCard: View {
    let verse: String
    let reference: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "cross.fill")
                .font(.title2)

            Text("“\(verse)”")
                .font(.title3.weight(.semibold))

            Text("— \(reference)")
                .font(.subheadline)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [.indigo, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Prayers

struct PrayersView: View {
    @State private var favorites: Set<UUID> = []

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Choose a prayer")
                        .font(.headline)
                }

                ForEach(prayers) { prayer in
                    NavigationLink {
                        PrayerDetailView(
                            prayer: prayer,
                            isFavorite: favorites.contains(prayer.id),
                            toggleFavorite: {
                                if favorites.contains(prayer.id) {
                                    favorites.remove(prayer.id)
                                } else {
                                    favorites.insert(prayer.id)
                                }
                            }
                        )
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "hands.sparkles.fill")
                                .foregroundStyle(.indigo)
                                .frame(width: 28)

                            Text(prayer.title)
                                .font(.headline)

                            Spacer()

                            if favorites.contains(prayer.id) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Prayers")
        }
    }
}

// MARK: - Prayer Detail

struct PrayerDetailView: View {
    let prayer: Prayer
    let isFavorite: Bool
    let toggleFavorite: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                HStack {
                    Image(systemName: "hands.sparkles.fill")
                        .font(.title)
                        .foregroundStyle(.indigo)

                    Text(prayer.title)
                        .font(.largeTitle.bold())

                    Spacer()

                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundStyle(.yellow)
                    }
                }

                Text(prayer.text)
                    .font(.title3)
                    .lineSpacing(8)
                    .padding(22)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.indigo.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .padding()
        }
        .navigationTitle("Prayer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Bible

struct BibleView: View {
    let books = [
        "Genesis", "Exodus", "Matthew", "Mark",
        "Luke", "John", "Romans", "Philippians", "Revelation"
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Bible") {
                    ForEach(books, id: \.self) { book in
                        NavigationLink(book) {
                            ChapterView(book: book)
                        }
                    }
                }
            }
            .navigationTitle("Bible")
        }
    }
}

struct ChapterView: View {
    let book: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("\(book) 1")
                    .font(.largeTitle.bold())

                Text("Bible text can be added here using a translation whose license permits redistribution.")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle(book)
    }
}

// MARK: - Study

struct StudyView: View {
    let topics = [
        ("Faith in hard times", "mountain.2.fill"),
        ("God's plan", "map.fill"),
        ("Prayer", "hands.sparkles.fill"),
        ("Hope", "sun.max.fill"),
        ("Love", "heart.fill")
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Bible Study") {
                    ForEach(topics, id: \.0) { topic in
                        HStack(spacing: 14) {
                            Image(systemName: topic.1)
                                .frame(width: 28)

                            Text(topic.0)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Study")
        }
    }
}

// MARK: - Motivation

struct MotivationView: View {
    let messages = [
        "Keep going. God is with you.",
        "You are never alone.",
        "God has a purpose for your life.",
        "Pray, trust, and keep moving forward.",
        "Your story is not over."
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(messages, id: \.self) { message in
                        Text(message)
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.gray.opacity(0.10))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding()
            }
            .navigationTitle("Motivation")
        }
    }
}

#Preview {
    ContentView()
}
