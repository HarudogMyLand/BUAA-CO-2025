


def cmp_output_accuracy(file1:str, file2:str) -> list:
    """Comparing output accuracy.
        If there is any error happen: print error message
    """
    # print("Comparing...")
    try:
        with open(file1, 'r', encoding='utf-8') as f1, \
                open(file2, 'r', encoding='utf-8') as f2:

            lines1 = f1.readlines()
            lines2 = f2.readlines()

            max_lines = max(len(lines1), len(lines2))
            differences = []

            for i in range(max_lines):
                line1 = lines1[i].strip() if i < len(lines1) else "[End file]"
                line2 = lines2[i].strip() if i < len(lines2) else "[End file]"

                if line1 != line2:
                    differences.append([line1, line2])

            return differences

    except FileNotFoundError as e:
        print(f"File not found: {e}")
        return []
    except Exception as e:
        print(f"Error when reading file: {e}")
        return []


def print_differences(differences:list) -> bool:
    """
    print differences
    """

    # Danger! Due to MARS problem, when using jal function, the error should be ignored!!!
    def is_acceptable_difference(line1, line2):
        """
        Whether is jal problem
        """
        if "$31 <= " in line1 and "$31 <= " in line2:
            val1 = line1.split()[3].strip()
            val2 = line2.split()[3].strip()

            try:
                num1 = int(val1, 16)
                num2 = int(val2, 16)
                diff = abs(num1 - num2)

                if diff == 0x3FD000:
                    return True
            except ValueError:
                pass

        return False

    for case in differences:
        if is_acceptable_difference(case[0], case[1]):
            differences.remove(case)
    if not differences or len(differences) == 0:
        print("Accepted!")
        return True
    print(f"\n{len(differences)} Errors:")
    print("Start".center(50, "-"))
    for case in differences:
        print(f"At mips address {case[0]} we expected {case[1]}")
    print("End".center(50, "-"))
    return False


# print_differences(cmp_output_accuracy("verilog.txt", "modle_CPU.txt"))