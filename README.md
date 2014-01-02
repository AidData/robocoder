# Aiddata Robocoder

## TODO

Improve API so you can send an array of descriptions and receive an array of results.

## How can I use it? (Short Version)

send a POST request to 'robocode.adamfrey.me/classify.json' with a 'description'
parameter that holds the total project description.

receive a JSON array holding the relevant codes for that description

```
[{"name": "Explosive Mine Removal", "number": 1525001, "formatted_number":"15250.01"},...]
```

## What it does

At Aiddata, our research assistants currently do a ton of project
classification. They look at project records, focusing on the project title and
short and long descriptions. Finding a reasonable way to automate some of this
classification would free up some time that the research assistants can use on
other projects as well as increase the amount of classification work we can
complete and present. 

Recognizing this, Aiddata has already put in place a coding scheme called Code
By Rule, wherein if the system determines that a project's description is
exactly the same as another project which has already been coded, then it should
be given the same codes. So using Code By Rule, before a project is given to
humans, it's title, short description, and long description are concatenated
together into one string and then that string is hashed using MD5. If that hash
matches a previously coded hash, then the codes are applied automatically.

Robocoder adds to Code By Rule by providing suggested codes for projects that
aren't matched using Code By Rule. So if we don't have an exact match for
a project, Robocoder will suggest some codes that it finds to be relevant. This
means that we can effectively do some sort of automated coding for all projects.

## How it works

To build its prediction engine, Robocoder draws from all of the activity coding
that has been previously done at Aiddata by humans. Robocoder's backend is
a Mongo database which is the heart of its suggestion engine. I went through
every project coded by Aiddata, and split up the titles and descriptions into
individual words. I then stored information about in which codes each word
showed up. I documented this database creation process in a blog post
[here](http://adamfrey.me/2013/07/05/tf-idf-part-one/)

So, when Robocoder is given a description and tasked with guessing codes, it
first breaks down the given description into individual words. Then it
calculates for each word which codes are most applicable and sums the results.
In the end you get a list of codes in the order that Robocoder's algorithm
determines them to be most relevant. Then there is additional filtering to make
sure that at one and only one purpose code is returned and only a reasonable
amount of activity codes are returned.


## How can I use it? (Long Version)

Right now Robocoder is live at
[robocode.adamfrey.me](http://robocode.adamfrey.me).  If you want to send more
than a couple projects to Robocoder, you'll want to write a computer program
that sends the descriptions without copying and pasting. In order to do this,
you'll have to send an HTTP POST request to robocode.adamfrey.me/classify.json.

Here's a little primer on HTTP if you're not sure what that last sentence meant:
HTTP is the protocol that powers the web, and allows you to get data and view
websites with your browser everyday. Your browser communicates with web site
servers using "requests", and there several different kinds of requests for
different purposes. The most common kind of request is called a GET request.
Every time you "go to a website" by typing 'aiddata.org' or any other URL into
your browser and hitting enter, your browser is sending a GET request. The
distinguishing feature of a GET request is that you are only receiving data, not
giving any. The data being received is the web page you are trying to view.

The next most common kind of request is called a POST request. This is sort of
the opposite of a GET request. When you send a POST request you are requesting
the web server hold some data that you are sending from the browser. POST
requests are used every time you fill out and submit a form online. You are
sending your input from your web browser to the server, for the server to deal
with, whether it will use your input to do a google search or place a pizza
order.

There are tools to send HTTP requests that aren't browsers, that you can build
into a program.  Every modern language has an HTTP library that you can use to
send requests, or you could even use a simple tool like
[Curl](http://curl.haxx.se/). 

So when you are trying to get Robocoder you should send POST requests to the
robocode.adamfrey.me/classify.json. POST requests can hold 'request parameters',
the data you are sending to the server. To send a project description to
Robocoder, you have to send the request along with the whole description in
a parameter called 'description'. You have to remember to add the '.json' suffix
to the end of the url so that Robocoder will return the correct JSON format. It
will look like this:
```
[{"name": "Explosive Mine Removal", "number": 1525001, "formatted_number":"15250.01"},...]
```
