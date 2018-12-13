//
//  PrefixTree.swift
//  WrocNav
//
//  Created by Kacper Raczy on 13.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

class PrefixTree<T: Hashable> {
    class Node<T: Hashable> {
        var value: T?
        weak var parent: Node?
        var children: [T: Node] = [:]
        var isTerminating: Bool = false
        
        init(value: T?, parent: Node? = nil) {
            self.value = value
            self.parent = parent
        }
        
        func add(child: T) {
            guard children[child] == nil else {
                return
            }
            
            children[child] = Node(value: child, parent: self)
        }
    }
    
    class RootNode<T: Hashable>: Node<T> {
        init() {
            super.init(value: nil)
        }
    }
    
    private var root: RootNode<T> = RootNode()
    
    func insert(_ collection: [T]) {
        var current: Node<T>? = root
        for t in collection {
            if current?.children[t] == nil {
                current?.add(child: t)
            }
            
            current = current?.children[t]
        }
        
        current?.isTerminating = true
        
    }
    
    func contains(_ collection: [T]) -> Bool {
        guard !collection.isEmpty else {
            return false
        }
        
        var current: Node<T>? = root
        var index = 0
        while index < collection.count {
            let value = collection[index]
            guard let child = current?.children[value] else {
                break
            }
            
            index += 1
            current = child
        }
        
        return index == collection.count && current!.isTerminating
    }
    
    func lookup(prefix: [T]) -> [[T]] {
        guard !prefix.isEmpty else {
            var result: [[T]] = []
            for (_, child) in root.children {
                lookupRecursive(child, prefix: [], result: &result)
            }
            
            return result
        }
        
        var current: Node<T>? = root
        var index = 0
        while index < prefix.count {
            let value = prefix[index]
            guard let child = current?.children[value] else {
                break
            }
            
            index += 1
            current = child
        }
        
        // prefix not found
        guard index == prefix.count else {
            return []
        }
        
        var result: [[T]] = []
        lookupRecursive(current, prefix: prefix, result: &result)
        
        return result
    }
    
    private func lookupRecursive(_ node: Node<T>?, prefix: [T], result: inout [[T]]) {
        guard !(node is RootNode), let node = node else {
            return
        }
        
        if node.isTerminating {
            result.append(prefix)
        }
    
        for (_, child) in node.children {
            var prefix = prefix
            prefix.append(node.value!)
            lookupRecursive(child, prefix: prefix, result: &result)
        }
    }
    
}
