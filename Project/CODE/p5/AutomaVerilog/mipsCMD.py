import argparse
import os


def get_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("--nj", "-nj", action="store_false", help = "If enabled "
                                       "no jump instructions will be generated.")
    parser.add_argument("--s", "-s", default = 10, type = int, help = "Number/Size of "
                                                   "blocks.")
    parser.add_argument("--js", "-js", default = 10, type = int, help = "Number/Size of "
                                                    "jump instructions block.")
    parser.add_argument("--r", "-r", action="store_true", help="If enabled restart.")
    return parser


def restart_all():
    """
    Delete all files not ending with .py, .v, and .jar in current folder and subfolders.
    :return: None
    """
    current_dir = os.getcwd()

    for root, dirs, files in os.walk(current_dir):
        for file in files:
            file_path = os.path.join(root, file)

            if not (file.endswith(".py") or file.endswith(".v") or file.endswith(".jar") or file.endswith(".md")):
                try:
                    os.remove(file_path)
                    print(f"Deleted: {file_path}")
                except Exception as e:
                    print(f"Error deleting {file_path}: {e}")