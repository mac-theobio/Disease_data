use strict;
use 5.10.0;

my %tab;

while(<>){
	chomp;
	my @ln = split /,/;
	my $rowname = shift @ln;
	$tab{$rowname} = \@ln;
}

my @years = @{$tab{Country}};

say "Year\tEstimate\tLow\tHigh";

my $num = "(.*?)\\s*";
foreach my $entry (@{$tab{Global}}){
	my @vals = $entry =~ /$num\[$num-$num\]/;
	foreach (@vals){
		s/ //g;
	}
	print shift @years, "\t";
	say join "\t", @vals;
}
