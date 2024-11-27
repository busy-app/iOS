import SwiftUI

enum SelectedApp: String {
    case busy
    case pomodoro
    case wallpapersGifs
    case clockWeather
    case instargram
}

struct DeviceView: View {
    @StateObject private var device = Device()

    @State private var path = NavigationPath()

    @State private var showPoweredOff = false
    @State private var showNoUpdateFound = false

    @AppStorage("selectedApp") private var selectedApp: SelectedApp = .busy

    enum Destination {
        case settings
        case selectApp
    }

    var powerState: Device.PowerState { device.powerState }
    var bluetoothState: Device.BluetoothState { device.bluetoothState }
    var wifiState: Device.WiFiState { device.wifiState }
    var soundState: Device.SoundState { device.soundState }

    var appImage: String {
        switch selectedApp {
        case .busy: "BusyContent"
        case .pomodoro: "PomodoroContent"
        case .wallpapersGifs: "WallpapersGifsContent"
        case .clockWeather: "ClockWeatherContent"
        case .instargram: "InstagramContent"
        }
    }

    var bluetoothStateText: String {
        switch bluetoothState {
        case .connected: "CONNECTED"
        case .connecting: "CONNECTING"
        case .disconnected: "NOT CONNECTED"
        }
    }

    var wifiStateText: String {
        switch wifiState {
        case .connected: "CONNECTED"
        case .connecting: "CONNECTING"
        case .disconnected: "NOT CONNECTED"
        }
    }

    var muteStateText: String {
        switch soundState {
        case .on: "MUTE"
        case .off: "UNMUTE"
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        Image("DeviceBody")
                            .resizable()
                            .scaledToFit()
                        Image(appImage)
                            .resizable()
                            .scaledToFit()
                    }


                    FilledButton {
                        path.append(Destination.selectApp)
                    } label: {
                        HStack(spacing: 2) {
                            Text("CHANGE APP")
                            Image("Chevron")
                        }
                    }
                    .padding(.top, 18)
                    .disabled(!device.isConnected)

                    VStack(spacing: 8) {
                        GrayButton("TURN \(powerState == .on ? "OFF" : "ON")") {
                            Task {
                                switch powerState {
                                case .on: try await device.turnOff()
                                case .off: try await device.turnOn()
                                }
                            }
                        }
                        .alert(isPresented: $showPoweredOff) {
                            Alert(title: Text("Device is powered off"))
                        }

                        HStack(spacing: 8) {
                            GrayButton(muteStateText) {
                                Task {
                                    try await device.toggleMute()
                                }
                            }
                            
                            GrayButton("REBOOT") {
                                Task {
                                    try await device.reboot()
                                }
                            }
                            .disabled(!device.isConnected)
                            .onTapGesture {
                                if !device.isConnected {
                                    showPoweredOff = true
                                }
                            }

                            GrayButton {
                                path.append(Destination.settings)
                            } label: {
                                Image("Settings")
                            }
                        }

                    }
                    .padding(.top, 24)

                    HStack(spacing: 8) {
                        GrayButton {
                            guard powerState == .on else {
                                showPoweredOff = true
                                return
                            }
                            Task {
                                switch wifiState {
                                case .connected:
                                    try await device.disconnectWiFi()
                                case .connecting:
                                    try await device.disconnectWiFi()
                                case .disconnected:
                                    try await device.connectWiFi()
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(
                                    wifiState == .connected
                                    ? "WiFi"
                                    : "WiFiOff"
                                )
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("WIFI")
                                        .font(.ppNeueMontrealRegular(size: 10))
                                        .foregroundStyle(.blackInvert)

                                    Text(wifiStateText)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.01)
                                        .font(.ppNeueMontrealRegular(size: 14))
                                        .foregroundStyle(
                                            wifiState == .connected
                                            ? .wifiPrimary
                                            : .neutralTertiary
                                        )
                                }
                                Image("ChevronRegular")
                            }
                            .frame(height: 66)
                        }

                        GrayButton {
                            guard powerState == .on else {
                                showPoweredOff = true
                                return
                            }
                            Task {
                                switch bluetoothState {
                                case .connected:
                                    try await device.disconnectBluetooth()
                                case .connecting:
                                    try await device.disconnectBluetooth()
                                case .disconnected:
                                    try await device.connectBluetooth()
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(
                                    device.bluetoothState == .connected
                                    ? "Bluetooth"
                                    : "BluetoothOff"
                                )
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("BLUETOOTH")
                                        .font(.ppNeueMontrealRegular(size: 10))
                                        .foregroundStyle(.blackInvert)

                                    Text(bluetoothStateText)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.01)
                                        .font(.ppNeueMontrealRegular(size: 14))
                                        .foregroundStyle(
                                            bluetoothState == .connected
                                            ? .bluetoothPrimary
                                            : .neutralTertiary
                                        )
                                }
                                Image("ChevronRegular")
                            }
                            .frame(height: 66)
                        }
                    }
                    .padding(.top, 40)

                    VStack(spacing: 12) {
                        HStack {
                            Text("ABOUT DEVICE")
                                .font(.ppNeueMontrealRegular(size: 12))
                                .foregroundStyle(.neutralTertiary)
                            Spacer()
                        }

                        StrokedButton {
                            showNoUpdateFound = true
                        } label: {
                            HStack(spacing: 4) {
                                Text("UPDATE FIRMWARE")
                                Image("Chevron")
                                    .renderingMode(.template)
                            }
                            .foregroundColor(.brandPrimary)
                        }
                        .alert(isPresented: $showNoUpdateFound) {
                            Alert(title: Text("No Update Found"))
                        }

                        DeviceInfo(deviceInfo: device.deviceInfo)
                            .padding(.vertical, 24)
                    }
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 26)
                .padding(.horizontal, 14)
            }
            .background(.whiteInvert)
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .settings: SettingsView()
                case .selectApp: AppsView()
                }
            }
            .navigationTitle("")
        }
    }

    struct DeviceInfo: View {
        let deviceInfo: Device.DeviceInfo?

        var body: some View {
            VStack(spacing: 24) {
                Line(
                    name: "Firmware version",
                    value: deviceInfo?.firmwareVersion ?? "-"
                )
                Divider()
                    .background(.neutralQuinary)
                Line(
                    name: "Dev mode",
                    value: deviceInfo?.devMode ?? "-"
                )
                Divider()
                    .background(.neutralQuinary)
                Line(
                    name: "Serial Number",
                    value: deviceInfo?.serialNumber ?? "-"
                )
            }
        }

        struct Line: View {
            let name: String
            let value: String

            var body: some View {
                HStack {
                    Text(name)
                        .foregroundStyle(.blackInvert)
                    Spacer()
                    Text(value)
                        .foregroundStyle(.neutralSecondary)
                }
                .font(.jetBrainsMonoRegular(size: 16))
            }
        }
    }
}

#Preview {
    MainView(initialTab: .device)
}
