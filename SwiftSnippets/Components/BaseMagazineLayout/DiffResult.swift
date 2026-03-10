//
//  DiffResult.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/1/23.
//

import Foundation

struct DiffResult {
    let insertedSections: IndexSet
    let deletedSections: IndexSet
    let reloadedSections: IndexSet
    let itemReloads: [IndexPath]
    
    // 前后更新是否存在结构变化
    var hasStructuralChanges: Bool {
        !insertedSections.isEmpty || !deletedSections.isEmpty
    }
}

// MARK: - Diff 算法，基于 MagazineLayoutSection 模型。
func diffSections(old: [MagazineLayoutSection], new: [MagazineLayoutSection]) -> DiffResult {
    let oldIDs = old.map(\.identifier)
    let newIDs = new.map(\.identifier)

    let deleted = IndexSet(oldIDs.enumerated().filter { !newIDs.contains($0.element) }.map(\.offset))
    let inserted = IndexSet(newIDs.enumerated().filter { !oldIDs.contains($0.element) }.map(\.offset))

    var reloaded = IndexSet()
    var itemReloads: [IndexPath] = []

    for (newIndex, newSection) in new.enumerated() {
        guard let oldIndex = oldIDs.firstIndex(of: newSection.identifier),
              !deleted.contains(oldIndex),
              !inserted.contains(newIndex)
        else { continue }

        let oldSection = old[oldIndex]

        // 对比 header/footer/background 的 diffHash
        let headerChanged = oldSection.header.item?.diffHash != newSection.header.item?.diffHash
        let footerChanged = oldSection.footer.item?.diffHash != newSection.footer.item?.diffHash
        let bgChanged = oldSection.background.item?.diffHash != newSection.background.item?.diffHash

        // 对比 items
        let oldHashes = oldSection.items.map(\.diffHash)
        let newHashes = newSection.items.map(\.diffHash)

        if headerChanged || footerChanged || bgChanged || oldHashes != newHashes {
            reloaded.insert(newIndex)
        } else {
            // 如果 Section 本身没变，检查 item 局部变化
            for (idx, item) in newSection.items.enumerated() {
                if idx < oldHashes.count, item.diffHash != oldHashes[idx] {
                    itemReloads.append(IndexPath(item: idx, section: newIndex))
                }
            }
        }
    }

    return DiffResult(
        insertedSections: inserted,
        deletedSections: deleted,
        reloadedSections: reloaded,
        itemReloads: itemReloads
    )
}

func debugDiffLog(_ diff: DiffResult) {
    printLog("🧮 Diff Result:")
    if !diff.insertedSections.isEmpty { print("Inserted sections:", diff.insertedSections) }
    if !diff.deletedSections.isEmpty { print("Deleted sections:", diff.deletedSections) }
    if !diff.reloadedSections.isEmpty { print("Reloaded sections:", diff.reloadedSections) }
    if !diff.itemReloads.isEmpty { print("Reloaded items:", diff.itemReloads) }
}
