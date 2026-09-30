import os
import sys


def find_ancestor_with(file_or_folder_name: str) -> str:
    folder: str = os.path.dirname(os.path.abspath(__file__))
    while folder != os.path.dirname(folder):
        if os.path.exists(os.path.join(folder, file_or_folder_name)):
            return folder
        folder = os.path.dirname(folder)
    return ""


project_name: str = 'welfare_state_analytics'
project_short_name: str = "westac"

script_dir: str = os.path.dirname(os.path.abspath(__file__))

corpus_folder: str = os.path.join(script_dir, 'data')
root_folder: str = script_dir
resources_folder: str = os.path.join(script_dir, 'resources')

data_folder: str = corpus_folder

if root_folder not in sys.path:
    sys.path.insert(0, root_folder)
