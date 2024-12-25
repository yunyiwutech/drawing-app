//
//  DrawingControls.swift
//  DrawMailer
//
//  Created by Yunyi Wu on 15.12.2024..
//

import SwiftUI

struct DrawingControls: View {
    @Binding var color: Color
    @Binding var lineWidth: CGFloat
    @Binding var drawings: [Drawing]
    @Binding var backgroundColor: Color
    @Binding var uiImage: UIImage?
    @Binding var drawingRect: CGRect
    
    @StateObject private var imageSaver = ImageSaver()
    @State private var showAlert = false
    @State private var colorPickerShown = false
    @State private var backgroundPickerShown = false
    
    var body: some View {
        HStack {
            Button(action: { colorPickerShown = true }) {
                Image(systemName: "pencil.tip")
                    .font(.title2)
            }
            
            Button(action: { if !drawings.isEmpty { drawings.removeLast() } }) {
                Image(systemName: "arrow.uturn.left")
                    .font(.title2)
            }
            
            Button(action: { drawings = [] }) {
                Image(systemName: "trash")
                    .font(.title2)
            }
            
            Button(action: { backgroundPickerShown = true }) {
                Image(systemName: "paintbrush.fill")
                    .font(.title2)
            }
            HStack {
                
                Slider(value: $lineWidth, in: 1...15, step: 1)
                    .padding()
            }

            Button(action: { saveDrawing() }) {
                Image(systemName: "square.and.arrow.down")
                    .font(.title2)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(imageSaver.saveSuccess == true ? "Success" : "Error"),
                    message: Text(imageSaver.saveSuccess == true ? "Image saved successfully!" : "Failed to save image."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            Button(action: { shareDrawing() }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
            }
        }
        .frame(height: 60)
        .sheet(isPresented: $colorPickerShown) {
            ColorPicker(color: $color, colorPickerShown: $colorPickerShown)
        }
        .sheet(isPresented: $backgroundPickerShown) {
            ColorPicker(color: $backgroundColor, colorPickerShown: $backgroundPickerShown)
        }
    }
    
    private func saveDrawing() {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let rootView = keyWindow?.rootViewController?.view {
            uiImage = rootView.asImage(rect: drawingRect)
            if let image = uiImage {
                imageSaver.writeToPhotoAlbum(image: image)
                showAlert = true
            }
        }
    }
    
    private func shareDrawing() {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let rootView = keyWindow?.rootViewController?.view {
            uiImage = rootView.asImage(rect: drawingRect)
            if let image = uiImage {
                let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                if let controller = keyWindow?.rootViewController {
                    controller.present(activityVC, animated: true, completion: nil)
                }
            }
        }
    }
}

extension Button {
    func buttonStyle() -> some View {
        self.padding(10)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
    }
}


extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}

