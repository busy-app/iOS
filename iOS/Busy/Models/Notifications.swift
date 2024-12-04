import NotificationCenter

struct Notifications {
    static let shared = Notifications()

    func authorize() {
        Task {
            try await UNUserNotificationCenter
                .current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        }
    }

    func notify() {
        Task {
            do {
                let notificationCenter = UNUserNotificationCenter.current()
                let settings = await notificationCenter.notificationSettings()
                guard settings.authorizationStatus == .authorized else {
                    return
                }

                let content = UNMutableNotificationContent()
                content.title = "Time is out"
                content.body = "Take a break!"
                content.sound = .default

                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(
                    identifier: uuidString,
                    content: content,
                    trigger: UNTimeIntervalNotificationTrigger(
                        timeInterval: 0.1,
                        repeats: false
                    )
                )

                try await notificationCenter.add(request)
            } catch {
                print("notify error: \(error)")
            }
        }
    }
}
