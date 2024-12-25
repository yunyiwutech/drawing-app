//
//  DrawingPad.swift
//  DrawMailer
//
//  Created by Yunyi Wu on 15.12.2024..
//

import SwiftUI

struct DrawingPad: View {
    @Binding var currentDrawing: Drawing
    @Binding var drawings: [Drawing]
    @Binding var color: Color
    @Binding var lineWidth: CGFloat
    @Binding var backgroundColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                ForEach(drawings.indices, id: \.self) { index in
                    Path { path in
                        add(drawing: drawings[index], toPath: &path)
                    }
                    .stroke(drawings[index].color, lineWidth: drawings[index].lineWidth)
                }
                Path { path in
                    add(drawing: currentDrawing, toPath: &path)
                }
                .stroke(color, lineWidth: lineWidth)
            }
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged { value in
                        let currentPoint = value.location
                        if currentPoint.y >= 0 && currentPoint.y < geometry.size.height {
                            currentDrawing.points.append(currentPoint)
                        }
                    }
                    .onEnded { _ in
                        currentDrawing.color = color
                        currentDrawing.lineWidth = lineWidth
                        drawings.append(currentDrawing)
                        currentDrawing = Drawing()
                    }
            )
        }
    }
    
    private func add(drawing: Drawing, toPath path: inout Path) {
        let points = drawing.points
        guard points.count > 1 else { return }
        for i in 0..<points.count - 1 {
            path.move(to: points[i])
            path.addLine(to: points[i + 1])
        }
    }
}
