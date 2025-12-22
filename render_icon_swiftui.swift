import SwiftUI
import AppKit

@main
@MainActor
struct IconRenderer {
    static func main() {
        if #available(macOS 13.0, *) {
            // Exact replica of the Main Interface Icon
            let content = Image(systemName: "message.badge.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.blue.gradient)
                .frame(width: 1024, height: 1024)
                .background(Color.clear)

            let renderer = ImageRenderer(content: content)
            renderer.scale = 1.0 
            renderer.isOpaque = false
            
            if let nsImage = renderer.nsImage {
                let path = "/Volumes/SSD/Projects/MacMessageBackupApp/MacMessageBackup/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png"
                let url = URL(fileURLWithPath: path)
                
                if let tiff = nsImage.tiffRepresentation,
                   let bitmap = NSBitmapImageRep(data: tiff),
                   let pngData = bitmap.representation(using: .png, properties: [:]) {
                    do {
                        try pngData.write(to: url)
                        print("✅ Successfully rendered SwiftUI icon to \(path)")
                    } catch {
                        print("Error saving file: \(error)")
                        exit(1)
                    }
                } else {
                    print("Error converting to PNG")
                    exit(1)
                }
            } else {
                print("Error: Failed to render NSImage.")
                exit(1)
            }
        } else {
            print("Error: macOS 13.0+ required")
            exit(1)
        }
    }
}
