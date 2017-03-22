# Skelletor automation
# Author: Ronaldo Faria Lima <ronaldo@nineteen.com.br>

MODULES=FeedKit
DEPS=${MODULES:%=Modules/%}

.PHONY: deps

deps: 
	git submodule init $(DEPS)
	git submodule update --remote $(DEPS)

deps-deinit:
	git submodule deinit --all
