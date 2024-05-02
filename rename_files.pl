#!/usr/bin/perl
# =============================================================================
# Webpage Renaming Tool
# =============================================================================
#
# This script reads a CSV file with old and new webpage names and generates:
# 1. A shell script for renaming files on a Debian server.
# 2. An Apache .htaccess file with Rewrite rules for redirecting old URLs to new ones.
#
# Usage:
#   perl rename_files.pl
#
# Requirements:
#   Perl 5 and the Text::CSV module.
#
# Author:
#   Kai Froeb
#   Email: github@froeb.net
#   Author's Webpage: https://kai.froeb.net
#   Perl Script's GitHub page: https://github.com/froeb/bulk_webpage_renaming_tool
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

use strict;
use warnings;
use Text::CSV;

# Function to check for valid filenames
sub is_valid_filename {
    my ($filename) = @_;
    return $filename !~ /[<>:"\/\\|?*]/;
}

# Main function to generate scripts
sub generate_scripts {
    my ($csv_file_path) = @_;

    # Check if the CSV file exists
    unless (-e $csv_file_path) {
        print "Error: The file '$csv_file_path' does not exist.\n";
        return;
    }

    my $csv = Text::CSV->new({ binary => 1 });
    open my $fh, "<", $csv_file_path or die "Could not open '$csv_file_path': $!\n";

    my @shell_commands;
    my @rewrite_rules;
    my @invalid_filenames;

    while (my $row = $csv->getline($fh)) {
        if (scalar @$row != 2) {
            print "Error: Invalid line structure @$row. Each line requires exactly two columns.\n";
            next;
        }

        my ($old_name, $new_name) = @$row;

        # Validate both filenames
        if (!is_valid_filename($old_name) || !is_valid_filename($new_name)) {
            push @invalid_filenames, "Old name: $old_name, New name: $new_name";
            next;
        }

        push @shell_commands, "mv \"$old_name\" \"$new_name\"";
        push @rewrite_rules, "RewriteRule ^$old_name\$ $new_name [R=301,L]";
    }

    close $fh;

    if (@invalid_filenames) {
        print "Invalid filenames found:\n";
        print "$_\n" for @invalid_filenames;
        return;
    }

    # Writing the shell commands to a file
    open my $sh_fh, ">", "rename_files.sh" or die "Could not write to 'rename_files.sh': $!\n";
    print $sh_fh "#!/bin/bash\n";
    print $sh_fh "$_\n" for @shell_commands;
    close $sh_fh;

    # Writing the rewrite rules to a file
    open my $ht_fh, ">", ".htaccess" or die "Could not write to '.htaccess': $!\n";
    print $ht_fh "RewriteEngine On\n";
    print $ht_fh "$_\n" for @rewrite_rules;
    close $ht_fh;

    print "Files 'rename_files.sh' and '.htaccess' have been successfully generated.\n";
}

# Path to the CSV file - change to your liking
my $csv_file_path = 'webpages_to_be_renamed.csv';
generate_scripts($csv_file_path);
