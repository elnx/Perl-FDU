$exp = "12*5+55+(4*3+2)*(2+44*(5+1))";
$c = CALC->new($exp);
$m = $c->calc();
$n = eval($exp);
print "$m == $n\n";
if ($m== $n ){
    print "Same\n";
}
 
package CALC;
use Data::Dump qw(dump);
sub new{
    my ($self, $exp) = @_;
    my $mem = calcsplit($exp);
    $mem->{-tree} = buildtree($mem);
    bless $mem, $self;
}
sub calcsplit{
    my $exp = shift;
    my %mem;
    my $t = $exp;
    my %pri = ('+' => 1, 
               '*' => 4);
    $mem{-op} = [];
    $mem{-pri} = [];
    $mem{-data} = [];
    my $pri = 0;
    while (1) {
        if ($t=~ /^([\+\-\*\/])/g)
        {
            push @{$mem{-op}},  $1;
            push @{$mem{-pri}}, $pri + $pri{$1};
            $p = pos $t;
            $t = substr($t, $p, length($t) - $p);
            next;
        }
        elsif ($t =~ /^(\(*)(\d*\.?\d+)(\)*)/g){
            $pri += 10*(length($1)) if $1;
            push @{$mem{-data}}, $2;
            $pri -= 10*(length($3)) if $3;
            $p = pos $t;
            $t = substr($t, $p, length($t) - $p);
            next;
        }
        last;
    }
    return \%mem;
}
sub buildtree {
    my $mem = shift;
    my $cur =[];
    my @stack;
    $cur->[0] = $mem->{-op}->[0];
    $cur->[1] = $mem->{-data}->[0];
    AA: for my $i(1..$#{$mem->{-pri}}){
        if ($mem->{-pri}[$i] > $mem->{-pri}[$i-1]) {
            push @stack, [$cur, $mem->{-pri}[$i-1]];
            $cur = [];
            $cur->[0] = $mem->{-op}->[$i];
            $cur->[1] = $mem->{-data}->[$i];
        }
        else {
            push @$cur, $mem->{-data}->[$i];
            if ($mem->{-pri}[$i] == $mem->{-pri}[$i-1] && 
                $mem->{-op}[$i] eq $mem->{-op}[$i-1]) {
                next;
            }
            while ($#stack >= 0){
                my( $scur, $pri) = @{$stack[$#stack]};
                if ($mem->{-pri}[$i] <= $pri) {
                    push @$scur, $cur;
                    $cur = $scur;
                    pop @stack;
                    if ($mem->{-pri}[$i] == $pri && 
                        $mem->{-op}[$i] eq $scur->[0]){
                        next AA;
                    }
                    next if ($#stack >= 0);
                }
                last;
            }
            $cur = [$mem->{-op}->[$i], $cur];
        }
    }
    push @$cur, $mem->{-data}->[$#{$mem->{-data}}];
    while ($#stack >= 0){
        my( $scur, $pri) = @{$stack[$#stack]};
        pop @stack;
        push @$scur, $cur;
        $cur = $scur;
    }
    return $cur;
}
 
sub _calc{
    my $tree = shift;
    my @m;
    my $res;
    for my $i(1..$#{$tree}){
        if (ref $tree->[$i]) {
            push @m, _calc($tree->[$i]);
        }
        else {
            push @m, $tree->[$i];
        }
    }
    $res = $m[0];
    if ($tree->[0] eq '+'){
        grep{$res += $_} @m[1..$#m];
    }
    elsif ($tree->[0] eq '*'){
        grep{$res *= $_} @m[1..$#m];
    }
    $res;
}
 
sub calc{
    my $self = shift;
    dump($self->{-tree});
    _calc($self->{-tree});
}