package Bric::App::Callback::Alert;

use base qw(Bric::App::Callback);
__PACKAGE__->register_subclass;
use constant CLASS_KEY => 'alert';

use strict;
use Bric::App::Session qw(:user);
use Bric::App::Util qw(:all);
use Bric::Util::Alerted;

my $class = get_package_name('recip');
my $disp_name = get_disp_name(CLASS_KEY);
my $msg_redirect;

sub ack : Callback {
    my $self = shift;
    my $ids = mk_aref($self->request_args->{'recip_id'});
    $msg_redirect->($ids);
}

sub ack_all : Callback {
    my $self = shift;
    my $ids = $class->list_ids({ user_id => get_user_id(), ack_time => undef });
    $msg_redirect->($ids);
}


$msg_redirect = sub {
    my $ids = shift;
    $class->ack_by_id(@$ids);
    my $c = @$ids;
    add_msg("[quant,_1,$disp_name] acknowledged.", $c) if $c;
    set_redirect(last_page());
};


1;
