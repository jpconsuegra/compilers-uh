# coding: utf8

import pydot


class Graph:
    images = 0

    def print(self, label="", caption="", float=True, width="50%"):
        if not label:
            label = f"image{Graph.images}"
            Graph.images += 1

        fname = f"build/graphics/{label}.svg"

        self.graph().write_svg(fname)

        output = f"![{caption}](../graphics/{label}.svg){{ #{label} width={width} }}"

        if not float:
            output += "\\"

        print(output)

    def _repr_svg_(self):
        return self.graph().create_svg().decode('utf8')

    def graph(self) -> pydot.Graph:
        raise NotImplementedError()
