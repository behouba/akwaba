#Basic go commands
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

# Website entry directory
W_ENTRY_DIR=/Users/a1/Documents/code/akwaba/cmd/website
# binary names
W_BINARY=akwaba-website

build-website:
	$(GOBUILD) -o $(W_ENTRY_DIR)/$(W_BINARY) $(W_ENTRY_DIR)/main.go

run-website: build-website
	$(W_ENTRY_DIR)/$(W_BINARY)

clean:
	rm -f $(W_ENTRY_DIR)/$(W_BINARY)


build-website-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(W_ENTRY_DIR)/$(W_BINARY) $(W_ENTRY_DIR)/main.go