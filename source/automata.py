# coding: utf8

import pydot


class Automaton:
    images = 0

    def __init__(self, start, final, states):
        self.start = start
        self.states = states
        self.final = final

    def graph(self):
        G = pydot.Dot(rankdir='LR', margin=0.1)
        G.add_node(pydot.Node('start', shape='plaintext', label='', width=0, height=0))

        for (start, tran), end in self.states.items():
            G.add_node(pydot.Node(start, shape='circle', style='bold' if start in self.final else ''))
            G.add_node(pydot.Node(end, shape='circle', style='bold' if end in self.final else ''))
            G.add_edge(pydot.Edge(start, end, label=tran, labeldistance=2))

        G.add_edge(pydot.Edge('start', self.start, label='', style='dashed'))
        return G

    def _repr_svg_(self):
        return self.graph().create_svg().decode('utf8')

    def print(self, label="", caption="", float=True):
        Automaton.images += 1
        fname = f"build/graphics/{label}image{Automaton.images}.svg"

        self.graph().write_svg(fname)

        output = f"![{caption}](../graphics/{label}image{Automaton.images}.svg){{ #{label} }}"

        if not float:
            output += "\\"

        print(output)
