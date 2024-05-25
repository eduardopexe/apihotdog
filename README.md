# apihotdog
A Simple API to get data from Mobile Food Data of San Francisco City

Hot Dog API
Overview
The Hot Dog API provides access to hot dog permit data in JSON format.

Installation
Install the required CPAN modules:

arduino
Copiar código
cpan install LWP::UserAgent HTTP::Request JSON
Clone the repository to your local machine:

bash
Copiar código
git clone https://github.com/yourusername/hdog.git
Navigate to the project directory:

bash
Copiar código
cd hdog
Usage
Starting the Server
Run the API server script with the desired IP address and HTTP port:

yaml
Copiar código
perl api_hotdog.pl 127.0.0.1 8081
Testing the API
To test the API on the test server using DNS:

bash
Copiar código
http://sorocaba.online:8081/status/SUSPEND
You can replace SUSPEND with other status values like EXPIRED, APPROVED, ISSUED, or REQUESTED.

To test the API via IP address:

Example online by ip address
http://154.38.173.150:8081/status/requested
Replace requested with the desired status value.

Example online by site sorocaba.online
bash
# Retrieve all data
curl http://sorocaba.online:8081/status/SUSPEND

# Filter data by status (e.g., EXPIRED)
curl http://154.38.173.150:8081/status/requested
Swagger Documentation
Swagger documentation for the API endpoints is available at:

Swagger
http://127.0.0.1:8081/swagger.yml
HotDogDataFetcher Module
The HotDogDataFetcher.pm module provides functions to fetch data from web sources or files.

#Visit our other project [under construction]
Django Tests
Check out our Django tests at:

bash
http://www.sorocaba.online:8080/netmon/

License
This project is licensed under the MIT License. See the LICENSE file for details.
