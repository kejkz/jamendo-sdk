# Ruby Jamendo SDK
_Library for easy accesing and using Jamendo API with Ruby_  

**API source documentation**: <http://developer.jamendo.com/v3.0/>  
**Licence**: Open Source  

## Description

This is Ruby-based API handler for Jamendo music library. Started as a fun, and will stay fun. I am currently attemping to learn as much Ruby as I can, and this will provide me some interesting moments 

## Usage

Usage is quite simple, all you have to do is initialize Jamendo with your client id string that you can obtain from Development portal <https://devportal.jamendo.com/> and start kicking. Initialize a new request object like this:

    j = JamendoRequests(your_client_id)
    
Then you can use any of read only methods that Jamendo provide. After that, it's only a question of creating hash with values you are interested in:
    
    h = { artist_name: "look for gold"}

Then just send request:

    j.artist(h)
 
You will get hash containing only query results. Since there are lots and lots of options for fine search on Jamendo database, I'll create a little better handling of all options inside a new object that will hold everything that is possible together and that will be avare of what options to use in what situation.

## Coverage
Right now, coverage of all methods is not complete in any way, that's why my main focus will be to do one method at time, to provide best possible availabillity of all them to users.

## Planned features

* Support all Jamendo REST GET methods
* Add better parameters handling for easier coverage of  all Jamendo REST methods with a new class that returns hash that can be used for sending requests
* Support OAuth2 authorisation via Jamendo API site
* Support Jamendo PUT methods
* Implement helper methods for searching through database
* ~~Store responses in Jamendo-specific object that can use it's values to further search Jamendo database and returns a hash of values~~ __completed__
* Part downloader of Jamendo albums, files, whatever