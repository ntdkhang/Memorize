//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Nguyen Tran Duy Khang on 5/29/21.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var store: MemoryThemeStore
    @State var editMode: EditMode = .inactive
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes, id: \.name) { theme in
                    NavigationLink(
                        destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme)),
                        label: {
                            ThemeSummary(theme: theme, isEditting: editMode.isEditing)
                                .environmentObject(store)
                        }
                        )
                }
                .onDelete { indexSet in
                    indexSet.map { store.themes[$0] }.forEach{ theme in
                        self.store.removeTheme(theme)
                    }
                }
                
            }
            .navigationBarTitle(store.name)
            .navigationBarItems(
                leading: Button(action: {
                    store.addTheme()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)//.foregroundColor(.blue)
                }),
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
    }
}

struct ThemeSummary: View {
    var theme: Theme
    var isEditting: Bool
    //@EnvironmentObject var store: MemoryThemeStore
    @State private var showEditor: Bool = false
    var body: some View {
        HStack {
            if isEditting {
                Image(systemName: "pencil.circle.fill").imageScale(.medium)
                    .onTapGesture { showEditor = true }
                    .foregroundColor(Color(theme.color))
                    .padding()
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                    Text(theme.name).font(.system(size: fontSize))
                    Text(theme.emojis)
                }
            } else {
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                    Text(theme.name).font(.system(size: fontSize))
                    Text(theme.emojis)
                }
            }
        }
        .sheet(isPresented: $showEditor, content: { ThemeEditor(theme: theme, showEditor: $showEditor) })
    }
    
    private var fontSize: CGFloat {
        return CGFloat(20)
    }
}

struct ThemeEditor: View {
    var theme: Theme
    @EnvironmentObject var store: MemoryThemeStore
    @Binding var showEditor: Bool
    @State private var name: String = ""
    @State private var emojisToAdd: String = ""
    @State private var numOfPairs: Int
    var body: some View {
        VStack {
            ZStack {
                Text("Theme Editor").font(.title)
                HStack {
                    Spacer()
                    Button("Done") {
                        showEditor = false
                    }
                }
            }
            Divider()
            Form {
                Section(header: Text("Name").font(.body)) {
                    TextField(theme.name, text: $name, onEditingChanged: { began in
                        if !began {
                            store.changeName(name, fromTheme: theme)
                        }
                    })
                }
                
                Section(header: Text("Add Emojis").font(.body)) {
                    TextField("Emojis", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            store.addEmojis(emojisToAdd, fromTheme: theme)
                        }
                    })
                }
                
                Section(header:HStack {
                    Text("Remove Emoji").font(.body)
                    Spacer()
                    Text("Tap emoji to remove").font(.footnote)
                }) {
                    Grid(theme.emojis.map { String($0) }, id: \.self) { emoji in
                        Text(emoji).font(.system(size:fontSize))
                            .onTapGesture { store.removeEmoji(emoji, fromTheme: theme) }
                    }
                    .frame(height: height)
                }
                
                Section(header: Text("Card Count").font(.body)) {
//                    Stepper(onIncrement: { store.changeNumOfPairs(theme.numOfPairs + 1, fromTheme: theme) },
//                            onDecrement: { store.changeNumOfPairs(theme.numOfPairs - 1, fromTheme: theme) },
//                            label: {EmptyView()})
//                    Stepper()
                    Stepper("\(numOfPairs) pairs",
                            value: $numOfPairs,
                            in: 2...theme.emojis.count,
                            step: 1,
                            onEditingChanged: { began in
                                if !began {
                                    store.changeNumOfPairs(numOfPairs, fromTheme: theme)
                                }
                            })
                    
                }
                
                Section(header: Text("Choose Color").font(.body)) {
                    Grid(ThemeTemplate().colors, id: \.self) { color in
                        ZStack {
                            if theme.color == color {
                                Circle().font(.system(size: colorShapeSize)).foregroundColor(Color(color)).padding(5)
                                Image(systemName: "checkmark").font(.system(size: colorShapeSize))
                            } else {
                            Circle().font(.system(size: colorShapeSize)).foregroundColor(Color(color)).padding(5)
                            }
                        }
                        .onTapGesture {
                            store.choseColor(color, fromTheme: theme)
                        }
                    }
                    .frame(height: height)
                }
            }
        }
    }
    
    init(theme: Theme, showEditor: Binding<Bool>) {
        self.theme = theme
        self._showEditor = showEditor
        self.numOfPairs = theme.numOfPairs
    }
    private var height: CGFloat {
        CGFloat(theme.emojis.count / 4) * 70
    }
    
    private let fontSize: CGFloat = 40
    
    private let colorShapeSize: CGFloat = 20
    
}
