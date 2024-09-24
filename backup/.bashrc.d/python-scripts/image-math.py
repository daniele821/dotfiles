#!/bin/python3

import sys


def stderr(*args, sep=" ", end="\n"):
    for arg in args:
        sys.stderr.write(str(arg))
        sys.stderr.write(sep)
    sys.stderr.write(end)


args = [int(elem) for elem in sys.argv[1:]]
image_width = args[0]
image_height = args[1]
term_width_cells = args[2]
term_height_cells = args[3]
term_width = args[4]
term_height = args[5]
cell_width = args[6]
cell_height = args[7]
RESIZE_IMAGE = args[8] != 0

width = term_width_cells * cell_width
height = (term_height_cells - 2) * cell_height
if RESIZE_IMAGE:
    # i have no idea what is going on here [*** magic ***]
    width_factor = float(width) / float(image_width)
    height_factor = float(height) / float(image_height)
    width_factor_rel = width_factor / height_factor
    height_factor_rel = height_factor / width_factor
    if width_factor_rel > 1:
        width = int(width / width_factor_rel)
    elif height_factor_rel > 1:
        height = int(height / height_factor_rel)
print(width)
print(height)
