package RT::Action::NotifyGroup;
use strict;

our $VERSION = '0.01';

=head1 NAME

RT::Action::NotifyGroup - RT Action that sends notifications
to groups and/or users

=head1 DESCRIPTION

RT action module that allow you to notify particular groups and/or users.
Distribution is shipped with C<rt-notify-group-admin> script that
is command line tool for managing NotifyGroup scrip actions. For more
more info see its documentation.

=head1 INSTALL

	perl Makefile.PL
	make
	make install

=cut

use base qw(RT::Action::Notify);

=head1 METHODS

=head2 SetRecipients

Sets the recipients of this message to Groups or Users.

=cut

sub SetRecipients
{
	my $self = shift;

	require Storable;
	my @args = eval { @{ Storable::thaw( $self->Argument ) } };
	if( $@ ) {
		$RT::Logger->error( "Storable couldn't thaw argument: $@" );
		return;
	}

	my (@To, %seen);
	foreach my $r ( @args ) {
		if( $r->{Type} =~ /^User$/io ) {
			$self->_HandleUserArgument( $r->{'Instance'} );
		} elsif( $r->{Type} =~ /^Group$/io ) {
			$self->_HandleGroupArgument( $r->{'Instance'} );
		} else {
			$RT::Logger->error( "Unknown type '". ($r->{Type}||'') ."'" );
		}
	}

	my $creator = $self->TransactionObj->CreatorObj->EmailAddress();
	unless( $RT::NotifyActor ) {
		@{ $self->{'To'} } = grep ( !/^$creator$/, @{ $self->{'To'} } );
	}

	$self->{'seen_ueas'} = {};

	return 1;
}

sub __PushUserAddress
{
	my $self = shift;
	my $uea = shift;
	push( @{ $self->{'To'} }, $uea ) unless( $self->{'seen_ueas'}{ $uea }++ );
	return;
}

sub _HandleUserArgument
{
	my $self = shift;
	my $instance = shift;
	
	my $user = RT::User->new( $RT::SystemUser );
	$user->Load( $instance );
	unless( $user->id ) {
		$RT::Logger->error( "Couldn't load user '$instance'" );
		return;
	}
	$self->__HandleUserArgument( $user );
}

sub __HandleUserArgument
{
	my $self = shift;
	my $obj = shift;
	
	my $uea = $obj->EmailAddress;
	unless( $uea ) {
		$RT::Logger->warning( "User #". $obj->id ." has no email address" );
		return;
	}
	$self->__PushUserAddress( $uea );
}

sub _HandleGroupArgument
{
	my $self = shift;
	my $instance = shift;
	
	my $group = RT::Group->new( $RT::SystemUser );
	$group->LoadUserDefinedGroup( $instance );
	unless( $group->id ) {
		$RT::Logger->error( "Couldn't load group '$instance'" );
		next;
	}

	my $members = $group->UserMembersObj;
	while( my $m = $members->Next ) {
		$self->__HandleUserArgument( $m );
	}
}

=head1 AUTHOR

	Ruslan U. Zakirov
	cubic@wildgate.miee.ru

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with perl distribution.

=head1 SEE ALSO

RT::Action::NotifyGroupAsComment, rtx-notify-group-admin

=cut

1;
