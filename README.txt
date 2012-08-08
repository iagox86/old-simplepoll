Poll.pl
-The Simplest Poll Ever

Created by: Ron (umbowes1@cc.umanitoba.ca)
Last modified: 01/30/2001

To use this, simply copy all the files except this one into
one directory, and set the permissions as follows:

line.jpg	Default (don't change it)
poll.dat	640
poll.pl		755
polladmin.pl	755
questions.dat	640
rgb.gif		Default
subs.pl		Default

Run poll.pl to view the poll.  

To make changes to the poll, click on "Admin Only."  The default password 
is "ghost" (lowercase), and the username is simply there to trick hackers,
it serves no real purpose.

To change the password (which I strongly recommend doing as soon as you
install it), fill out the "Change Password" section at the bottom of 
the polladmin login.  

The setting for the poll are pretty much self-explanitory, and they can be
set to blank for default settings, and it is really easy to play with
different settings until you have it just right.  

The option to change the questions is also on the settings page, between the
table formatting and the preview.  If you are finished with the poll and wish
to start a new poll, you should click "Erase Results/IP Log", which will
allow people who've already voted to vote again.  

To incorperate the table into another web page, use a server-side-incluse (SSI),
which might look like this:
<!--#include virtual="/poll/poll.pl"-->
When the user submits the poll for the first time, a blank page will come 
up with just the table.  After that, whenever they load the page, instead of
getting the choices they will get the results page instead.  

If you have any questions, comments, etc. please feel free to email me at 
iago@d2backstab.com

Disclaimer: The code in this project is given as-is without any warranties
or guarentees.  If you modify this code and find an easier/more efficient/
more user-friendly version of this code, please email me and send the new 
code and a description, I'm always happy to learn more!

