.PHONY: deps

all: deps compile

compile:
	./rebar compile

deps:
	./rebar get-deps

clean:
	./rebar clean

distclean: clean devclean relclean
	./rebar delete-deps

rel: all
	./rebar generate

relclean:
	rm -rf rel/{{appid}}

stage : rel
	$(foreach dep,$(wildcard deps/*), rm -rf rel/{{appid}}/lib/$(shell basename $(dep))-* && ln -sf $(abspath $(dep)) rel/{{appid}}/lib;)
	$(foreach app,$(wildcard apps/*), rm -rf rel/{{appid}}/lib/$(shell basename $(app))-* && ln -sf $(abspath $(app)) rel/{{appid}}/lib;)

devrel: all dev1 dev2 dev3

dev1 dev2 dev3:
	mkdir -p dev
	(cd rel && ../rebar generate target_dir=../dev/$@ overlay_vars=vars/$@.config)

devclean:
	rm -rf dev
	
