#!/usr/bin/perl6
use Bailador;
use Text::Markdown;

my %dirtree = dirtree( 'data' );

sub dirtree($dir) {
    my %tree;
    %tree{"$dir/$_"} = .IO.d ?? dirtree("$dir/$_") !! '' for dir($dir);
    %tree
}

sub menu (%tree, $path = '', $unfolded = False) {
    my $menu = $unfolded ?? "<ul class=\"active\">\n" !! "<ul>\n";
    for ( %tree.kv ) -> $link is copy, $child {
        $link ~~ s/^data\///;
        my $label = $link.split('/').pop;
        if $child {
            $menu ~= "<li class=\"dir\">$label\n" ~ menu($child, $path, $path ~~ /$link/) ~ "</li>\n";
        } else {
            my $class = $link eq $path ?? ' class="active"' !! '';
            $menu ~= "<li$class><a href=\"/$link\"> $label </a></li>\n";
        }
    }
    $menu ~= "</ul>\n";
}

get '/(.*)' => sub ($path is copy) {
    $path = "$path" || "Home";
    "<html>
        <head>
            <link href=\"/style.css\" rel=\"stylesheet\" type=\"text/css\" />
        </head>
        <body>
            <div>
                <h1><a href=\"/\"><span id=\"main-title\">Polka~</a></h1>
                <nav>" ~ menu( %dirtree, $path ) ~ "</nav>
                <div id=\"page\">" ~ slurp( "data/$path" ) ~ "</div>
            </div>
            <footer>Powered by <a href=\"#\">Polka</a>.</footer>
        </body>
    </html>"; 
}

baile;