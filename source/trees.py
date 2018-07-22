# coding: utf8

import pydot

from .base import Graph


class Tree(Graph):
    def __init__(self, root, *children):
        self.root = root
        self.children = children

    def graph(self, parent=None, graph=None):
        if graph is None:
            graph = pydot.Dot()

        graph.add_node(pydot.Node(self.root))

        if parent is not None:
            graph.add_edge(pydot.Edge(parent, self.root))

        for child in self.children:
            child.graph(self.root, graph)

        return graph
