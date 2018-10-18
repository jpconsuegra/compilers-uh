# coding: utf8

import pydot

from .base import Graph


class Pipeline(Graph):
    """Represents a pipeline diagram.

    `nodes` is a dictionary of nodes `name` -> `shape`.
    `edges` is a list of edges, tuples of the form `(name, name, label)`.
    `**kwargs` is a list of args passed to `pydot` directly.

    >>> Pipeline(['HULK', 'AST-HULK', 'AST-CIL', 'MIPS'], [
        (0, 1, 'lexer/parser'),
        (1, 1, 'semántica'),
        (1, 2, 'generación'),
        (2, 3, 'generación')
    ])
    """

    def __init__(self, nodes, edges):
        self.nodes = nodes
        self.edges = edges

    def graph(self):
        G = pydot.Dot(rankdir='LR', margin=0.1, rank='same')

        for i, node in enumerate(self.nodes):
            G.add_node(pydot.Node(i, shape='box', label=node))

        for (start, end, label) in self.edges:
            G.add_edge(pydot.Edge(start, end, label=label, labeldistance=2))

        return G
