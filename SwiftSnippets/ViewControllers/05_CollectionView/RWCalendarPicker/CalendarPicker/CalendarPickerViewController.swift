//
//  CalendarPickerViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/22.
//

import UIKit

/// 自定义日历控件
final class CalendarPickerViewController: UIViewController {
    // MARK: Views

    private lazy var dimmedBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private lazy var headerView = CalendarPickerHeaderView { [weak self] in
        guard let strongSelf = self else {
            return
        }

        strongSelf.dismiss(animated: true)
    }

    private lazy var footerView = CalendarPickerFooterView { [weak self] in
        guard let strongSelf = self else {
            return
        }

        // 点击上个月按钮，刷新集合视图
        strongSelf.baseDate = strongSelf.calendar.date(byAdding: .month, value: -1, to: strongSelf.baseDate) ?? strongSelf.baseDate
    } didTapNextMonthCompletionHandler: { [weak self] in
        guard let strongSelf = self else {
            return
        }

        // 点击下个月按钮，刷新集合视图
        strongSelf.baseDate = strongSelf.calendar.date(byAdding: .month, value: 1, to: strongSelf.baseDate) ?? strongSelf.baseDate
    }

    // MARK: - Calendar Data Values

    private let selectedDate: Date
    private let selectedDateChanged: ((Date) -> Void)

    // 保存任务的到期日期
    private var baseDate: Date {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            collectionView.reloadData()
            headerView.baseDate = baseDate
        }
    }

    private lazy var days = generateDaysInMonth(for: baseDate)

    // 当前显示月份的周数
    private var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }

    // .gregorian 代表公历日历
    // Tips: 唯一不使用公历的国家是埃塞俄比亚、尼泊尔、伊朗和阿富汗。
    private let calendar = Calendar(identifier: .gregorian)

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // 1~31日 (不带 0)
        return dateFormatter
    }()

    // MARK: - Initializers

    init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
        self.selectedDate = baseDate
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChanged

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        definesPresentationContext = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(dimmedBackgroundView)
        view.addSubview(collectionView)
        view.addSubview(headerView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            collectionView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 85),

            footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60)
        ])

        collectionView.register(CalendarDateCollectionViewCell.self, forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        headerView.baseDate = baseDate
    }

    // 当设备旋转或者进入 iPad 上的 Split 视图时，重新计算布局
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}

// MARK: - Day Generation

private extension CalendarPickerViewController {
    enum CalendarDataError: Error {
        case metadataGeneration
    }

    // 根据给定日期生成相应月份中的日期所需的元数据
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
                let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate)) else {
            throw CalendarDataError.metadataGeneration
        }

        // 该月的第一天是星期几
        let firstDayWeekend = calendar.component(.weekday, from: firstDayOfMonth)

        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekend
        )
    }

    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = try? monthMetadata(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        // 如果一个月不是从星期日开始的，则在开头添加上个月的最后几天
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            // 检查循环中的当前日期是在当前月份内还是上个月的一部分内
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        // 补全日历的最后一周，添加下一个月的前几天
        days += generateStartOfNextMonth(using: firstDayOfMonth)

        return days
    }

    // 从日期中添加或减去偏移量以生成新的日期
    func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate

        return Day(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }

    // 如果一个月的最后一天不是星期六，则必须在日历末尾添加额外的天数
    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth) else {
            return []
        }

        // 计算日历中最后一行需要补全的天数
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }

        let days: [Day] = (1...additionalDays).map {
            generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
        }

        return days
    }
}

// MARK: - UICollectionViewDataSource

extension CalendarPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier, for: indexPath) as? CalendarDateCollectionViewCell else {
            fatalError("Unable to dequeue CalendarDateCollectionViewCell")
        }
        cell.day = days[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = days[indexPath.row]
        selectedDateChanged(day.date)
        dismiss(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
        return CGSize(width: width, height: height)
    }
}
