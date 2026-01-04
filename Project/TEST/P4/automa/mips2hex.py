import os

def dump_to_hex():
    """
    This function dump code in mips.asm into hexadecimal file in code.txt
    :return:
    """
    MARS_PATH = r"MARS-main.jar"

    # char = input(f"Is your Mars path: {MARS_PATH}?")
    char = 'y'
    filename = "mips.asm"

    if char == "y":
        cmd = (
            f'java -jar "{MARS_PATH}" '
            f'"{filename}" '
            f'p nc mc CompactDataAtZero a dump .text HexText code.txt'
        )
        os.system(cmd)
    else:
        char = input("Input your path").strip()
        try:
            cmd = (
                f'java -jar "{MARS_PATH}" '
                f'"{filename}" '
                f'p nc mc CompactDataAtZero a dump .text HexText code.txt'
            )
            os.system(cmd)
        except:
            print("Invalid path")