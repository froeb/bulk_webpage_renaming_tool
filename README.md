# bulk_webpage_renaming_tool

This repository contains a Perl script that automates the process of renaming web files and generating Apache `.htaccess` Rewrite rules based on a list provided in a CSV file. It is designed to streamline the management of web resource naming on servers running Debian.

## Features

- **File Renaming**: Automatically generates a shell script to rename files on a Debian server.
- **Apache Rewrite Rules**: Generates Apache `.htaccess` rules to redirect old filenames to new ones, ensuring seamless user experience during website updates.

## Requirements

- Perl 5
- `Text::CSV` Perl module

## Installation

Clone the repository to your local machine using:

```bash
git clone https://github.com/yourusername/webpage-renaming-tool.git

Ensure that Perl and the Text::CSV module are installed on your system. If you need to install the module, you can use CPAN:

cpan Text::CSV
```

## Usage
Prepare a CSV file named webseiten_namen.csv with two columns: the old filename and the new filename.

Run the script using:
```bash
perl rename_files.pl
```

The script will generate two files:
* rename_files.sh : A shell script to rename the files.
* .htaccess : An Apache configuration file with the necessary Rewrite rules.

## Configuration
Ensure that the generated .htaccess file is placed in the directory where your webserver can read it, and that the mod_rewrite module is enabled.

## Contributing
Contributions to this project are welcome. Please fork the repository and submit a pull request.

## License

This project is open-sourced under the MIT License. For more details, see the [MIT License](https://opensource.org/licenses/MIT) documentation.

## Author
Kai Froeb

Email: github@froeb.net
Webpage: https://kai.froeb.net
