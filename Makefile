# Skelletor automation
# Author: Ronaldo Faria Lima <ronaldo@nineteen.com.br>

MODULES=FeedKit
DEPS=${MODULES:%=Modules/%}

.PHONY: deps

deps: 
	git submodule init $(DEPS)
	git submodule update $(DEPS)

dep-deinit:
	git submodule deinit --all
