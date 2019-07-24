#Basic go commands
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

# "/Users/a1/Documents/code/akwaba/website/dev-config.yml"

# Website entry directory
W_ENTRY_DIR=./cmd/website
# binary names
W_BINARY=website

build-website:
	$(GOBUILD) -o $(W_ENTRY_DIR)/$(W_BINARY) $(W_ENTRY_DIR)/main.go

run-website: build-website
	cd $(W_ENTRY_DIR) && ./$(W_BINARY) /Users/a1/Documents/code/akwaba/website/dev-config.yml

clean:
	rm -f $(W_ENTRY_DIR)/$(W_BINARY)


build-website-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(W_ENTRY_DIR)/$(W_BINARY) $(W_ENTRY_DIR)/main.go



build-adminapi:
	$(GOBUILD) -o ./cmd/admin/adminapi ./cmd/admin/main.go
run-adminapi: build-adminapi
	./cmd/admin/adminapi /Users/a1/Documents/code/akwaba/adminapi/dev-config.yml