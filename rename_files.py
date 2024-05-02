#!/usr/bin/env python3
# =============================================================================
# Webpage Renaming Tool
# =============================================================================
#
# This script reads a CSV file with old and new webpage names and generates:
# 1. A shell script for renaming files on a Debian server.
# 2. An Apache .htaccess file with Rewrite rules for redirecting old URLs to new ones.
#
# Usage:
#   python rename_files.pl
#
# Requirements:
#   Python 3 and the csv and os module
#
# Author:
#   Kai Froeb
#   Email: github@froeb.net
#   Webpage: https://kai.froeb.net
#
# License:
#   MIT License
#   This software is provided "as is", without warranty of any kind, express or
#   implied, including but not limited to the warranties of merchantability,
#   fitness for a particular purpose and noninfringement. In no event shall the
#   authors or copyright holders be liable for any claim, damages or other
#   liability, whether in an action of contract, tort or otherwise, arising from,
#   out of or in connection with the software or the use or other dealings in the
#   software.
#
# =============================================================================
import csv
import os

def is_valid_filename(filename):
    # Define invalid characters for filenames based on common file systems
    invalid_chars = '<>:"/\\|?*'
    if any(char in filename for char in invalid_chars):
        return False
    return True

def generate_scripts(csv_file_path):
    if not os.path.exists(csv_file_path):
        print(f"Error: The file '{csv_file_path}' does not exist.")
        return

    shell_commands = []
    rewrite_rules = []
    invalid_filenames = []

    try:
        with open(csv_file_path, newline='') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                if len(row) != 2:
                    print(f"Error: Invalid line structure {row}. Each line requires exactly two columns.")
                    continue
                old_name, new_name = row

                # Check if both filenames are valid
                if not is_valid_filename(old_name) or not is_valid_filename(new_name):
                    invalid_filenames.append((old_name, new_name))
                    continue

                shell_commands.append(f'mv "{old_name}" "{new_name}"')
                rewrite_rules.append(f'RewriteRule ^{old_name}$ {new_name} [R=301,L]')
    
    except Exception as e:
        print(f"An error occurred while reading the CSV file: {e}")
        return

    if invalid_filenames:
        print("Invalid filenames found:")
        for old, new in invalid_filenames:
            print(f"Old name: {old}, New name: {new}")
        return

    try:
        with open('rename_files.sh', 'w') as file:
            file.write("#!/bin/bash\n")
            file.writelines([f"{cmd}\n" for cmd in shell_commands])
    except IOError as e:
        print(f"Error writing to the shell file: {e}")
        return

    try:
        with open('.htaccess', 'w') as file:
            file.write("RewriteEngine On\n")
            file.writelines([f"{rule}\n" for rule in rewrite_rules])
    except IOError as e:
        print(f"Error writing to the .htaccess file: {e}")
        return

    print("Files 'rename_files.sh' and '.htaccess' have been successfully generated.")

# Path to the CSV file with 2 columns, one with tzhe old name, the other with the new name
csv_file_path = 'webpages_to_be_renamed.csv'
generate_scripts(csv_file_path)

