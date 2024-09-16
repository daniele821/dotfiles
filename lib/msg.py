#!/bin/python3

AUTO_ANSWER = None


def color(clr, str):
    match clr:
        case "err": return "\033[1;31m" + str + "\033[m"
        case "file": return "\033[1;34m" + str + "\033[m"
        case "msg": return "\033[1;33m" + str + "\033[m"
        case _: return str


def color_all(*args):
    buffer = []
    for i in range(0, len(args), 2):
        clr = args[i]
        str = args[i + 1]
        buffer.append(color(clr, str))
    return "".join(buffer)


def ask_user(msg, auto_answer=None):
    print(msg, end="")
    if auto_answer is None:
        auto_answer = AUTO_ANSWER
    match auto_answer:
        case "y" | "n":
            print(auto_answer)
            return auto_answer == "y"
        case _:
            match input():
                case "y": return True
                case "n" | "": return False
                case _:
                    print("Invalid answer, retry:")
                    return ask_user(msg, auto_answer)


def error(msg):
    print(color("err", "ERROR: " + msg))
    exit(1)
