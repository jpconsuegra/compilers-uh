#! /usr/bin/env python3
# coding: utf8

import panflute as pf

def action(elem, doc):
    if isinstance(elem, pf.Image):
        elem.url = elem.url.replace("..", "build").replace("svg", "pdf")
        return elem

def main(doc=None):
    return pf.run_filter(action, doc=doc)

if __name__ == '__main__':
    main()
