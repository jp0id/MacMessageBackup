import AppKit

let symbolParams = [
    ("message.badge.circle.fill", "app_icon_1024.png", 1024.0),
]

let saveDir = "/Volumes/SSD/Projects/MacMessageBackupApp/MacMessageBackup/Assets.xcassets/AppIcon.appiconset"

for (symbolName, filename, size) in symbolParams {
    let outputURL = URL(fileURLWithPath: saveDir).appendingPathComponent(filename)
    
    // Create image configuration for high res
    let config = NSImage.SymbolConfiguration(pointSize: size * 0.8, weight: .regular)
    
    if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil)?.withSymbolConfiguration(config) {
        
        // Create a hosting view context or offscreen representation
        let imgSize = CGSize(width: size, height: size)
        let newImage = NSImage(size: imgSize)
        
        newImage.lockFocus()
        
        // 1. Draw gradient background (Circle)
        // Since the symbol itself is a filled circle, directly Tinting it might be easier.
        // But for .blue.gradient, we want a gradient.
        // Let's draw the gradient clipped to the symbol mask.
        
        if let ctx = NSGraphicsContext.current?.cgContext {
            // Draw into the whole rect? No, we want the shape of the symbol.
            
            // Get the mask from the symbol
            // Draw the symbol in black to create a mask
            image.draw(in: NSRect(origin: .zero, size: imgSize))
            
            // This just draws black. We want to use SourceAtop or similar to fill it with blue gradient.
            // Actually, simpler: Set fill color to Blue?
            
            // Let's try: Lock focus, set generic RGB blue, draw.
            // But user wants "Gradient".
            
            // Strategy: 
            // 1. Create a gradient.
            // 2. Clip to the symbol path/mask.
            // 3. Draw gradient.
            
            // However, extracting path from NSImage symbol is hard.
            // Simpler: Use `.withTintColor(.systemBlue)` equivalent.
            // But AppKit doesn't have `foregroundStyle(.blue.gradient)` one-liner for exporting.
            
            // Just drawing it in System Blue is a good start.
            // image.isTemplate = true
            
            NSGraphicsContext.current?.compositingOperation = .sourceIn
            
            // SwiftUI .blue is roughly sRGB (0, 0.478, 1.0)
            // .gradient typically is a subtle top-to-bottom change.
            // Let's use a slightly lighter blue at top and standard blue at bottom.
            // Match SwiftUI .blue.gradient (Top to Bottom/Diagonal)
            // SwiftUI .blue in Light Mode is roughly #007AFF
            let baseColor = NSColor.systemBlue
            
            // Create a gradient that matches the standard system gradient look
            // Usually valid system gradients are subtle.
            // Let's use the base color and a slightly lighter version.
            let color1 = baseColor.withAlphaComponent(0.8).cgColor // Top/Light
            let color2 = baseColor.cgColor // Bottom/Deep
            
            let colors = [color1, color2] as CFArray
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0.0, 1.0])!
            
            // Diagonal gradient: Top-Center to Bottom-Center often matches standard .gradient
            ctx.drawLinearGradient(gradient, start: CGPoint(x: imgSize.width/2, y: imgSize.height), end: CGPoint(x: imgSize.width/2, y: 0), options: [])
        }
        
        newImage.unlockFocus()
        
        // Save
        if let tiff = newImage.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiff),
           let pngData = bitmap.representation(using: .png, properties: [:]) {
            try? pngData.write(to: outputURL)
            print("Generated \(outputURL.path)")
        }
    } else {
        print("Failed to load symbol \(symbolName)")
    }
}
