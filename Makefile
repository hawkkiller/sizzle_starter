# Define phony targets to avoid conflicts with files
.PHONY: flutter-get dart-gen dart-gen-watch template-dev-init tmpl-git-config

# Default help command
help:
	@echo "Available commands:"
	@{ \
	  printf "%-25s %s\n" "make get" "Get Flutter dependencies"; \
		printf "%-25s %s\n" "make bootstrap" "Bootstrap Project"; \
	  printf "%-25s %s\n" "make gen" "Generate Dart files"; \
	  printf "%-25s %s\n" "make gen-watch" "Watch and generate Dart files"; \
	}

# Task: Get flutter dependencies
get:
	@echo "Getting Flutter dependencies..."
	flutter pub get

# Task: Bootstrap Project
bootstrap:
	bash scripts/bootstrap.bash

# Task: Generate Dart files
gen:
	@echo "Running Dart codegen..."
	dart run build_runner build -d

# Task: Watch Dart codegen
gen-watch:
	@echo "Watching Dart codegen..."
	dart run build_runner watch -d

# Task: Initialize template for development
# should be removed if you're using Sizzle Starter for your project
template-dev-init:
	@echo "Initializing template for development..."
	@echo 'android/\nios/\nweb/\nwindows/\nmacos/\nlinux/\n' > .dev.gitignore
	@git config core.excludesfile .dev.gitignore
	@cd app && flutter create --org com.sizzle.sizzle_starter . && rm -f test/widget_test.dart
