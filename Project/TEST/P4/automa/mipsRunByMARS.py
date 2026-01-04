import os

# run MARS to generate debug CPU information
def mips_run_byMARS():
    os.system("del model_CPU.txt")
    cmd = "java -jar MARS-main.jar p nc mc CompactDataAtZero mips.asm"
    os.system(cmd)
    # print("done")