import os
import subprocess

# https://foreveryolo.top/posts/34987/index.html is referred!!!

run_time = "2500ns"
cpu_path = r""
ise_path = r""

import os


def run_ise_simulation():
    """Run ISE simulation
    This function collect all .v file and compile them.
    Then, generate a .prj and a .tcl file to start generation
    """
    # print("Running ISE simulation...")
    global cpu_path, ise_path, run_time
    try:
        with open("path_config.txt", "r") as f:
            lines = f.readlines()
            for line in lines:
                if line.startswith("cpu_path"):
                    cpu_path = line.split("=")[-1].strip() if "=" in line else line.replace("cpu_path", "").strip()
                elif line.startswith("ise_path"):
                    ise_path = line.split("=")[-1].strip() if "=" in line else line.replace("ise_path", "").strip()
            if not cpu_path or not ise_path:
                raise FileNotFoundError("Paths not found in config file")
    except FileNotFoundError:
        print("ISE simulation necessary files not found.")
        print("Mat I remind you, that you could put your .v file in the verilog_project folder of this script.")
        print("But sorry, you still have to input the absolute path of them.")
        with open("path_config.txt", 'w') as f:
            cpu = input("Input the absolute path of your cpu folder: ").strip()
            ise = input("Input the absolute path of your ise folder: ").strip()
            f.write(f"cpu_path={cpu}\n")
            f.write(f"ise_path={ise}\n")
            print("Please restart the program!")
            return False

    if not os.path.exists(cpu_path):
        print(f"CPU path does not exist: {cpu_path}")
        print("Please check the path of your cpu folder.")
        os.system("del path_config.txt")
        return False
    if not os.path.exists(ise_path):
        print(f"ISE path does not exist: {ise_path}")
        print("Please check the path of your ise folder.")
        os.system("del path_config.txt")
        return False

    file_list = []
    for root, dirs, files in os.walk(cpu_path):
        for file in files:
            if file.endswith(".v"):
                file_list.append(file)

    with open(os.path.join(cpu_path, "mips.prj"), "w") as prj:
        for file in file_list:
            prj.write(f'verilog work "{os.path.join(cpu_path, file)}"\n')

    with open(os.path.join(cpu_path, "mips.tcl"), "w") as tcl:
        tcl.write(f"run {run_time};\nexit")

    os.environ["XILINX"] = ise_path

    compile_cmd = [
        os.path.join(ise_path, "bin", "nt64", "fuse"),
        "-nodebug",
        "-prj", os.path.join(cpu_path, "mips.prj"),
        "-o", "mips.exe",
        "test_mips"
    ]

    with open("compile_log.txt", "w") as log:
        subprocess.run(compile_cmd, stdout=log, stderr=subprocess.STDOUT)

    sim_cmd = ["mips.exe", "-nolog", "-tclbatch", os.path.join(cpu_path, "mips.tcl")]

    with open("raw_out.txt", "w") as out:
        subprocess.run(sim_cmd, stdout=out, stderr=subprocess.STDOUT)

    return True


def process_simulation_output():
    """Handling simulation output"""
    # print("Simulating...")

    try:
        with open("raw_out.txt", "r", encoding="utf-8") as f:
            content = f.read()

        processed_output = ""
        lines = content.split('\n')

        for line in lines:
            if line.strip().startswith('@'):
                processed_output += line + '\n'

        with open("verilog.txt", "w", encoding="utf-8") as f:
            f.write(processed_output)

    except Exception as e:
        print(f"Error during simulation output handling: {e}")