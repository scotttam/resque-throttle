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

By default, the key which identifies the job is simply the class name. If you'd like
to override that to be more granular, you can do that in the identifier class method
by returning a string. Example:

	class MyThrottledJob < Resque::ThrottledJob
	  throttle :can_run_every => 24.hours

	  def self.identifier(*args)
	    some_id = *args
	    thing = MyClass.find_by_id(some_id)
	    "some_id:#{thing.thing_id}"
	  end

	  #rest of your class here
	end

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

