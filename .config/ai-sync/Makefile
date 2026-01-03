.PHONY: build-content build-sync test-sync test-build sync

# Build content (resolve @ references)
build-content:
	rm -rf build
	go run ./cmd/build

# Build the sync CLI binary (depends on content)
build-sync: build-content
	go build -o ai-sync ./cmd/sync

# Test the sync tool
test-sync:
	go test ./cmd/sync/...

# Test the build tool
test-build:
	go test ./cmd/build/...

# Sync (depends on content being built)
sync: build-content
	go run ./cmd/sync
