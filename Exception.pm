# $Id: Exception.pm,v 1.4 2001/06/04 10:07:53 matt Exp $

package AxKit::XSP::Exception;

use strict;
use Apache::AxKit::Language::XSP;

use vars qw/@ISA $NS $VERSION $ForwardXSPExpr/;

@ISA = ('Apache::AxKit::Language::XSP');
$NS = 'http://axkit.org/NS/xsp/exception/v1';

$VERSION = "1.4";

sub parse_char {
    my ($e, $text) = @_;

    return '';
}

sub parse_start {
    my ($e, $tag, %attribs) = @_;
    
    if ($tag eq 'try') {
        return 'eval {'
    }
    elsif ($tag eq 'catch') {
        $e->manage_text(0);
        return '}; if ($@) { my $exception = $@;'
    }
    elsif ($tag eq 'message') {
        $e->start_expr($tag);
	return '';
    }
    else {
        die "Unknown exceptions tag: $tag";
    }
}

sub parse_end {
    my ($e, $tag) = @_;
    
    if ($tag eq 'try') {
        return '};';
    }
    elsif ($tag eq 'catch') {
        return '';
    }
    elsif ($tag eq 'message') {
        $e->append_to_script('$exception');
        $e->end_expr();
	return '';
    }
}

1;
__END__

=head1 NAME

AxKit::XSP::Exception - Exceptions taglib for eXtensible Server Pages

=head1 SYNOPSIS

Add the sendmail: namespace to your XSP C<<xsp:page>> tag:

    <xsp:page
         language="Perl"
         xmlns:xsp="http://apache.org/xsp/core/v1"
         xmlns:except="http://axkit.org/NS/xsp/exception/v1"
    >

And add this taglib to AxKit (via httpd.conf or .htaccess):

    AxAddXSPTaglib AxKit::XSP::Exception

=head1 DESCRIPTION

Allows you to catch exceptions thrown by either your own code, or other
taglibs.

=head1 EXAMPLE

This example shows all the tags in action:

  <except:try>
   <mail:send-mail>...</mail:send-mail>
   <except:catch>
    <p>An Error occured: <except:message/></p>
   </except:catch>
  </except:try>

=head1 AUTHOR

Matt Sergeant, matt@axkit.com

=head1 COPYRIGHT

Copyright (c) 2001 AxKit.com Ltd. All rights reserved. This program is
free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=head1 SEE ALSO

AxKit

=cut
