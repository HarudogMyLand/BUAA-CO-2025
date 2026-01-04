import mipsGenerate
import mips2hex
import mipsRunByMARS
import mipsRunByVerilog
import mipsCheckAccuracy

def run_once(num1, num2, jump) -> bool:
    """
    Run simulation one

    Args:
        num1 (int): num of r type
        num2 (int): num of j type
        jump (bool): whether there are jump instruction

    Returns:
        bool: whether accepted
    """
    # print(f"No.{times} test started".center("-", 20))
    mipsGenerate.mips_generate_and_write(num1, num2, jump)
    mips2hex.dump_to_hex()

    mipsRunByMARS.mips_run_byMARS()

    if not mipsRunByVerilog.run_ise_simulation():
        return False
    mipsRunByVerilog.process_simulation_output()

    difference = mipsCheckAccuracy.cmp_output_accuracy("verilog.txt", "model_CPU.txt")
    # print(f"No.{times} test end".center('-', 20))
    return mipsCheckAccuracy.print_differences(difference)