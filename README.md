## A demo application for Practicing Ruby 5.2

If you want to run this on your own machine, you can run `bundle` to install the
dependencies, or manually install them using `gem`.

From there, if you want to connect to a Freenode channel without a password, do the
following:

```bash
ROVER_CHANNEL="#somechannel" ROVER_NAME="somenick" ruby bin/space_explorer
```

If the room you are trying to connect to has a password, do this instead:

```bash
$ ROVER_CHANNEL="#somechannel" ROVER_NAME="somenick" ROVER_PASSWORD="somepassword" ruby bin/space_explorer
```

If you have any questions, feel free to email gregory@practicingruby.com.

Enjoy!
