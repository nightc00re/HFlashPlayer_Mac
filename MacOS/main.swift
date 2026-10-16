import Cocoa

let logPath = "/tmp/hflash.log"

func log(_ text: String) {
    let entry = "\(Date()): \(text)\n"
    if let data = entry.data(using: .utf8) {
        if let handle = FileHandle(forWritingAtPath: logPath) {
            handle.seekToEndOfFile()
            handle.write(data)
            handle.closeFile()
        } else {
            FileManager.default.createFile(atPath: logPath, contents: data, attributes: nil)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            let rawString = url.absoluteString
            log("Received URL: \(rawString)")

            guard rawString.hasPrefix("hflash://") else { continue }

            var b64 = String(rawString.dropFirst("hflash://".count))
            while b64.hasSuffix("/") {
                b64.removeLast()
            }

            guard let data = Data(base64Encoded: b64),
                  let swfURL = String(data: data, encoding: .utf8) else {
                log("Failed to base64 decode: \(b64)")
                continue
            }

            log("Decoded target SWF: \(swfURL)")
            launchRuffle(with: swfURL)
        }
    }

    func launchRuffle(with swfURL: String) {
        let bundlePath = Bundle.main.bundlePath
        let internalRuffle = "\(bundlePath)/Contents/MacOS/ruffle"

        log("Launching Ruffle via /usr/bin/open with SWF: \(swfURL)")

        // Launch Ruffle using the system opener to bind directly to the WindowServer GUI
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        task.arguments = ["-a", internalRuffle, "--args", swfURL]

        do {
            try task.run()
            task.waitUntilExit()
            log("Open command dispatched successfully")
        } catch {
            log("Failed to dispatch open: \(error)")
        }

        // Terminate HFlashPlayer so it doesn't linger in the Dock or duplicate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exit(0)
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()