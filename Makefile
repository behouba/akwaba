#Basic go commands
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

# "/Users/a1/Documents/code/akwaba/website/dev-config.yml"

# Website entry directory
W_ENTRY_DIR=./cmd/website
# adminapi entry directory
A_ENTRY_DIR=./cmd/adminapi
# notifier entry directory
N_ENTRY_DIR=./cmd/mailer
# mobileapi entrey directory

# binary names
W_BINARY=./bin/website
A_BINARY=./bin/adminapi
N_BINARY=./bin/mailer

# configuration files
CONFIG_FILE=dev-config.yml

build-website:
	$(GOBUILD) -o $(W_ENTRY_DIR)/$(W_BINARY) $(W_ENTRY_DIR)/main.go

run-website: build-website
	cd $(W_ENTRY_DIR) && ./$(W_BINARY) $(CONFIG_FILE)


build-adminapi:
	$(GOBUILD) -o $(A_ENTRY_DIR)/$(A_BINARY) $(A_ENTRY_DIR)/main.go
run-adminapi: build-adminapi
	cd $(A_ENTRY_DIR) && ./$(A_BINARY) $(CONFIG_FILE)

build-mailer:
	$(GOBUILD) -o $(N_ENTRY_DIR)/$(N_BINARY) $(N_ENTRY_DIR)/main.go
run-mailer: build-mailer
	cd $(N_ENTRY_DIR) && ./$(N_BINARY) $(CONFIG_FILE)


build-mobileapi:
	$(GOBUILD) -o $(M_ENTRY_DIR)/$(M_BINARY) $(M_ENTRY_DIR)/main.go
run-mobileapi: build-mobileapi
	cd $(M_ENTRY_DIR) && ./$(M_BINARY) $(CONFIG_FILE)

