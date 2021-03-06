import sys
import stat
import os
import json
from pathlib import Path
import typing

HOME_PATH = str(Path.home())
SOURCE_PATH = f'{HOME_PATH}/repos/dotfiles/'

WORK_PATH = f'{HOME_PATH}/regrun/'
RUNNER_FILE = f'{HOME_PATH}/regrun/runner.sh'
ALIASES_FILE = f'{HOME_PATH}/.config/aliases.txt'

USAGE: typing.Dict[str, str] = {
    'add': 'Add new alias.\t\t\t Usage: def add [-l] %new_name% %cmd%',
    'rm': 'Remove existing alias.\t\t Usage: def rm %existing_name%',
    'up': 'Update existing alias.\t\t Usage: def up %existing_name% %cmd%',
    'list': 'Print list of existing aliases\t Usage: def list'
}


def load_data(path: str) -> typing.Dict[str, str]:
    if not os.path.isfile(path):
        with open(path) as f:
            json.dump({}, fp=f)
        return {}

    with open(path) as f:
        lines = f.readlines()
        return {x[0:x.find(' ')]: x[x.find(' ')+1:] for x in lines if x.strip()}


def save_data(path: str, data: typing.Dict[str, str]):
    with open(path, 'w') as f:
        for key, value in data.items():
            if value[-1] != '\n':
                value += '\n'
            f.write(f'{key} {value}')



def print_usage(mode: str):
    print(f'{mode}\t{USAGE[mode]}')

def main() -> int:

    mode = sys.argv[1]
    cmdline = sys.argv[2:]

    data = load_data(ALIASES_FILE)

    if mode == 'add':
        if len(cmdline) < 2:
            print_usage('add')
            return 1

        alias = cmdline[0]
        cmd = ' '.join(cmdline[1:])

        if alias in data:
            print(
                f'Alias {alias} already exists. Run `def list` to see full list of aliases',
            )
            return 1
        else:
            data[alias] = cmd
            print(f'New alias added: {alias} -> {cmd}')

    elif mode == 'rm':
        if len(cmdline) != 1:
            print_usage('rm')
            return 1

        value = cmdline[0]
        if value not in data:
            print(f'Alias {value} does not exist. Can not remove')
            return 1

        data.pop(value)
        print(f'Alias {value} removed')

    elif mode == 'up':
        if len(cmdline) < 2:
            print_usage('up')
            return 1

        value = cmdline[0]
        if value not in data:
            print(f'Alias {value} does not exist. Can not update')
            return 1

        data[value] = ' '.join(cmdline[1:])
        print(f'Alias {value} updated')

    elif mode == 'list':
        if cmdline:
            print_usage('list')
            return 1

        if not data:
            print('No existing aliases')
            return 0

        print('List of all registred aliases')
        for key, value in data.items():
            print(f'{key} -> {value}')
        return 0
    elif mode == 'help':
        print('HELP....')
        for key in USAGE:
            print_usage(key)
        return 0

    save_data(ALIASES_FILE, data)

    return 0


if __name__ == '__main__':
    sys.exit(main())
