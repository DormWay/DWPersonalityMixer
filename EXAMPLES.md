# PersonalityMixer Examples

## Basic Integration

### Simple AI Personality Selector

```swift
import SwiftUI
import PersonalityMixer

struct AIAssistantSetupView: View {
    @State private var selectedPersonality: String = "Balanced"
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Configure Your AI Assistant")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            PersonalityMixerView { blend in
                // Determine personality based on dominant trait
                if let dominant = blend.max(by: { $0.weight < $1.weight }) {
                    switch dominant.trait.name {
                    case "Creative":
                        selectedPersonality = "Imaginative Assistant"
                    case "Analytical":
                        selectedPersonality = "Logical Assistant"
                    case "Empathetic":
                        selectedPersonality = "Caring Assistant"
                    case "Practical":
                        selectedPersonality = "Efficient Assistant"
                    default:
                        selectedPersonality = "Balanced Assistant"
                    }
                }
            }
            
            Text("Selected: \(selectedPersonality)")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
```

### Game Character Creator

```swift
import SwiftUI
import PersonalityMixer

struct CharacterCreatorView: View {
    @State private var characterStats: CharacterStats = CharacterStats()
    
    let elementTraits = [
        PersonalityTrait(name: "Fire", color: .red, icon: "flame.fill", position: .top),
        PersonalityTrait(name: "Water", color: .blue, icon: "drop.fill", position: .right),
        PersonalityTrait(name: "Earth", color: .brown, icon: "leaf.fill", position: .bottom),
        PersonalityTrait(name: "Air", color: .mint, icon: "wind", position: .left)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Your Element")
                .font(.largeTitle)
                .fontWeight(.black)
            
            PersonalityMixerView(traits: elementTraits) { blend in
                // Update character stats based on element mix
                characterStats.updateFromBlend(blend)
            }
            
            // Display resulting stats
            VStack(alignment: .leading, spacing: 12) {
                StatRow(label: "Attack", value: characterStats.attack, color: .red)
                StatRow(label: "Defense", value: characterStats.defense, color: .blue)
                StatRow(label: "Health", value: characterStats.health, color: .green)
                StatRow(label: "Speed", value: characterStats.speed, color: .orange)
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct CharacterStats {
    var attack: Int = 50
    var defense: Int = 50
    var health: Int = 50
    var speed: Int = 50
    
    mutating func updateFromBlend(_ blend: [(trait: PersonalityTrait, weight: Double)]) {
        // Fire increases attack, Water increases defense, etc.
        attack = Int(blend.first { $0.trait.name == "Fire" }?.weight ?? 0 * 100)
        defense = Int(blend.first { $0.trait.name == "Water" }?.weight ?? 0 * 100)
        health = Int(blend.first { $0.trait.name == "Earth" }?.weight ?? 0 * 100)
        speed = Int(blend.first { $0.trait.name == "Air" }?.weight ?? 0 * 100)
    }
}

struct StatRow: View {
    let label: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text("\(value)")
                .font(.title3.monospacedDigit())
                .foregroundColor(color)
        }
    }
}
```

### Music Genre Mixer

```swift
import SwiftUI
import PersonalityMixer

struct MusicMixerView: View {
    @State private var playlistName: String = "My Mix"
    @State private var genreBlend: [(String, Int)] = []
    
    let musicTraits = [
        PersonalityTrait(name: "Rock", color: .red, icon: "guitars.fill", position: .top),
        PersonalityTrait(name: "Jazz", color: .purple, icon: "music.note", position: .right),
        PersonalityTrait(name: "Electronic", color: .cyan, icon: "wave.3.right", position: .bottom),
        PersonalityTrait(name: "Classical", color: .brown, icon: "pianokeys", position: .left)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Create Your Perfect Mix")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                PersonalityMixerView(traits: musicTraits) { blend in
                    genreBlend = blend.map { 
                        ($0.trait.name, Int($0.weight * 100))
                    }
                    updatePlaylistName(from: blend)
                }
                
                // Playlist preview
                VStack(alignment: .leading, spacing: 16) {
                    Text(playlistName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Genre Composition")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ForEach(genreBlend, id: \.0) { genre, percentage in
                        if percentage > 5 {
                            HStack {
                                Text(genre)
                                Spacer()
                                Text("\(percentage)%")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(16)
                .padding(.horizontal)
                
                Button(action: createPlaylist) {
                    Label("Create Playlist", systemImage: "music.note.list")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.tint)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    func updatePlaylistName(from blend: [(trait: PersonalityTrait, weight: Double)]) {
        guard let dominant = blend.max(by: { $0.weight < $1.weight }),
              dominant.weight > 0.4 else {
            playlistName = "Eclectic Mix"
            return
        }
        
        playlistName = "\(dominant.trait.name) Fusion"
    }
    
    func createPlaylist() {
        // Create playlist based on genre blend
        print("Creating playlist with blend:", genreBlend)
    }
}
```

### Mood Tracker

```swift
import SwiftUI
import PersonalityMixer

struct MoodTrackerView: View {
    @State private var currentMood: Mood = Mood()
    @AppStorage("moodHistory") private var moodHistoryData: Data = Data()
    
    let moodTraits = [
        PersonalityTrait(name: "Happy", color: .yellow, icon: "sun.max.fill", position: .top),
        PersonalityTrait(name: "Calm", color: .blue, icon: "cloud", position: .right),
        PersonalityTrait(name: "Energetic", color: .orange, icon: "bolt.fill", position: .bottom),
        PersonalityTrait(name: "Focused", color: .purple, icon: "target", position: .left)
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("How are you feeling?")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            PersonalityMixerView(traits: moodTraits) { blend in
                currentMood.update(from: blend)
            }
            
            // Mood insights
            VStack(alignment: .leading, spacing: 12) {
                Label(currentMood.summary, systemImage: currentMood.icon)
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text(currentMood.suggestion)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial)
            .cornerRadius(12)
            .padding(.horizontal)
            
            Button("Save Mood") {
                saveMood()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    func saveMood() {
        // Save mood to history
        print("Saving mood:", currentMood)
    }
}

struct Mood {
    var happy: Double = 0.25
    var calm: Double = 0.25
    var energetic: Double = 0.25
    var focused: Double = 0.25
    
    var summary: String {
        if happy > 0.4 { return "Feeling Great!" }
        if calm > 0.4 { return "Nice and Relaxed" }
        if energetic > 0.4 { return "Full of Energy" }
        if focused > 0.4 { return "In the Zone" }
        return "Balanced"
    }
    
    var icon: String {
        if happy > 0.4 { return "face.smiling" }
        if calm > 0.4 { return "leaf" }
        if energetic > 0.4 { return "flame" }
        if focused > 0.4 { return "eye" }
        return "circle.grid.2x2"
    }
    
    var suggestion: String {
        if happy > 0.4 { return "Great time to tackle creative projects!" }
        if calm > 0.4 { return "Perfect for meditation or reading." }
        if energetic > 0.4 { return "How about some exercise?" }
        if focused > 0.4 { return "Ideal for deep work sessions." }
        return "A good time for anything you choose."
    }
    
    mutating func update(from blend: [(trait: PersonalityTrait, weight: Double)]) {
        happy = blend.first { $0.trait.name == "Happy" }?.weight ?? 0
        calm = blend.first { $0.trait.name == "Calm" }?.weight ?? 0
        energetic = blend.first { $0.trait.name == "Energetic" }?.weight ?? 0
        focused = blend.first { $0.trait.name == "Focused" }?.weight ?? 0
    }
}
```

## Advanced Customization

### Custom Visual Style

```swift
// Create a modifier to customize the appearance
struct DarkModePersonalityMixer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(.dark)
            .tint(.indigo)
    }
}

// Usage
PersonalityMixerView()
    .modifier(DarkModePersonalityMixer())
```

### Saving and Loading States

```swift
struct PersistentMixerView: View {
    @AppStorage("savedMixerPosition") private var savedPosition: String = "0,0"
    
    var savedCGPoint: CGPoint {
        let components = savedPosition.split(separator: ",").compactMap { Double($0) }
        guard components.count == 2 else { return .zero }
        return CGPoint(x: components[0], y: components[1])
    }
    
    var body: some View {
        PersonalityMixerView { blend in
            // Save position when it changes
            if let first = blend.first {
                // Calculate position from blend
                // This is a simplified example
                savedPosition = "0,0"
            }
        }
    }
}
```

## Tips

1. **Performance**: The component is optimized for smooth 120Hz ProMotion displays
2. **Accessibility**: Consider adding VoiceOver support for the mixer position
3. **Haptics**: Add haptic feedback when the selector crosses trait boundaries
4. **Animations**: All animations use spring physics for natural feeling