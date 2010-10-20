#!/usr/bin/perl
use Dancer;
use File::Find;
use Text::Markdown 'markdown';
use utf8;

my %cache;
my $dirtree = dirtree( 'data' );
sub slurp { local $/; open(my $fh, '<:utf8', shift); <$fh> }
sub cache { my $f = shift; $cache{$f} ||= slurp $f }

sub dirtree {
    my $dir = shift;
    my %tree;

    opendir(DIR, $dir);
    my @files = grep {!/^\.\.?$/} readdir(DIR);
    closedir(DIR);

    $tree{"$dir/$_"} = -d "$dir/$_" ? dirtree("$dir/$_") : '' for @files;

    \%tree;
}

sub menu {
    my ($tree, $path, $unfolded) = @_;
    my $menu = $unfolded ? "<ul class=\"active\">\n" : "<ul>\n";
    while ( my ($link, $child) = each %$tree ) {
        $link =~ s/^data\///;
        my $label = pop @{[ split '/', $link ]};
        if ( $child ) {
            $menu .= "<li class=\"dir\">$label\n".menu($child, $path, $path =~ /$link/)."</li>\n";
        } else {
            my $class = $link eq $path ? ' class="active"' : '';
            $menu .= "<li$class><a href=\"/$link\">$label</a></li>\n";
        }
    }
    $menu .= "</ul>\n";
}

get qr{/(?<path>.*)} => sub {
    captures->{path} ||= 'Home';
    "<html>
        <head>
            <link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\" />
        </head>
        <body>
            <div>
                <h1><a href=\"/\"><span id=\"main-title\">Polka~</a></h1>
                <nav>" . menu( $dirtree, captures->{path} ) . "</nav>
                <div id=\"page\">" . markdown( cache 'data/'.captures->{path} ) . "</div>
            </div>
            <footer>Powered by <a href=\"#\">Polka</a>.</footer>
        </body>
    </html>";
};

dance;
