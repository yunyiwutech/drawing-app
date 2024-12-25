//
//  ContentView.swift
//  DrawMailer
//
//  Created by Yunyi Wu on 15.12.2024..
//


import SwiftUI

struct ContentView: View {
    @State private var currentDrawing: Drawing = Drawing()
    @State private var drawings: [Drawing] = []
    @State private var color: Color = .black
    @State private var lineWidth: CGFloat = 3.0
    @State private var backgroundColor: Color = .white
    @State private var uiImage: UIImage? = nil
    @State private var drawingRect: CGRect = .zero
    
    var body: some View {
        VStack {
            DrawingPad(currentDrawing: $currentDrawing,
                       drawings: $drawings,
                       color: $color,
                       lineWidth: $lineWidth,
                       backgroundColor: $backgroundColor)
                .background(RectGetter(rect: $drawingRect))
            DrawingControls(color: $color,
                            lineWidth: $lineWidth,
                            drawings: $drawings,
                            backgroundColor: $backgroundColor,
                            uiImage: $uiImage,
                            drawingRect: $drawingRect)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


#Preview {
    ContentView()
}

struct Drawing {
    var points: [CGPoint] = []
    var color: Color = .black
    var lineWidth: CGFloat = 3.0
}
