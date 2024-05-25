package HotDogDataFetcher;

#Author: Eduardo Pexe
#Date: 05/25/2024
#Version: 0.1
#Package to get data from set url or file
#For API functions access /hdog/swagger.yml

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use JSON;

#Main constructor
sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

#Method to request/get data and return http status and content
#interact with /getdata endpoint

sub get_hotdog_data {
    my ($self, $url) = @_;

    my $status_http_request = "";
    my $content = "";

    # Send HTTP GET request and get response content
    ($status_http_request, $content) = $self->_send_get_request($url);
    #$content=encode_json($content);
    return ($status_http_request, $content);
}

#Method to request data/get from defined url
sub _send_get_request {
    my ($self, $url) = @_;

    my $status_http_request = "";
    my $content = "";

    # Create UserAgent
    my $ua = LWP::UserAgent->new;
    # Timeout of 10 seconds
    $ua->timeout(10); 

    my $request = HTTP::Request->new(GET => $url);

    # Send the request and get the response
    my $response = $ua->request($request);

    # Check Success https response status
    if ($response->is_success) {
        # Get Data content
        $content = $response->decoded_content;
    }

    #Get status from http request
    $status_http_request = $response->status_line;

    #return http status and content
    return ($status_http_request, $content);
}

#Method to request/get data, filter by status field with dinamic value defined in the endpoint and return http status and content
#interact with /status/{value} endpoint
sub get_status {
    my ($self, $url, $field, $value) = @_;
    my $filtered_string="";
    my @filtered_data;
    # Send HTTP GET request and get response content
    my ($status_code, $content) = $self->_send_get_request($url);

    # Check if the request was successful
    if ($status_code =~ /^200/) {
        # Decode the JSON content
        my $data = decode_json($content);

        # Filter the data by the specified field and value

        #Here I've a workaround to bug foun for value requested
        #When the endpoint get /status/requested the filter not works with variable $value
        #The workaround is filter by string "REQUESTED" when value = requested
        #For the other status the filter was tested and works fine
        #I lost a few strands of my hair with this bug : )

	if ($value=~/requested/){ 
		#$filtered_string="ver-".$value."\n";
        #Filter Data of the returned content: Workaround comparsion with string REQUESTED
	    @filtered_data = grep { $_->{$field} eq "REQUESTED" } @{$data};
	    #foreach my $item( @$data ) {
                 # fields are in $item->{Year}, $item->{Quarter}, etc.
		 #	 if ($item->{status}=~/REQUESTED/){
		 #$filtered_string.=$item->{status}."#S#S#";
		 #}
		 #else{
		 #$filtered_string.=$item->{status}."#N#$value#";
		 #}
		 #}
		 #$filtered_string.="ver-".$value."\n".scalar(@filtered_data);
	    #$filtered_string = join("\n", map { encode_json($_) } @filtered_data);
        }
	else{

        #Filter Data of the returned content: comparsion with $value
	    @filtered_data = grep { $_->{$field} eq $value } @{$data};            
	    #$filtered_string = join("\n", map { encode_json($_) } @filtered_data);
        }

        #Get total registers of the array filtered
        my $total_reg=scalar(@filtered_data);
        #insert total of register in the first position of the array
        unshift(@filtered_data,"total: $total_reg");	
	
        #encode array filtered with results in json standard
        
	    $data = encode_json(\@filtered_data);;
        
        #Return the filtered data
	    return $data;

    } else {
        # If the request was not successful, return an empty array reference
        return [];
    }
}

#Get data from swagger file to endpoint /swagger.yml
sub get_swagger {
    my ($self, $filename) = @_;

    #open file
    open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";
    #get data from file to string $swagger_str
    my $swagger_str = do { local $/; <$fh> };
    close($fh);

    #Return file swagger contaiment to endpoint  /swagger.yml
    return $swagger_str;
}

1;
