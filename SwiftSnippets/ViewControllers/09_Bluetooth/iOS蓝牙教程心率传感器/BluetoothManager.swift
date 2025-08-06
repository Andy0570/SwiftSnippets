//
//  BluetoothManager.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/31.
//

import CoreBluetooth

/**
 封装一个名为 BluetoothManager 的工具类，来处理蓝牙扫描功能，并在 10 秒后自动停止，同时支持重新发起扫描。
 
 使用示例：
 let bluetoothManager = BluetoothManager()
 
 // 扫描发现外围设备时的回调
 bluetoothManager.didDiscoverPeripheral = { peripheral, advertisementData, rssi in
     print("发现设备: \(peripheral.name ?? "未知设备"), advertisementData: \(advertisementData), RSSI: \(rssi)")
 }
 
 // 扫描停止的回调
 bluetoothManager.didStopScan = {
     print("扫描已停止")
 }

 // 开始扫描
 bluetoothManager.startScanning()
 
 // 主动停止扫描
 bluetoothManager.stopScanning(true)

 // 如果需要重新扫描
 bluetoothManager.restartScanning()
 */
class BluetoothManager: NSObject, CBCentralManagerDelegate {
    // MARK: - Properties
    private var centralManager: CBCentralManager!
    private var scanTimer: Timer?
    private var scanning: Bool = false

    // 蓝牙状态变化的回调
    var didUpdateBluetoothState: ((CBManagerState) -> Void)?
    // 扫描到蓝牙外围设备的回调
    var didDiscoverPeripheral: ((CBPeripheral, [String: Any], Int) -> Void)?
    // 蓝牙扫描停止后的回调
    var didStopScan: ((Bool) -> Void)?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // 开始扫描
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            printLog("蓝牙未打开")
            return
        }

        if scanning {
            printLog("扫描已经在进行中")
            return
        }

        scanning = true

        // 开始扫描所有设备
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        // centralManager.scanForPeripherals(withServices: nil)
        printLog("开始扫描蓝牙设备...")

        // 设置定时器，10 秒后自动停止扫描
        scanTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(stopScanning(_:)), userInfo: nil, repeats: false)
    }

    /// 停止扫描
    /// - Parameter isUserInitiated: 区分当前蓝牙扫描是用户主动停止的，还是由于计时器到期而被动停止的。
    @objc func stopScanning(_ isUserInitiated: Bool = false) {
        if scanning {
            centralManager.stopScan()
            scanning.toggle()
            printLog("停止扫描")
            scanTimer?.invalidate()
            didStopScan?(isUserInitiated)
        }
    }

    // 重新发起扫描
    func restartScanning() {
        stopScanning()
        startScanning()
    }

    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // 获取蓝牙状态变化的回调
        didUpdateBluetoothState?(central.state)

        switch central.state {
        case .poweredOn:
            print("蓝牙已开启")
        case .poweredOff:
            print("蓝牙已关闭")
        case .resetting:
            print("蓝牙正在重置")
        case .unauthorized:
            print("蓝牙权限未授权")
        case .unsupported:
            print("设备不支持蓝牙")
        case .unknown:
            print("蓝牙状态未知")
        @unknown default:
            print("遇到未知的蓝牙状态")
        }
    }

    // 发现设备时回调
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // 传递发现的设备
        didDiscoverPeripheral?(peripheral, advertisementData, RSSI.intValue)
    }
}
