//
//  HRMViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/18.
//

import UIKit
import CoreBluetooth

/**
 iOS 蓝牙教程：心率传感器

 ### 参考
 * <https://www.notion.so/andy0570/iOS-15d973ced06c80009e56de65b8b22a18?pvs=4>
 */
class HRMViewController: UIViewController {
    @IBOutlet private weak var heartRateLabel: UILabel!
    @IBOutlet private weak var bodySensorLocationLabel: UILabel!

    // 心率服务的 UUID
    let heartRateServicesCBUUID = CBUUID(string: "0x180D")
    // 心率服务特征：心率测量
    let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "0x2A37")
    // 心率服务特征：身体传感器位置
    let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "0x2A38")

    var centralManager: CBCentralManager!
    var heartRatePeripheral: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "心率传感器"

        // 初始化中心设备
        centralManager = CBCentralManager(delegate: self, queue: nil)

        // Make the digits monospaces to avoid shifting when the numbers change
        // swiftlint:disable:next force_unwrapping
        heartRateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: heartRateLabel.font!.pointSize, weight: .regular)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 断开蓝牙连接
        centralManager.cancelPeripheralConnection(heartRatePeripheral)
    }

    private func onHeartRateReceived(_ heartRate: Int) {
        heartRateLabel.text = String(heartRate)
        print("BPM: \(heartRate)")
    }
}

extension HRMViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            // 当蓝牙打开时，扫描特定服务的外围设备
            centralManager.scanForPeripherals(withServices: [heartRateServicesCBUUID])
        @unknown default:
            print("central.state is unknown")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        heartRatePeripheral = peripheral // 存储对扫描到的外围设备的引用
        centralManager.stopScan() // 停止服务
        centralManager.connect(heartRatePeripheral) // 连接外围设备
        heartRatePeripheral.delegate = self
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("外围设备连接成功")
        heartRatePeripheral.discoverServices([heartRateServicesCBUUID]) // 发现服务
    }
}

extension HRMViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard let services = peripheral.services else {
            return
        }

        for service in services {
            print(service)
            // 显式请求发现服务的特征
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristics = service.characteristics else {
            return
        }

        for characteristic in characteristics {
            print(characteristic)
            // 检查特征属性
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                // 读取特征值，获取身体传感器的位置
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                // 订阅特征值，获取心率测量结果
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        switch characteristic.uuid {
        case bodySensorLocationCharacteristicCBUUID:
            let bodySensorLocation = bodyLocation(form: characteristic)
            bodySensorLocationLabel.text = bodySensorLocation
        case heartRateMeasurementCharacteristicCBUUID:
            let bpm = heartRate(form: characteristic)
            onHeartRateReceived(bpm)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }

    // 解析蓝牙设备返回的身体传感器数据
    private func bodyLocation(form characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value, let byte = characteristicData.first else {
            return "Error"
        }

        switch byte {
        case 0: return "Other"
        case 1: return "Chest"
        case 2: return "Wrist"
        case 3: return "Finger"
        case 4: return "Hand"
        case 5: return "Ear Lobe"
        case 6: return "Foot"
        default: return "Reserved for future use"
        }
    }

    // 从特征数据中获取心率值
    private func heartRate(form characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else {
            return -1
        }
        let byteArray = [UInt8](characteristicData)

        // 第一个字节的第一位指示心率测量值的格式，0 表示 UInt8，1 表示 UInt16。
        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            // Heart Rate Value Format is in the 2nd byte
            return Int(byteArray[1])
        } else {
            // Heart Rate Value Format is in the 2nd and 3rd bytes
            // 第二个字节向左移动 8 位，相当于乘以 256，心率值：(第二个字节值 * 256) + 第三个字节值。
            return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
    }
}
