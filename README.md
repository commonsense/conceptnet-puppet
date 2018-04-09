A Puppet module for setting up ConceptNet on a new machine.

First, get the Puppet dependencies by running `sudo sh puppet-setup.sh`. Then
let Puppet configure the machine, with `sudo sh puppet-apply.sh`.

Puppet, by design, will take over the configuration of the machine. Do not run
this on an existing computer that you use for other things. Run it in a fresh VM.
