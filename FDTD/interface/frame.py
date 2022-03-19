def printFrame(message: str) -> str:
    temp = '-' * (len(message)+4)
    emptyness = ' ' * (len(message)+2)
    return f'\n\n{temp}\n|{emptyness}|\n| {message} |\n|{emptyness}|\n{temp}\n\n'
