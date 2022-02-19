import sys
import json
import os

DEFAULT_PLATFORM_KEY = "OK"

FILE_LOG = "log/log_setup_build_platform.txt"
FILE_BUILD_CONFIG = "main/build_settings/build_settings.json"
FILE_SETTINGS = "main/editor/platform_changer/config/config_change_platform.json"

KEY_FILE_REPLACE = "file_replace"
KEY_FILE_RENAME = "file_rename"
KEY_FILE_PROJECT = "project_file"
KEY_FILE_PLATFORM = "platform_file"

class JsonFileLoadable:
    def __init__(self):
        pass

    def load_from_file(self, file_path):
        if not file_path or not os.path.exists(file_path):
            print(f"cant load from path {file_path}")
            return

        with open(file_path, "r+") as file_config:
            content = file_config.read()
            self.__dict__ = json.loads(content)
        
    def save_to_file(self, file_path):
        if not file_path or not os.path.exists(file_path):
            print(f"cant save to path {file_path}")
            return

        with open(file_path, "w+") as file_instance:
            file_instance.write(json.dumps(self.__dict__))

class ConfigChangePlatform(JsonFileLoadable):
    def __init__(self):
        self.platforms = {}
    
    def get_platform_config(self, platform_key):
        if platform_key in self.platforms:
            return self.platforms[platform_key]
        
        print(f"cant find config for {platform_key}")
        return None

class BuildSettings(JsonFileLoadable):
    def __init__(self):
        self.build_variant = DEFAULT_PLATFORM_KEY

def log(message):
    print(message)
    with open(FILE_LOG, "a+") as file_test:
        file_test.write(message)

def copy_file(path_file_from, path_file_to):
    if not path_file_from or not os.path.exists(path_file_from):
        log(f"cant find file {path_file_from}")
        return
    if not path_file_to or not os.path.exists(path_file_to):
        log(f"cant find file {path_file_to}")
        return

    print(f"copy file from {path_file_from} to {path_file_to}")
        
    with open(path_file_from, "r+") as file_from:
        content = file_from.read()
        with open(path_file_to, "w+") as file_to:
            file_to.write(content)

def copy_files(files_data, key_from, key_to):
    if  not files_data:
        return

    for file_replace_info in files_data:
        file_from = file_replace_info[key_from]
        file_to = file_replace_info[key_to]
        copy_file(file_from, file_to)

def rename_files(files_data, key_from, key_to):
    if not files_data:
        return

    for file_rename_info in files_data:
        file_from = file_rename_info[key_from]
        file_to = file_rename_info[key_to]
        
        if os.path.exists(file_from):
            os.rename(file_from, file_to)
        else:
            print(f"cant find file for rename {key_from}")

def store_platform_settings(platform_config):
    files_replace = platform_config.get(KEY_FILE_REPLACE, None)
    copy_files(files_replace, KEY_FILE_PROJECT, KEY_FILE_PLATFORM)

    files_rename = platform_config.get(KEY_FILE_RENAME, None)
    rename_files(files_rename, KEY_FILE_PLATFORM, KEY_FILE_PROJECT)

def load_platform_settings(platform_config):
    files_replace = platform_config.get(KEY_FILE_REPLACE, None)
    copy_files(files_replace, KEY_FILE_PLATFORM, KEY_FILE_PROJECT)

    files_rename = platform_config.get(KEY_FILE_RENAME, None)
    rename_files(files_rename, KEY_FILE_PROJECT, KEY_FILE_PLATFORM)


def change_platform(key):
    config = ConfigChangePlatform()
    config.load_from_file(FILE_SETTINGS)

    build_settings = BuildSettings()
    build_settings.load_from_file(FILE_BUILD_CONFIG)

    current_platform_config = config.get_platform_config(build_settings.build_variant)
    next_platform_config = config.get_platform_config(key)
    
    if not current_platform_config or not next_platform_config:
        log(f"Cant change config, cant find config for keys {key} {build_settings.build_variant}")
        return
    
    store_platform_settings(current_platform_config)
    load_platform_settings(next_platform_config)

    build_settings.build_variant = key
    build_settings.save_to_file(FILE_BUILD_CONFIG)

if __name__ == "__main__":
    argv_count = len(sys.argv)

    platform_key = DEFAULT_PLATFORM_KEY
    if argv_count > 1:
        platform_key = sys.argv[1]
    
    change_platform(platform_key)
