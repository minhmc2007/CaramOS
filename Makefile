.PHONY: build release debug clean shell help docker-build docker-release docker-clean

PROFILE := profile
WORKDIR := work
OUTDIR  := out
ISO     := $(wildcard $(OUTDIR)/caramos-*.iso)

# Dev build (lz4, fast)
build:
	mkarchiso -v -w $(WORKDIR) -o $(OUTDIR) $(PROFILE)

# Release build (xz, smaller ISO)
release:
	AIROOTFS_IMAGE_TOOL_OPTIONS='-comp xz -Xbcj x86 -b 1M -Xdict-size 1M' \
		mkarchiso -v -w $(WORKDIR) -o $(OUTDIR) $(PROFILE)

# Debug build (no splash, verbose boot)
debug:
	mkarchiso -v -w $(WORKDIR) -o $(OUTDIR) $(PROFILE)

# Clean build artifacts
clean:
	rm -rf $(WORKDIR) $(OUTDIR)

# Enter chroot for manual debugging
shell:
	@if [ -d "$(WORKDIR)/x86_64/airootfs" ]; then \
		arch-chroot "$(WORKDIR)/x86_64/airootfs"; \
	else \
		echo "No chroot found. Run 'make build' first."; \
	fi

# Test ISO in QEMU
test:
	@if [ -n "$(ISO)" ]; then \
		run_archiso -u -i $(ISO); \
	else \
		echo "No ISO found in $(OUTDIR)/. Run 'make build' first."; \
	fi

# --- Docker build ---
docker-build:
	docker compose run --rm builder mkarchiso -v -w /work -o /out /app/$(PROFILE)

docker-release:
	docker compose run --rm builder \
		bash -c 'AIROOTFS_IMAGE_TOOL_OPTIONS="-comp xz -Xbcj x86 -b 1M -Xdict-size 1M" \
			mkarchiso -v -w /work -o /out /app/$(PROFILE)'

docker-clean:
	rm -rf $(WORKDIR) $(OUTDIR)

# --- Repo management ---
repo-init:
	repo init -u https://github.com/minhmc2007/CaramOS-Manifest

repo-sync:
	repo sync

repo-status:
	repo status

help:
	@echo "CaramOS Build System (mkarchiso)"
	@echo ""
	@echo "--- Local Build (Arch Linux) ---"
	@echo "  make build         — Dev build (lz4)"
	@echo "  make release       — Release build (xz)"
	@echo "  make debug         — Debug build (verbose boot)"
	@echo "  make clean         — Remove work/ and out/"
	@echo "  make shell         — Enter chroot for debugging"
	@echo "  make test          — Boot ISO in QEMU"
	@echo ""
	@echo "--- Docker Build (any OS) ---"
	@echo "  make docker-build   — Build via Docker"
	@echo "  make docker-release — Release via Docker"
	@echo "  make docker-clean   — Clean via Docker"
	@echo ""
	@echo "--- Multi-repo ---"
	@echo "  make repo-init    — Init repo workspace"
	@echo "  make repo-sync    — Sync all repos"
	@echo "  make repo-status  — Show repo status"
	@echo ""
	@echo "Requires: archiso, make, docker (for docker targets)"
