#!/usr/bin/perl

#Author: Eduardo Pexe
#Date: 05/25/2024
#Version: 0.1
#Instructions for execution:
#execute the command: perl /hdog/api_hotdog.pl #IpServer #http_port_server
#Example: perl /hdog/api_hotdog.pl 127.0.0.1 8080
#For API functions access /hdog/swagger.yml

use strict;
use warnings;
use HTTP::Server::Simple::CGI;
use CGI;
use lib '/hdog';
use HotDogDataFetcher;

# Define a subclass of HTTP::Server::Simple::CGI
package HotDogAPI;
use base qw(HTTP::Server::Simple::CGI);

#URL to get data
my $url_to_get_data='https://data.sfgov.org/resource/rqzj-sfat.json';
#IP Address from API Server
my $myipserver = $ARGV[0];
#http port from API Server
my $http_port = $ARGV[1];


# Hash table to map request paths to handler functions
my %handlers = (
    '/welcome'    => \&handle_welcome,
    '/getdata'    => \&handle_getdata,
    '/swagger.yml' => \&handle_swagger,
    qr{/status/(.+)} => \&handle_status,
);

# Override the handle_request method to handle incoming requests
sub handle_request {
    my ($self, $cgi) = @_;

    # Parse the request URI to determine the endpoint
    my $uri_path = $cgi->path_info();

    # Search for the correct handler 
    my $handler;
    for my $key (keys %handlers) {
        if ($uri_path =~ $key) {
            $handler = $handlers{$key};
            last;
        }
    }

    # If a handler function is found, call it with the CGI object and matched parts
    if ($handler && ref($handler) eq 'CODE') {
        $handler->($cgi, $1);  # Pass the capture group to the handler
    } else {
        # Otherwise, return a 404 Not Found response
        print "HTTP/1.0 404 Not Found\r\n";
        print "Content-Type: text/plain\r\n\r\n";
        print "404 Not Found - Endpoint not found\n";
    }    
}

# Handler function for the /welcome endpoint
sub handle_welcome {
    my ($cgi) = @_;
    print "HTTP/1.0 200 OK\r\n";
    print "Content-Type: text/plain\r\n\r\n";
    print "Welcome To HotDog API!!!\n by Eduardo Pexe\n eduardopexe21\@gmail.com \n https://github.com/eduardopexe/ \n https://www.linkedin.com/in/eduardo-p-13015a240/ \n http://www.sorocaba.online:8080/netmon/ [ under construction : ) ] \n";
}


# Handler function for the /getdata endpoint
# return all data in original API

sub handle_getdata {
    my ($cgi) = @_;

    # Create instance of HotDogDataFetcher
    my $fetcher = HotDogDataFetcher->new();

    # Get JSON data
    my ($status, $json_data) = $fetcher->get_hotdog_data($url_to_get_data);

    # Check if data retrieval was successful
    if ($status =~ /200 OK/) {
	print "HTTP/1.0 200 OK\r\n";
	#print "Content-Type: text/plain\r\n\r\n";   
	print "Content-Type: application/json\r\n\r\n";
    # Decode JSON data to a Perl data structure
	#my $data = decode_json($json_data);
    # Re-encode the Perl data structure to JSON
	#my $output_json = encode_json($data);
    #print $status."-".$url_to_get_data."\n";
	print $json_data;
    } else {
        print "HTTP/1.0 500 Internal Server Error\r\n";
        print "Content-Type: text/plain\r\n\r\n";
        print "Failed to retrieve data\n";
    }
}

# Handler function for the /status/{value} endpoint
# return the total of found register in field total 

sub handle_status {
    my ($cgi, $status_value) = @_;
    #$status_value = $cgi->path_info()=~m/\/status\/(.+)/;
    #Workaround to solve problems to get $status_value
    $status_value = ($cgi->path_info() =~ m|/status/(.+)|)[0];
    # Create instance of HotDogDataFetcher
    my $fetcher = HotDogDataFetcher->new();

    # Get filtered JSON data by status
    my $filtered_data_json = $fetcher->get_status($url_to_get_data, "status" ,$status_value);

    if ($filtered_data_json) {
        print "HTTP/1.0 200 OK\r\n";
	    #print "Content-Type: text/plain\r\n\r\n";
	    print "Content-Type: application/json\r\n\r\n";
	    #print $cgi->path_info();
	    #my $j = json_decode($filtered_data_json);
	    #print "###".$status_value."#$f#$v#\n";
	    print $filtered_data_json;
    } else {
        print "HTTP/1.0 500 Internal Server Error\r\n";
        print "Content-Type: text/plain\r\n\r\n";
        print "Failed to retrieve data\n";
    }
}

# Handler function for the /swagger endpoint
# Get data from file swagger.yml and return in the endpoint

sub handle_swagger {
    my ($cgi) = @_;
    my $filename = 'swagger.yml';

    # Create instance of HotDogDataFetcher
    my $fetcher = HotDogDataFetcher->new();

    # Get JSON data
    my $json_data = $fetcher->get_swagger($filename);
    print "HTTP/1.0 200 OK\r\n";
    #print "Content-Type: text/plain\r\n\r\n";
    print "Content-Type: application/json\r\n\r\n";
    print $json_data;
}

### Create a new instance of HotDogAPI and start the server
my $server = HotDogAPI->new($http_port);
$server->host($myipserver);
#Run app in background
#To stop server is necessary kill the PID.

my $pid = $server->background;
print "Use 'kill $pid' to stop server.\n";
