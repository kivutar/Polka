A minimalist CMS
================

Intro
-----

Polka is a small web-app I wrote using Dancer as an exercise in minimalism.
It is inspired by werc.

Features
--------

- Hackable, 60 lines of perl
- Data driven, uses the file system as database
- Markdown syntax
- Can serve static content, images, css, etc

Installation
------------

    $ sudo cpan
    cpan> install Dancer
    cpan> install Text::Markdown
    cpan> exit
    $ git clone git://github.com/Kivutar/Polka.git polka

Usage
-----

    $ cd polka
    $ mkdir data/Wiki
    $ vim data/Wiki/Test
    $ perl polka.pl
