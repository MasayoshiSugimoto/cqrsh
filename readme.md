CQRSH
=====


Introduction
------------

CQRSH is an experiment of a tictactoe implementation using CQRS pattern in bash.

My intent was to push bash to it's limit and check if it is a viable option. The rational behind this is the fact that files are first class citizen so the event repository is basically free.

The program has been tested on Mac only since it is the only computer I have at hand currently.

How to Use
----------

```bash
./tictactoe
```

The interactive UI should hopefully be self explanatory.


Conclusion
----------

Bash does the job and some elements have some appealing simplicity (event replay, clause to no code to implement an event repo). However the lack of data structures is really introducing complexity where it should be simple. The CQRS pattern seems to be viable if really there is a need to stick to bash. Evolving the code was quite straight forward once the structure was in place

I choose to maintain all states and events in files so implementing unit testing should be easy. It should look something like this:
1. Set the application in the state you want
2. Copy the state folder in a test folder
3. Load `libs.sh`
4. Call the appropriate function
5. `diff` stdout with the expected output
