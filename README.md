# Ruby Jamendo SDK
_Library for easy accesing and using Jamendo API with Ruby_  

**API source documentation**: <http://developer.jamendo.com/v3.0/>  
**Licence**: Open Source  
**version**: 0.1.9

## Description

This is Ruby-based API handler for Jamendo music library. Started as a fun, and will stay fun. I am currently attemping to learn as much Ruby as I can, and this will provide me some interesting moments 

## Usage

Usage is quite simple, all you have to do is initialize Jamendo with your client id string that you can obtain from Development portal <https://devportal.jamendo.com/> and start kicking. Initialize a new request object like this:

    j = JamendoRequests(your_client_id)
    
Then you can use any of read only methods that Jamendo provide. After that, it's only a question of creating hash with values you are interested in:
    
    h = { artist_name: "look for gold"}

Then just send request:

    j.artist(h)
 
You will get hash containing only query results. It is also possible to use class JamendoParameters for storing parameters as specific objects that will hold your parameters.

You can initialize it with or without additional parameters. Parameters are sent as a hash or as array. When sending hash, it will pair-match parameters as you would like, if you send array, it will use it's values to initialize object

	p = JamendoParameters(artist: 'frozen youghurt', id: 1234)

Then you can acces any parameter or change it by it's name, like:

	p.artist = 'pistacio'

You can also easily print them for an overview if needed. When you send JamendoParameters object to JamendoRequests, it will find out about it's class and convert all values to hash so that request to Jamendo can be created.

## Coverage
Right now, coverage of all methods is not complete in any way, that's why my main focus will be to do one method at time, to provide best possible availabillity of all them to users.

## Planned features
This is only a short list of things I am working on right now and succeding to some extent. There is no time-table for all features planned, but I am hoping that framework will be ready for consumption by the end of year.

* Support all Jamendo REST GET methods
* ~~Add better parameters handling for easier coverage of all Jamendo REST methods with a new class that returns hash that can be used for sending requests~~ __done__
* Support OAuth2 authorisation via Jamendo API site, since that is main feature missing from framework
* Support Jamendo PUT methods
* Implement helper methods for searching through database
* ~~Store responses in Jamendo-specific object that can use it's values to further search Jamendo database and returns a hash of values~~ __completed__
* Part downloader of Jamendo albums, files, whatever from their API
* Use responses sent from requests as a basis for new requests in an easily manner - convert responses to JamendoRequests directly
* Create a way to find out class of object that jamendo requester is sending
* Have a version Break classes to separate files