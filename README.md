Rebar templates for generating riak_core applications
=====================================================

Usage
-----

Install [rebar](https://github.com/basho/rebar). You can do that via homebrew:

    brew update
    brew install rebar

Drop these templates in `~/.rebar/templates/`:

    cp riak* ~/.rebar/templates

Then:

    mkdir myapp
    cd myapp
    rebar create template=riak_core appid=myapp
    git init
    git commit -am "omg riak_core"
    git push

Integrate this app into your node's `rebar.config`:

    ...
    {deps, [
          {riak_core, "1.0.*", {git, "git://github.com/basho/riak_core", "1.0"}},
          {myapp, ".*", {git, "git@github.com:bij/myapp.git", "HEAD"}},
           ]}
    ...

Add it to your `reltool.config`, then generate a release with `rebar generate`.
Fire up your node, attach, and test out the included public API's `ping/0`
function, which should return `{pong, Partition}`:

    1> riak_core_node_watcher:services().
    [riak_myapp]
    2> myapp:ping().
    {pong,753586781748746817198774991869333432010090217472}

Hey, distributed unicorns!
