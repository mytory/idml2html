#!/usr/bin/perl
# use utf8;
use v5.14;
use strict;
use warnings;
no warnings 'experimental';
use feature qw/ say switch /;
use XML::Twig;
use Data::Dumper;
use Encode qw/ decode encode /;

my $twig=XML::Twig->new(  
  twig_handlers =>
    { 
      StoryPreference    => sub { $_->delete },
      InCopyExportOption => sub { $_->delete },
      Properties         => sub { $_->delete },
    },
  pretty_print => 'indented',                # output will be nicely formatted
  empty_tags   => 'html',                    # outputs <empty_tag />
);

my $elt = $twig->parsefile($ARGV[0])->root;

{	
	my %sty2tag = (	
		'ParagraphStyle/기사본문'          => { 'tag_name' => 'p' },
		'ParagraphStyle/Normal'          => { 'tag_name' => 'p' },
		'ParagraphStyle/소제목'            => { 'tag_name' => 'h3' },
		'ParagraphStyle/필자(일반)'        => { 'tag_name' => 'p' },
		'ParagraphStyle/필자(상단)'        => { 'tag_name' => 'p' },
		'ParagraphStyle/사진캡션(격자)'    => { 'tag_name' => 'p' },
		'ParagraphStyle/제목%3a제목설명(일반)'    => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a├ 제목설명(경계)' => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a└ 제목설명(박스)' => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a고딕제목/45pt'     => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a명조제목/38pt'     => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a고딕제목/30pt'     => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a명조제목/28pt'     => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a└ 명조제목/28pt/경계' => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a명조제목/21pt'         => { 'tag_name' => 'h1' },
		'ParagraphStyle/제목%3a└ 명조제목/21pt/경계' => { 'tag_name' => 'h1' },
		'ParagraphStyle/누구말일까요본문'   => { 'tag_name' => 'p' },
		'ParagraphStyle/특수본문%3a누구말일까요본문' => {'tag_name' => 'p' },
		'ParagraphStyle/특수본문%3a소제목 (박스)' => {'tag_name' => 'h3'},
		'ParagraphStyle/편집자주(앞)'       => { 'tag_name' => 'p' },
		'ParagraphStyle/편집자주(뒤)'       => { 'tag_name' => 'p' },
		'ParagraphStyle/인터뷰질문'         => { 'tag_name' => 'p' },
		'ParagraphStyle/인터뷰본문/탭문자'  => { 'tag_name' => 'p' },
		'ParagraphStyle/특수본문%3a본문 (첫글자크게)'  => { 'tag_name' => 'p' },
		'ParagraphStyle/소제목 (박스)'      => { 'tag_name' => 'p' },
		'ParagraphStyle/포럼 지역'          => { 'tag_name' => 'p' },
		'ParagraphStyle/포럼 주제'          => { 'tag_name' => 'p' },
		'ParagraphStyle/포럼 연사'          => { 'tag_name' => 'p' }, 
		'ParagraphStyle/포럼 일시'          => { 'tag_name' => 'p' },
		'ParagraphStyle/포럼 장소'          => { 'tag_name' => 'p' },
		'ParagraphStyle/포럼 참가비'        => { 'tag_name' => 'p' },
		'ParagraphStyle/포럼 연락처'        => { 'tag_name' => 'p' },
		'CharacterStyle/$ID/[No character style]' => { 'tag_name' => '' },
		'CharacterStyle/to me' => { 'tag_name' => '' },
		'CharacterStyle/기사본문강조' => { 'tag_name' => 'strong' },
		'CharacterStyle/필자직책' => { 'tag_name' => '' },
		'CharacterStyle/캡션제목' => { 'tag_name' => '' },
		'CharacterStyle/색상없음' => { 'tag_name' => '' },
		'CharacterStyle/작게' => { 'tag_name' => '' },
	);

	# sub flush {
	# 	say encode('UTF-8', "$buff\n") if $buff;
	# 	$buff ='';
	# }

	sub openTag {
		my $sty   = shift;
		   $sty   = encode('UTF-8',$sty);
		my $data  = $sty2tag{$sty} or return '';

		return '' unless $data->{'tag_name'};

		my $attr = '';
		for my $name ( keys %{$data->{'attr'}} ) {
			$attr .= " $name=\"$data->{'attr'}->{'$name'}\" ";
		}
		return
			'<'
				.$data->{'tag_name'}
				.$attr
				.'>';
	}

	sub closeTag {
		my $sty   = shift or return '';
		   $sty   = encode('UTF-8',$sty);
		my $data  = $sty2tag{$sty} or return '';
		return '' unless $data->{'tag_name'};
		return
			'</'
				.$data->{'tag_name'}
				.'>';
	}


	my $buff = '';
	# select BUFF;

	my ($pStat, $cStat) = '';
	my $has_content = 0;

	sub set_has_content   { $has_content = 1; }
	sub unset_has_content { $has_content = 0; }
	sub flush {
		$buff =~ s/\x{2028}//g;
		print STDOUT encode('utf8', $buff) if $has_content;
		$buff = "";
	}

	while ( $elt = $elt->next_elt($twig->root) ) {
		given ($elt->gi) {
			when ('ParagraphStyleRange') {
				my $current = $elt->att('AppliedParagraphStyle');

				# on new ParagraphStyle
				if ($current ne $pStat) {

					# end previous states
					$buff .= closeTag($cStat);
					$buff .= closeTag($pStat)."\n" . "\n";

					flush();
					unset_has_content();

					# start new state and reset lower level states
					$buff .= openTag($current);
					$cStat = '';

					# set current paragraph state
					$pStat = $current;
				}
			}
			when ('CharacterStyleRange') {
				my $current = $elt->att('AppliedCharacterStyle');

				# on new CharacterStyle
				if ( $current ne $cStat) {
					$buff .= closeTag($cStat).openTag($current);
					$cStat = $current;
				}
			}
			when ('Br') {
				
				$buff .= closeTag($cStat);
				$buff .= closeTag($pStat)."\n". "\n";
				flush();
				unset_has_content();

				$buff .= openTag($pStat);
			}
			when ('#PCDATA') {
				set_has_content();
				$buff .= $elt->text;
			}
			default {

			}
		}
	}
	$buff .= closeTag($pStat);	
	flush();
}

#$twig->print;