import random

# Generate Reasonable MIPS code

index = 0

r_type = ['add', 'sub']
i_type = ['ori', 'lui', 'lw', 'sw']

regs = [f"{i}" for i in range(1, 31)]

code = []


def initial_regs(code: list):
    """
    Initialize register file to avoid invalid operand.
    :param code:
    :return:
    """
    for i in range(1, 31):
        num = random.randint(1, 100)
        code.append(f"ori ${i}, $0, {num}")

def random_legal_addr():
    base_addr = 0x00000000 + random.randint(0, 0x0000) & 0xFFFFFFFC
    return base_addr

def generate_random_jump(code: list):
    """
    Add a jump block to code list, end with jumping out logic
    :param code:
    :return:
    """
    global index

    code.append(f"jal L{index + 1}")

    generate_random_operation_with_no_jump(code, 10)

    code.append(f"beq $0, $0, L{index + 2}")
    code.append(f"L{index + 1}:")
    code.append(f"jr $ra")
    code.append(f"L{index + 2}:")
    index += 3

def generate_random_operation_with_no_jump(code: list, nums: int):
    """
    Generate random operations WITHOUT jump or branch
    :param code:
    :return:
    """

    def random_r():
        return random.choice(r_type)

    def random_i():
        return random.choice(i_type[:1])

    def random_word():
        return random.choice(i_type[2:])

    for i in range(nums):
        probability = random.random()

        if probability > 0.6:
            op = random_i()
            rd = random.choice(regs)
            imm = random.randint(1, 100)
            code.append(f"{op} ${rd}, ${rd}, {imm}")

        elif probability > 0.5:
            # op = random_word()
            rs = random.choice(regs)
            rt = random.choice(regs)
            imm = random.randint(1, 63) * 4
            base_addr = random_legal_addr()
            code.append(f"ori ${rs}, $0, {base_addr}")
            code.append(f"sw ${rt}, {imm}(${rs})")
            code.append(f"lw ${rt}, {imm}(${rs})")

        else:
            op = random_r()
            rd = random.choice(regs)
            rt = random.choice(regs)
            rs = random.choice(regs)
            code.append(f"{op} ${rd}, ${rs}, ${rt}")


def generate(args1 = 5, num = 10, jump = True) -> str:
    """
    Generate code
    :param jump:
    :param args1:
    :param num:
    :return:
    """
    code_list = []
    initial_regs(code_list)
    if jump:
        while args1 > 0:
            if random.random() < 0.2:
                generate_random_jump(code_list)
                pass
            else:
                generate_random_operation_with_no_jump(code_list, num)
            args1 -= 1
    else:
        while args1 > 0:
            generate_random_operation_with_no_jump(code_list, num)
            args1 -= 1

    return '\n'.join(code_list)

def mips_generate_and_write(num1:int, num2:int, jump) -> None:
    """
    Generate mips code to mips.asm
    num1: length of normal code
    num2: length of jump blocl
    jump: whether jump or not
    :return:
    """
    try:
        with open("mips.asm", "w") as f:
            content = generate(num1, num2, jump)
            f.write(content)
        print("OK!")
    except PermissionError:
        print("Error, no permission")
    except Exception as e:
        print(f"Error: {e}")
