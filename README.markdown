resque-throttle
===============

Resque Throttle is a plugin for the [Resque][0] queueing system
(http://github.com/defunkt/resque). It adds a ThrottledJob class that will
limit the amount of times it can be enqueued per class. 

To use
------
The job you wish to throttle should inherit from the Resque::ThrottledJob class.

In your class, add the can_run_every in which the job should be throttled. Example:

	class MyThrottledJob < Resque::ThrottledJob
	  throttle :can_run_every => 24.hours

	  #rest of your class here
	end

By default, the key which identifies the job is simply the class name. This "identifier"
is stored in a redis key with a TTL equal to that of the can_run_every. Thus the 
default behavior is a single Job class inheriting from Resque::ThrottledJob can only 
run every 30 minutes. 

If you'd like to override that to be more granular, you can do that in the identifier class method
by returning a string. For example, if you want the job to be limited to once a day per
account, do something like the following:

	class MyThrottledJob < Resque::ThrottledJob
	  throttle :can_run_every => 24.hours

	  def self.identifier(*args)
	    account_id = *args
	    "account_id:#{account_id}"
	  end

	  #rest of your class here
	end

The *args passed to identifier are the same arguments that are passed to perform.

When a job is throttled, it will raise a ThrottledError and the job will not be enqueued.

Contributing
------------

Once you've made your commits:

1. [Fork][1] Resque Throttle
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create an [Issue][2] with a link to your branch
5. That's it!

Author
------
Scott J. Tamosunas :: tamosunas@gmail.com :: @scotttam

Copyright
---------
Copyright (c) 2010 Zendesk. See LICENSE for details.

[0]: http://github.com/defunkt/resque
[1]: http://help.github.com/forking/
[2]: http://github.com/scotttam/resque-throttle/issues

