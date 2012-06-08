puppet-splunk
=============

<<<<<<< HEAD
Description
-----------

A Puppet report handler for sending logs, events and metrics to Splunk.

Requirements
------------

* `rest-client`
* `puppet` (version 2.6.5 and later)

Installation & Usage
--------------------

1.  Install the `rest-client` gem on your Puppet master

        $ sudo gem install rest_client

2.  Install puppet-splunk as a module in your Puppet master's module
    path.

3.  Update the `server` variable in the `splunk.yaml` file with
    your Splunk server details. Specify your Splunk user and password with the 
    `user` and `passord` options respectively. You can also specify the Splunk 
    index to send events to using the `index` option.

4.  Copy `splunk.yaml` to `/etc/puppet`.

5.  Enable pluginsync and reports on your master and clients in `puppet.conf`

        [master]
        report = true
        reports = splunk
        pluginsync = true
        [agent]
        report = true
        pluginsync = true

6.  Run the Puppet client and sync the report as a plugin

Author
------

James Turnbull <james@lovedthanlost.net>

The splunk_post method copied from Greg Albrecht Kim of Splunk.

License
-------

    Author:: James Turnbull (<james@lovedthanlost.net>)
    Copyright:: Copyright (c) 2011 James Turnbull
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
=======
A Puppet report handler for sending logs, events and metrics to Splunk.
>>>>>>> aade7b22aec3e51ce01b3a6217993fe0e6b907a4
