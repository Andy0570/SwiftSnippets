//
//  HomeViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/6.
//

import UIKit

class HomeViewController: UIViewController {
    private let sections = Section.sectionsFromBundle()
    private var arrayDataSource: ArrayDataSource! {
        didSet {
            tableView.dataSource = arrayDataSource
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.backgroundColor = .systemBackground
        tableView.register(cellWithClass: UITableViewCell.self)
        tableView.delegate = self
        return tableView
    }()

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        // 如果我们添加了 scrollviews，这个技巧可以防止导航栏折叠
        // view.addSubview(UIView(frame: .zero))

        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"

        // 加载数据源，设置代理
        arrayDataSource = ArrayDataSource(sections: sections, cellReuseIdentifier: String(describing: UITableViewCell.self))
        arrayDataSource.cellConfigureClosure = { tableViewCell, cell in
            tableViewCell.configureForCell(cell: cell)
        }
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let item = self.arrayDataSource?.getCellItem(at: indexPath),
            let controller = viewControllerFromString(viewControllerName: item.className) {
            controller.title = item.title
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

private extension NSObject {
    // <https://stackoverflow.com/questions/46806969/create-a-uiviewcontroller-class-instance-from-string-view-controller-string-nam>
    func viewControllerFromString(viewControllerName: String) -> UIViewController? {
        if viewControllerName == "BookListViewController" {
            return BookListViewController(books: [
                Book(
                    id: UUID(),
                    name: "iOS App Distribution & Best Practices",
                    edition: "1st Edition",
                    imageName: "pasi",
                    available: true
                ),
                Book(
                    id: UUID(),
                    name: "SwiftUI Apprentice",
                    edition: "1st Edition",
                    imageName: "swiftui",
                    available: false
                ),
                Book(
                    id: UUID(),
                    name: "Living by the Code",
                    edition: "2nd Edition",
                    imageName: "livingcode",
                    available: true
                ),
                Book(
                    id: UUID(),
                    name: "Git Apprentice",
                    edition: "1st Edition",
                    imageName: "git",
                    available: true
                ),
                Book(
                    id: UUID(),
                    name: "Expert Swift",
                    edition: "1st Edition",
                    imageName: "expertswift",
                    available: false
                )
            ])
        } else if viewControllerName == "PhotoStreamViewController" {
            return PhotoStreamViewController(collectionViewLayout: PinterestLayout())
        } else if viewControllerName == "CustomPresentingTableViewController" {
            return CustomPresentingTableViewController(style: .plain)
        } else if viewControllerName == "RTVideoViewController" {
            return RTVideoViewController(collectionViewLayout: UICollectionViewLayout())
        } else if viewControllerName == "RWAlbumsViewController" {
            guard let bundleURL = Bundle.main.url(forResource: "PhotoData", withExtension: "") else {
                fatalError("无法找到指定的资源文件夹: PhotoData")
            }
            let albumsVC = RWAlbumsViewController(withAlbumsFromDirectory: bundleURL)
            return albumsVC
        } else if viewControllerName == "BaseMagazineLayoutVC" {
            let header1 = HeaderHeadline2VM(title: "Introduction")
            let header2 = HeaderHeadline2VM(title: "Places to see")

            let sections: [MagazineLayoutSection] = [
                // Section 1
                MagazineLayoutSection(items: [
                    RowDestinationTitleVM(title: "Indonesia, Bali").configurator()
                ], sectionInset: UIEdgeInsets(top: 0, left: 32, bottom: 16, right: 16)),

                // Section 2
                MagazineLayoutSection(items: [
                    RowTextVM(text: "Some Text").configurator()
                ], header: .init(item: header1.configurator(),
                                 visibilityMode: .visible(heightMode: header1.heightMode, pinToVisibleBounds: false)),
                   sectionInset: UIEdgeInsets(top: 0, left: 32, bottom: 16, right: 16)),

                // Section 3
                MagazineLayoutSection(items: [
                    RowHorizontalCardsCollectionVM(items: [
                        CardPhotoThumbnailVM(url: "https://upload.wikimedia.org/wikipedia/commons/5/5e/Uluwatu%40bali.jpg"),
                        CardPhotoThumbnailVM(url: "https://p1.pxfuel.com/preview/458/393/320/bali-tour-packages-book-bali-honeymoon-packages-bali-holiday-packages-best-travel-agency-in-delhi.jpg"),
                        CardPhotoThumbnailVM(url: "https://cdn.pixabay.com/photo/2017/06/07/05/10/ubud-bali-2379365_960_720.jpg"),
                        CardPhotoThumbnailVM(url: "https://dimg04.c-ctrip.com/images/200t0x000000kx593CDF5_R_550_412_R5_Q70_D.jpg")
                    ],
                                                   itemWidth: 164,
                                                   itemHeight: 120,
                                                   itemsSpacing: 8).configurator()
                ], header: .init(item: header2.configurator(),
                                 visibilityMode: .visible(heightMode: header1.heightMode, pinToVisibleBounds: false)),
                   sectionInset: UIEdgeInsets(top: 16, left: 32, bottom: 32, right: 16),
                   itemsInset: UIEdgeInsets(top: 8, left: -32, bottom: 0, right: -16))
            ]

            let baseVC = BaseMagazineLayoutVC()
            baseVC.sections = sections
            return baseVC
        } else if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            // printLog("CFBundleName: \(appName)")
            if let viewControllerType = NSClassFromString("\(appName).\(viewControllerName)") as? UIViewController.Type {
                return viewControllerType.init()
            }
        }

        return nil
    }
}
