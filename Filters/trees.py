#!/usr/bin/python3
# coding: utf-8

import sys
import re
import json
import pprint


def parse_tree(tree):
    text = tree.split("\n")
    text = [line for line in text if line.strip()]
    symbol_lines = [line for i, line in enumerate(text) if i % 2 == 0]
    edge_lines = [line for i, line in enumerate(text) if i % 2 == 1]

    symbol_re = re.compile("\S+")

    class Symbol:
        def __init__(self, symbol, start, end):
            self.symbol = symbol
            self.start = start
            self.end = end
            self.children = []
            self.parent = None

        def tree(self):
            result = { self.symbol: [] }

            for c in self.children:
                result[self.symbol].append(c.tree())

            return result

        def __repr__(self):
            return "Symbol(%s, %s, %s)" % (self.symbol, self.start, self.end)

    def split(line):
        start = 0
        symbols = []
        match = symbol_re.search(line, start)

        while match:
            symbols.append(Symbol(line[match.start(): match.end()], match.start(), match.end() - 1))
            start = match.end()
            match = symbol_re.search(line, start)

        return symbols

    def split_edges(line):
        symbols = []

        for i,c in enumerate(line):
            if c in "|/\\":
                symbols.append(Symbol(c,i,i))

        return symbols

    all_symbols = {}
    symbols_list = []

    # parsing symbols
    for i, line in enumerate(symbol_lines):
        symbols = split(line)
        all_symbols[i] = symbols
        symbols_list.extend(symbols)

    def find_exact(pos, symbols):
        for sym in symbols:
            if sym.start <= pos <= sym.end:
                return sym

        return None

    def find_right(pos, symbols):
        exact = find_exact(pos, symbols)

        if exact:
            return exact

        for sym in symbols:
            if sym.start > pos:
                return sym

        return None

    def find_left(pos, symbols):
        exact = find_exact(pos, symbols)

        if exact:
            return exact

        for sym in reversed(symbols):
            if sym.end < pos:
                return sym

        return None

    # parsing edges
    for i, line in enumerate(edge_lines):
        edges = split_edges(line)

        prev_line = all_symbols[i]
        next_line = all_symbols[i+1]

        for sym in edges:
            parent = None
            child = None

            if sym.symbol == "|":
                parent = find_exact(sym.start, prev_line)
                child = find_exact(sym.start, next_line)

            elif sym.symbol == "/":
                parent = find_right(sym.start, prev_line)
                child = find_left(sym.start, next_line)

            elif sym.symbol == "\\":
                parent = find_left(sym.start, prev_line)
                child = find_right(sym.start, next_line)

            parent.children.append(child)
            child.parent = parent

    trees = []

    for sym in symbols_list:
        if sym.parent is None:
            trees.append(sym.tree())

    return trees


def main():

    input_ast = json.loads(sys.stdin.read())


    def match(obj, pattern):
        if isinstance(pattern, (int, str)) and obj != pattern:
            return False

        if isinstance(pattern, list):
            if not isinstance(obj, list):
                return False

            if len(obj) != len(pattern):
                return False

            for i, item in enumerate(pattern):
                if item is None:
                    continue

                if not match(obj[i], item):
                    return False

        if isinstance(pattern, dict):
            for key, val in pattern.items():
                if not match(obj.get(key), val) :
                    return False

        return True


    tree_item = {
        "c": [
            [
                None,
                [
                    "tree"
                ],
                None
            ],
            None
        ],
        "t": "CodeBlock"
    }


    def process_ast(ast):
        # for item in ast[1]:
        #     if match(item, tree_item):
        #         tree = item["c"][1]
        #         print(tree)
        #         processed_tree = parse_tree(tree)
        #         pprint.pprint(processed_tree)

        return ast


    processed_ast = process_ast(input_ast)

    with open("ast.json", "wt") as fp:
        json.dump(processed_ast, fp, indent=4)

    output_ast = json.dumps(processed_ast)

    sys.stdout.write(output_ast)


if __name__ == '__main__':
    main()
