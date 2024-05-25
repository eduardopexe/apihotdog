# apihotdog
## A Simple API to get data from Mobile Food Data of San Francisco City

## Hot Dog API
### Overview
### The Hot Dog API provides access to hot dog permit data in JSON format.

## Installation
### Install the required CPAN modules:

#### cpan install LWP::UserAgent HTTP::Request JSON
#### Clone the repository to your local machine:

git clone https://github.com/eduardopexe/hdog.git](https://github.com/eduardopexe/apihotdog.git
## Navigate to the project directory:

### cd apihotdog/hdog
### Usage
### Starting the Server
### Run the API server script with the desired IP address and HTTP port:

### Example: perl api_hotdog.pl 127.0.0.1 8081

## Testing the API
### To test the API on our online test server using DNS:

### http://sorocaba.online:8081/welcome

### http://sorocaba.online:8081/status/SUSPEND
### You can replace SUSPEND with other status values like EXPIRED, APPROVED, ISSUED, or REQUESTED.

### To test the API via IP address:

#### Example online by ip address
#### http://154.38.173.150:8081/status/requested
####Replace requested with the desired status value.

### Example online by site sorocaba.online
### Retrieve all data
#### http://sorocaba.online:8081/status/SUSPEND

#### Filter data by status (e.g., EXPIRED)
#### http://sorocaba.online:8081/status/expired

## Swagger Documentation
### Swagger documentation for the API endpoints is available at:

### Swagger Online
#### http://sorocaba.online:8081/swagger.yml

## HotDogDataFetcher Module
#### The HotDogDataFetcher.pm module provides functions to fetch data from web sources or files.


## License
This project is licensed under the MIT License. See the LICENSE file for details.


### Visit our other project [under construction]
#### Django Tests
#### Check out our Django tests at:

##### http://www.sorocaba.online:8080/netmon/
