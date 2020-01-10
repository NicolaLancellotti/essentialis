.PHONY: all
all:	format \
		lint \
		test

.PHONY: format
format:
	@swift-format -i --recursive .

.PHONY: lint
lint:
	@swift-format lint --recursive .
	
.PHONY: test
test:
	@swift test
