.PHONY: build-sync test-sync sync

build-sync:
	cd sync && bun build index.ts --compile --outfile=ai-sync

test-sync:
	cd sync && bun test

sync:
	cd sync && bun run index.ts sync
