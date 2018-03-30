#!/usr/bin/perl

#prequisites:
#https://docs.woocommerce.com/document/woocommerce-rest-api/
#read
#https://perlmaven.com/array-references-in-perl

#modules
use strict;
use LWP::UserAgent;
use LWP::Simple;
use HTTP::Request::Common;
use JSON qw( decode_json );
#optional
use Data::Dumper;

#global variables
my $orders = "https://your.woocommerce.site";
my $consumer_key = "RESTAPI KEY";
my $consumer_secret = "RESTAPI SECRET";

#user agent object
my $ua = LWP::UserAgent->new;
   $ua->ssl_opts(verify_hostname => 0);
   $ua->default_header('Content-Type' => "application/json");

#request object
my $req = GET $orders;
   $req->authorization_basic($consumer_key, $consumer_secret);

#requesting Json trough user agent
my $response = $ua->request($req);

#decoding Json
my $json = JSON->new;
my $names_ref = $json->decode($response->content());
 
# $name_ref is an array reference.
# printing it will not print it's content
print "Example:\narray reference:\n$names_ref\n\n";         # ARRAY(0xABCDEF)
# if you want to print it, use the perl dumper
print "Dumper:\n".Dumper( $names_ref );


#Getting items within the array reference
#known increment
print "\nfixe: \n" ;
if (@$names_ref) { # @a is not empty...
   print "@{ $names_ref }[0]->{status}\n";   
   print "@{ $names_ref }[0]->{shipping}->{city}\n";   

} else { # @a is empty
   print "array is empty\n";
}

#looping through the array
print "\nloop: \n";
for(@$names_ref) { 
   print "$_->{status}\n";
   print "$_->{shipping}->{city}\n";
   
   #If you need to loop through subitems
   #NOTE this may depend on your woocommerce implemetation
   for ( @{$_->{line_items}} ) {
      print "$_->{name}\n";

      for ( @{$_->{meta_data}} ) { 
          print "$_->{key} : $_->{value}\n";
      }
   }  
}
