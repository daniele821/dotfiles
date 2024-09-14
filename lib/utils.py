#!/bin/python3

def color(clr, str):
    match clr:
        case "err": return "\033[1;31m" + str + "\033[m"
        case "file": return "\033[1;34m" + str + "\033[m"
        case "msg": return "\033[1;33m" + str + "\033[m"


def color_all(*args):
    buffer = []
    for i in range(0, len(args), 2):
        clr = args[i]
        str = args[i + 1]
        buffer.append(color(clr, str))
    return "".join(buffer)
