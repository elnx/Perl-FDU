package My_Complex;
use strict;
use overload
	'+' => 'plus',
	'-' => 'minus',
	'*' => 'multiple',
	'/' => 'divide',
	'""' => 'output',
	'abs' => 'absolute',
	'=' => 'clone',
	'==' => 'cmp';

sub new {
	my $proto = shift;
	my $type = ref($proto) || $proto;
	my($re, $im) = @_;
	$re = 0 if not $re;
	$im = 0 if not $im;
	my $this = {re=>$re, im=>$im};
	bless $this, $type;
}

sub re {
	my $this = shift;
	$this->{re} = shift if (@_);
	$this->{re};
}

sub im {
	my $this = shift;
	$this->{im} = shift if (@_);
	$this->{im};
}

sub clone {
	my $self = shift;
	my $proto = shift;
	my $type = ref($proto);
	if ($type eq 'My_Complex') {
		$self->re($proto->re());
		$self->im($proto->im());
	} else {
		$self->re($proto);
		$self->im(0);
	}
}

sub plus {
	my $self = shift;
	my $proto = shift;
	my $type = ref($proto);
	if ($type eq 'My_Complex') {
		my $re = $self->re() + $proto->re();
		my $im = $self->im() + $proto->im();
		bless $self->new($re, $im), $type;
	} else {
		my $re = $self->re() + $proto;
		my $im = $self->im();
		bless $self->new($re, $im), 'My_Complex';
	}
}

sub minus {
	my $self = shift;
	my $proto = shift;
	my $type = ref($proto);
	if ($type eq 'My_Complex') {
		my $re = $self->re() - $proto->re();
		my $im = $self->im() - $proto->im();
		bless $self->new($re, $im), $type;
	} else {
		my $re = $self->re() - $proto;
		my $im = $self->im();
		bless $self->new($re, $im), 'My_Complex';
	}
}

sub multiple {
	my $self = shift;
	my $proto = shift;
	my $type = ref($proto);
	if ($type eq 'My_Complex') {
		my $re = $self->re() * $proto->re() - $self->im() * $proto->im();
		my $im = $self->re() * $proto->im() + $self->im() * $proto->re();
		bless $self->new($re, $im), $type;
	} else {
		my $re = $self->re() * $proto;
		my $im = $self->re() * $proto;
		bless $self->new($re, $im), 'My_Complex';
	}
}

sub divide {
	my $self = shift;
	my $proto = shift;
	my $type = ref($proto);
	if ($type eq 'My_Complex') {
		my $num1 = $self->re() * $proto->re() + $self->im() * $proto->im();
		my $num2 = $self->im() * $proto->re() - $self->re() * $proto->im();
		my $den = $proto->re() ** 2 + $proto->im() ** 2;
		bless $self->new($num1/$den, $num2/$den);
	} else {
		bless $self->new($self->re()/$proto, $self->im()/$proto), 'My_Complex';
	}
}

sub output {
	my $this = shift;
	my $re = $this->re();
	my $im = $this->im();
	my $str = "($re + $im" . "i)";
	return $str;
}

sub absolute {
	my $this = shift;
	return ($this->re())**2 + ($this->im())**2;
}

sub cmp {
	my $self = shift;
	my $proto = shift;
	my $type = ref($proto) || $proto;
	if ($type eq 'My_Complex') {
		return ($self->re() eq $proto->re() and $self->im() eq $proto->im());
	} else {
		return ($self->re() eq $proto and $self->im() eq 0);
	}
}

sub conjugate {
	my $this = shift;
	return $this->new($this->re(), 0 - $this->im())
}

1;