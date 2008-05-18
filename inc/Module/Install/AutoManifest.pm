#line 1
use strict;
use warnings;

package Module::Install::AutoManifest;

use Module::Install::Base;

BEGIN {
  our $VERSION = '0.001';
  our $ISCORE  = 1;
  our @ISA     = qw(Module::Install::Base);
}

sub auto_manifest {
  my ($self) = @_;

  die "auto_manifest requested, but no MANIFEST.SKIP exists\n"
    unless -e "MANIFEST.SKIP";

  if (-e "MANIFEST") {
    unlink('MANIFEST') or die "Can't remove MANIFEST: $!";
  }

  $self->postamble(<<"END");
create_distdir: manifest_clean manifest

distclean :: manifest_clean

manifest_clean:
\t\$(RM_F) MANIFEST
END

}

1;
__END__

#line 46

#line 129

1; # End of Module::Install::AutoManifest