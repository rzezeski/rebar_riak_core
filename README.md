Rebar Template for Generating Riak Core Applications
=====================================================

Usage
-----

Drop these templates into `~/.rebar/templates/`:

    cp riak* ~/.rebar/templates

Verify Erlang installation (>= R14B04):

    erl -version

Start with your first app:

    mkdir firstapp
    cd firstapp
    wget http://cloud.github.com/downloads/basho/rebar/rebar && chmod u+x rebar
    ./rebar create template=riak_core appid=firstapp

Here is an excerpt of what the output should look like:

    ==> firstapp (create)
    Writing .gitignore
    Writing Makefile
    Writing README.md
    Writing rebar.config
    ...

Congratulations, you have the start of a Riak Core application that can be deployed to multiple nodes and joined together to form a multinode cluster. Lets compile and run it in console mode:

    make rel
    ./rel/firstapp/bin/firstapp console

At this point you have a single node of firstapp running. Lets test it via the erlang console:

    1> firstapp:ping().
    {pong,753586781748746817198774991869333432010090217472}

Now shut it down:

    2> q().

.. and lets test it using the cmdline, and test it via http request:

    ./rel/firstapp/bin/firstapp start
    
    ./rel/firstapp/bin/firstapp ping
    curl http://localhost:8098/firstapp/ping
    
    ./rel/firstapp/bin/firstapp stop



devrel
----------

Above we showed how to start a single node, but this isn't typically how other Riak Core based applications like Riak are tested.  Instead, there is something called a _devrel_ that allows one to easily set up a local 3-node cluster.

Build the dev-nodes:

    make devrel

This did create 3 separate instances under the `dev/` dir; check it out:

    ls dev

Now, lets start all the nodes:

    for d in dev/dev*; do $d/bin/firstapp start; done

Verify that the nodes are up and running:

    for d in dev/dev*; do $d/bin/firstapp ping; done

You should see three `pong` replies.  At this point it is worth saying that you have three **INDIVIDUAL** firstapp nodes running.  They are **NOT** aware of each other yet. In order to form a cluster you have to _join_ the nodes. That has to be done only once. If a node, or the entire cluster, goes down it will remember the nodes it was connected to.

    for d in dev/dev{2,3}; do $d/bin/firstapp-admin join firstapp1@127.0.0.1; done

Finally, to make sure they really all agree on the shape of the cluster you can ask if the _ring_ is "ready."

    ./dev/dev1/bin/firstapp-admin ringready

Which returns something like:

    TRUE All nodes agree on the ring ['firstapp1@127.0.0.1','firstapp2@127.0.0.1','firstapp3@127.0.0.1']

To verify you have a 3 node cluster and to see the distribution of the ring, run the `member_status` command:

    ./dev/dev1/bin/firstapp-admin member_status

Which returns:

    ================================= Membership ==================================
    Status     Ring    Pending    Node
    -------------------------------------------------------------------------------
    valid      34.4%      --      'firstapp1@127.0.0.1'
    valid      32.8%      --      'firstapp2@127.0.0.1'
    valid      32.8%      --      'firstapp3@127.0.0.1'
    -------------------------------------------------------------------------------
    Valid:3 / Leaving:0 / Exiting:0 / Joining:0 / Down:0

Pretty cool!! Your riak-core cluster is up and running.

And in case you want to stop all the nodes:

    for d in dev/dev*; do $d/bin/firstapp stop; done
