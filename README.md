# PersonalityMixer

A beautiful, intuitive SwiftUI component for mixing personality traits or any quaternary attributes. Perfect for AI personality configuration, color mixing, or any interface requiring smooth blending between four cardinal options.

![PersonalityMixer Demo](screen.gif)

## Features

- 🎨 **Liquid Glass Design** - Beautiful iOS 26-style glass morphism with liquid color blending
- 🎯 **Intuitive Interaction** - Drag to mix traits with smooth, natural transitions
- 📊 **Visual Feedback** - Real-time pie chart showing exact blend percentages
- 🎭 **Fully Customizable** - Use any traits, colors, and icons
- 📱 **SwiftUI Native** - Built entirely with SwiftUI and Swift Charts
- ✨ **Smooth Animations** - Spring animations and gesture feedback

## Requirements

- iOS 26.0+ (for MeshGradient and advanced glass effects)
- Xcode 26.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/dormway/PersonalityMixer.git", from: "1.0.0")
]
```

Or in Xcode: File → Add Package Dependencies → Enter the repository URL

## Usage

### Basic Usage

```swift
import SwiftUI
import PersonalityMixer

struct ContentView: View {
    var body: some View {
        PersonalityMixerView { blend in
            // Handle blend changes
            for item in blend {
                print("\(item.trait.name): \(Int(item.weight * 100))%")
            }
        }
    }
}
```

### Custom Traits

```swift
let customTraits = [
    PersonalityTrait(name: "Fire", color: .red, icon: "flame", position: .top),
    PersonalityTrait(name: "Water", color: .blue, icon: "drop", position: .right),
    PersonalityTrait(name: "Earth", color: .brown, icon: "leaf", position: .bottom),
    PersonalityTrait(name: "Air", color: .cyan, icon: "wind", position: .left)
]

PersonalityMixerView(traits: customTraits) { blend in
    // Handle blend changes
}
```

### Advanced Usage with State Management

```swift
struct AIConfigView: View {
    @State private var personalityBlend: [(trait: PersonalityTrait, weight: Double)] = []
    
    var dominantTrait: PersonalityTrait? {
        personalityBlend.max(by: { $0.weight < $1.weight })?.trait
    }
    
    var body: some View {
        VStack {
            Text("Configure AI Personality")
                .font(.largeTitle)
            
            PersonalityMixerView { blend in
                personalityBlend = blend
                // Save to your AI configuration
                savePersonalitySettings(blend)
            }
            
            if let dominant = dominantTrait {
                Text("Dominant trait: \(dominant.name)")
                    .foregroundColor(dominant.color)
            }
        }
    }
}
```

## Components

### PersonalityMixerView
The main component that includes the mixer, detail view, and all interactions.

```swift
PersonalityMixerView(
    traits: [PersonalityTrait],  // Optional, defaults to Creative/Analytical/Empathetic/Practical
    onBlendChange: (([(trait: PersonalityTrait, weight: Double)]) -> Void)?
)
```

### PersonalityTrait
The data model for traits:

```swift
PersonalityTrait(
    name: String,
    color: Color,
    icon: String,        // SF Symbol name
    position: Position   // .top, .right, .bottom, or .left
)
```

## Features in Detail

### Mixer Control
- Drag the white selector anywhere within the circle
- Center position = 25% of each trait (balanced)
- Edge positions = Strong emphasis on nearby traits
- Smooth color blending based on position

### Detail View
- Tap the button or swipe up to reveal the pie chart
- Shows exact percentages for each trait
- Displays the dominant trait icon in the center
- Swipe up on the chart to dismiss

### Visual Effects
- Glass morphism with iOS 26's `.ultraThinMaterial`
- Liquid-like color transitions
- Refractive glass distortions
- Dynamic shadows that respond to the blend

## Customization

### Colors and Icons
Customize the appearance by providing your own traits:

```swift
let traits = [
    PersonalityTrait(name: "Happy", color: .yellow, icon: "face.smiling", position: .top),
    PersonalityTrait(name: "Calm", color: .blue, icon: "leaf", position: .right),
    PersonalityTrait(name: "Energetic", color: .orange, icon: "bolt", position: .bottom),
    PersonalityTrait(name: "Focused", color: .purple, icon: "target", position: .left)
]
```

### Styling
The component automatically adapts to light/dark mode and uses system materials for a native feel.

## Example Use Cases

- **AI Personality Configuration** - Let users define AI assistant personalities
- **Game Character Creation** - Mix attributes for RPG characters
- **Color Mixing** - Educational tool for color theory
- **Mood Selection** - Psychology or wellness apps
- **Music Genre Blending** - Mix musical styles
- **Preference Settings** - Any quaternary preference system

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with SwiftUI and Swift Charts
- Inspired by color theory and mixing interfaces (like in DaVinci Resolve, etc)
- Thanks to the iOS developer community

## Author

Created by DormWay LLC

## Support

If you find this helpful, please star ⭐ the repository!