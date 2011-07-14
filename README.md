Address Book (vCard) Cleaner Script
==================================

Motivation
-----------

I accidentally synched my Gmail contacts into my iPhone. This meant every person I EVER emailed was in there. Even Craigslist emails,etc. This was the same in my Mac's Address Book.                                                                         
Secondly, it really,really bugs me that Address Book cannot automatically merge people with the same name.    

Features
----------

Currently, it only supports deleting vCard entries that match one of the following rules:

1) No phone present
2) No email present
3) No phone or email present

I am going to work on merging contacts that have the same name downcased or something like that.
              
Requirements
------------

1) Wonderful 'highline' gem (http://github.com/JEG2/highline).
2) Even more wonderful to make it possible 'vpim' gem (http://rubyforge.org/projects/vpim).

Use
------------
1) Export ALL your contacts as a single vCard file. This will also act as your backup. KEEP IT!
2) run script providing exported vCard path and file name as single argument. You should probably quote it in case you have funky paths.
3) Follow instructions.
4) Delete all contacts in Address Book.
5) Import from newly created vCard file that is in the same directory as your input file.
