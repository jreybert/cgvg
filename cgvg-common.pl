# cgvg-common.pl - common variables and functions to cgvg
# Copyright 2000-2002 by Joshua Uziel <uzi@uzix.org> - version 1.6.2
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

# Where to store the data
$LOGDIR = "$ENV{'HOME'}/.cgvg";

# Store the data in a file named for the HOSTNAME.PID of the shell.
$HOSTNAME = $ENV{'HOSTNAME'} ? $ENV{'HOSTNAME'} : "localhost";
$PPID = getppid;
$LOGFILE = "$LOGDIR/$HOSTNAME.$PPID";

# Symlink to the last log taken.
$LASTLOG = "$ENV{'HOME'}/.cglast";

# Path to the rc file
$RCFILE = "$ENV{'HOME'}/.cgvgrc";

# Default search list:
# 	Make* *.c *.h *.s *.cc *.pl *.pm *.java *.*sh *.idl
$SEARCH = '(^Make.*$|^.*\.([chslySC]|cc|p[lm]|java|php|.*sh|idl)$)';


# List of files and strings to exclude from our search.
$EXCLUDE = "SCCS|RCS|tags|\.make\.state";

# Oldest age (in days) before we delete.
$AGE = 30;

# Set if you want colors (and your term supports it).  This is required
# for the $BOLD* options.
$COLORS = 1;

# Have everything printed in bold... 1 (yes) or 0 (no) only.  This option
# is overrided by $BOLD_ALTERNATE and only available with $COLORS
$BOLD = 0;

# Make every other line bold.
$BOLD_ALTERNATE = 1;

# Colon mode - prints file:number instead of spacing it out
$COLON = 0;

# Use the cg-built-in pager by default... 1 (yes) or 0 (no)
$PAGER = 0;

# Use the $EDITOR env. variable if it exists, else default to something.
$EDITOR = $ENV{'EDITOR'} ? ($ENV{'EDITOR'}) : "vi";

# Defined colors
%colors = ( 'black'	=> "30",
	    'red'	=> "31",
	    'green'	=> "32",
	    'yellow'	=> "33",
	    'blue'	=> "34",
	    'magenta'	=> "35",
	    'cyan'	=> "36",
	    'white'	=> "37",
	    'b_black'	=> "30",
	    'b_red'	=> "31",
	    'b_green'	=> "32",
	    'b_yellow'	=> "33",
	    'b_blue'	=> "34",
	    'b_magenta'	=> "35",
	    'b_cyan'	=> "36",
	    'b_white'	=> "37");

# Default color for column #
$color[1] = 'cyan';
$color[2] = 'blue';
$color[3] = 'red';
$color[4] = 'green';
$color[5] = 'b_white';

# Set b (bold) and c (color) values for printing
for ($i=1; $i<=5; $i++) {
	$c[$i] = $colors{$color[$i]};
	$b[$i] = ($color[$i] =~ /^b_/) ? 1 : 0; 
}

# Code to parse the RCFILE entries
sub parse_rcfile {

	if (-f $RCFILE) {
		open (IN, "<$RCFILE");
		
		while (<IN>) {
			chomp;
			
			# Strip leading spaces and skip blank and comment lines
			s/\s*//g;
			next if (/^#/);
			next if (/^$/);
			
			($key, $value) = split /=/;

			# Match only the specific value.
			if ($key =~ /^COLORS$/) {
				$COLORS=$value;
			} elsif ($key =~ /^AGE$/) {
				$AGE=$value;
			} elsif ($key =~ /^BOLD_ALTERNATE$/) {
				$BOLD_ALTERNATE=$value;
			} elsif ($key =~ /^COLON$/) {
				$COLON=$value;
 			} elsif ($key =~ /^PAGER$/) {
 			         $PAGER=$value;
			} elsif ($key =~ /^EDITOR$/) {
				$EDITOR=$value;
			} elsif ($key =~ /^EXCLUDE$/) {
				$EXCLUDE=$value;
			} elsif ($key =~ /^SEARCH$/) {
				$SEARCH=$value;

			# Change colors from the defaults.
			} elsif ($key =~ /^COLOR[1-5]$/) {

				# See that a legal color has been given
				if ($value =~ 
/^(black|red|green|yellow|blue|magenta|cyan|white|\
|b_black|b_red|b_green|b_yellow|b_blue|b_magenta|b_cyan|b_white)$/) {
					$coltmp = $key;
					$coltmp =~ s/COLOR//;
					$c[$coltmp] = $colors{$value};
					$b[$coltmp] = $value =~ /^b_/ ? 1 : 0;
				} else {
					die "error: Unknown color '$value' in",
						" $RCFILE at line $..\n";
				}
			} else {
				die "error: Unknown option '$key' in $RCFILE",
					" at line $..\n";
			}
		}

		close (IN);
	}
}

1; # Return a true value ...
