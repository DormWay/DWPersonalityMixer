//
//  ContentView.swift
//  DWQuadPreference
//
//  Created by Ethan Kaplan on 7/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentBlend: [(trait: PersonalityTrait, weight: Double)] = []
    
    var body: some View {
        ZStack {
            // Mesh gradient background
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                    .init(0, 1), .init(0.5, 1), .init(1, 1)
                ],
                colors: [
                    .purple.opacity(0.15), .pink.opacity(0.2), .blue.opacity(0.15),
                    .pink.opacity(0.1), .white, .green.opacity(0.1),
                    .blue.opacity(0.15), .green.opacity(0.2), .purple.opacity(0.15)
                ]
            )
            .ignoresSafeArea()
            .blur(radius: 40)
            
            VStack(spacing: 30) {
                Text("AI Personality Mixer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.primary, .primary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Using the encapsulated component
                PersonalityMixerView { blend in
                    currentBlend = blend
                    
                    // Example: Print the current personality blend
                    print("Personality Blend Updated:")
                    for item in blend {
                        print("  \(item.trait.name): \(Int(item.weight * 100))%")
                    }
                }
                
//                // Optional: Display current blend values
//                if !currentBlend.isEmpty {
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Current Blend")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        
//                        ForEach(currentBlend, id: \.trait.name) { item in
//                            HStack {
//                                Image(systemName: item.trait.icon)
//                                    .foregroundColor(item.trait.color)
//                                    .frame(width: 20)
//                                Text("\(item.trait.name):")
//                                    .font(.caption)
//                                Text("\(Int(item.weight * 100))%")
//                                    .font(.caption.bold())
//                                    .foregroundColor(item.trait.color)
//                            }
//                        }
//                    }
//                    .padding()
//                    .background(.ultraThinMaterial)
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
