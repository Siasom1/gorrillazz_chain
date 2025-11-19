###########
# Version #
###########

# fallback values als git info ontbreekt
BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "nogitbranch")
COMMIT := $(shell git log -1 --format='%H' 2>/dev/null || echo "nogitcommit")

# don't override user values
ifeq (,$(VERSION))
  VERSION := $(shell git describe --exact-match 2>/dev/null || echo "")
  ifeq (,$(VERSION))
    VERSION := $(BRANCH)-$(COMMIT)
  endif
endif

# Update the ldflags with the app, client & server names
ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=gorrillazz \
	-X github.com/cosmos/cosmos-sdk/version.AppName=gorrillazzd \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT)

BUILD_FLAGS := -ldflags '$(ldflags)'

###########
# Install #
###########

all: install

install:
	@echo "--> ensure dependencies have not been modified"
	@go mod verify
	@echo "--> installing gorrillazzd"
	@go install -buildvcs=false $(BUILD_FLAGS) -mod=readonly ./cmd/gorrillazzd

init:
	./scripts/init.sh
