# Aiddata Robocoder

## TODO
 * Check if there are lots of filler words in dictionary db: 'the' 'is' etc.
 * Try biasing towards the sector code.


## How can I use it? (Short Version)

send a POST request to 'robocode.adamfrey.me/classify.json' with a 'description'
parameter that holds the total project description.

receive a JSON array holding the relevant codes for that description

```
[{"name": "Explosive Mine Removal", "number": 1525001, "formatted_number":"15250.01"},...]
```

## What it does

Activity Coding is the process of coding Aid projects at a very granular level, such as 'rural primary education', instead of just 'education'.
At AidData, researcher assistants currently do the activity coding of aid projects manually.
This process yields high quality codings, but is very slow.
Using the project title and short and long descriptions and the historical data of previously coded projects Robocoder hopes to automate the process of coding.


## How it works

Robocoder used all historical data from previously coded projects and built a dictionary of all the words. Each word had the codes it shows up in associated with it. (Stored in a mongo DB)

I documented this database creation process in a blog post
[here](http://adamfrey.me/2013/07/05/tf-idf-part-one/)

So, when Robocoder is given a description and tasked with guessing codes, it
first breaks down the given description into individual words. Then it
calculates for each word which codes are most applicable and sums the results.
In the end you get a list of codes in the order that Robocoder's algorithm
determines them to be most relevant. Then there is additional filtering to make
sure that at one and only one purpose code is returned and only a reasonable
amount of activity codes are returned.


## How can I use it? (Long Version)

* Clone the repo
* Setup the rails app
* Check your local rails server to make sure its up and running. (You'll see a robocoder UI)
* Send a POST or GET request to '[local-rails-server]/classify.json' with a 'description' parameter that holds the total project description.
* You have to remember to add the '.json' suffix
* Response will look like this:
```
[{"name": "Explosive Mine Removal", "number": 1525001, "formatted_number":"15250.01"},...]
```
