# Aiddata Robocoder


## TODO
- Try same tf ifd style, but with a frequency dictionary for each sector (educaton, health, multisector, etc). (Based on OECD sector from pre-coding)

## Hackathon - MTL Jan, 2014 
- Found some minor bugs in code: string cleaning was removing 'br' from any word: 'brown'
- Removed duplicate code.
- Found calculation problem with a +1 in tfid
- Changed algorithm from a tf ifd / code frequency hybrid to below algorithm.

## Curent algorithm
- Use pure tf ifd to calulcate most important words in pargraph
- For each important word get all of it's codes and their weights
- Aggregate all of the codes weights
- sort by aggregated weight
- return the heighest weighted codes.

## Databse Quick Guide
- words_index:  [word: [all codes where the word has shown up: # times this code has shown up for the word]]
- document_count: [word: # documents that word shows up in]
- max_count: [code: # of times the code shows up anywhere]

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
