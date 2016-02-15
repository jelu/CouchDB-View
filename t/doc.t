use strict;
use warnings;
use Test::More 'no_plan';

use CouchDB::View::Document;
use JSON::XS;

my $j = JSON::XS->new;

my $doc = CouchDB::View::Document->new({
  _id => '_design/test',
  views => {
    test => sub { dmap(undef, shift) },
  },
});

my $hash = $doc->as_hash;

$hash->{ views }->{ test } =~ s/use strict 'refs';/use strict;/o
  if !$^V or $^V lt 'v5.18.0';

is_deeply(
  $hash,
  {
    _id => "_design/test",
    language => "text/perl",
    views => {
      test => <<'',
do { my $CODE1; $CODE1 = sub {
           use warnings;
           use strict;
           dmap(undef, shift());
         }; $CODE1 }

    },
  },
  "as_hash, with serialized code",
);

is($doc->uri_id, '_design%2Ftest', "encoded id");

is_deeply(
  $j->decode($j->encode($doc->as_hash)),
  $doc->as_hash,
  "roundtrip ok",
);
