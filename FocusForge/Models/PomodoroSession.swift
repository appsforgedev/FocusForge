//
//  PomodoroSession.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//



enum PomodoroSession: String, CaseIterable, Identifiable {
    
    case focus
    case shortBreak
    case longBreak
    
    var id: String { rawValue }

    var title: String {
        switch self {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }
    
    var sybmol: String {
        self.rawValue.first?.lowercased() ?? "?"
    }
}

extension PomodoroSession {
    
    func iconForSession(progress: Double) -> String {
        switch self {
           case .focus:
               switch progress {
               case 0.84...1.0:
                   return "flame.fill"
               case 0.64..<0.84:
                   return "flame"
               case 0.44..<0.64:
                   return "drop.triangle"
               case 0.24..<0.44:
                   return "drop"
               default:
                   return "circle"
               }

           case .shortBreak:
               switch progress {
               case 0.8...1.0:
                   return "flame.circle.fill"
               case 0.6..<0.8:
                   return "flame.circle"
               case 0.4..<0.6:
                   return "drop.circle.fill"
               case 0.2..<0.4:
                   return "drop.circle"
               default:
                   return "circle"
               }

           case .longBreak:
               switch progress {
               case 0.74...1.0:
                   return "moon.zzz.fill"
               case 0.39..<0.74:
                   return "moon.zzz.fill"
               case 0.05..<0.39:
                   return "moon.zzz.fill"
               default:
                   return "moon.zzz.fill"
               }
           }
    }
}
