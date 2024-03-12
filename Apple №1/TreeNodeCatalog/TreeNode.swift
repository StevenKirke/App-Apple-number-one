//
//  TreeNode.swift
//  Apple №1
//
//  Created by Steven Kirke on 28.01.2024.
//

import Foundation

public class TreeNode<T> {
	public var value: T

	public private(set) weak var parent: TreeNode?
	public private(set) var children = [TreeNode<T>]()

	public init(value: T) {
		self.value = value
	}

	public func addChild(_ node: TreeNode<T>) {
		children.append(node)
		node.parent = self
	}

	public func addChilds(_ nodes: [TreeNode<T>]) {
		children.append(contentsOf: nodes)
	}
}

extension TreeNode where T: Equatable {

	static func == (leftHs: TreeNode, rightHs: TreeNode) -> Bool {
		return leftHs.value == rightHs.value
	}

	public func search(_ value: T) -> TreeNode? {
		if value == self.value {
			return self
		}
		for child in children {
			if let found = child.search(value) {
				return found
			}
		}
		return nil
	}

	public func delete(value: T) -> TreeNode<T>? {
		guard let foundedNode = search(value) else { return nil }
		if let parent = foundedNode.parent {
			var index = 0
			parent.children.forEach { child in
				if child == foundedNode { index += 1}
			}
			parent.children.remove(at: index)
		}
		foundedNode.parent = nil
		return foundedNode
	}

	public func delete(_ treeNode: TreeNode<T>) {
		guard let root = treeNode.parent else { return }

		root.children.removeAll(where: { $0 == treeNode })
	}
}

extension TreeNode: CustomStringConvertible {
	public var description: String {
		var currentValue = "\(self.value)"
		if !children.isEmpty {
			currentValue += " [\n" + children.map { $0.description }.joined(separator: " \n") + "\n]"
		}
		return "currentValue"
	}

	public var showTree: String {
		var text = "|---Root:\n"
		let space = "   "
		if !children.isEmpty {
			_ = children.map { parent in
				text += "|\(space)|---\(parent.value)\n"
				if !parent.children.isEmpty {
					_ = parent.children.map { child in
						text += "|\(space)|\(space)|---\(child.value)\n"
					}
				}
			}
		}
		return text
	}
}
