WORKSPACE := $(shell [ -e ./*.xcworkspace ] && echo 1 || echo 0 )
PROJECT := $(shell [ -e ./*.xcodeproj ] && echo 1 || echo 0 )
HOMEBREW := $(shell command -v brew 2>/dev/null)
MISE := $(shell command -v mise 2>/dev/null)
TUIST := $(shell [ -e ./*.xcworkspace ] && echo 1 || echo 0 )
XCODEGEN := $(shell [ -e ./*.xcodeproj ] && echo 1 || echo 0 )
PODFILE := $(shell find . -name Podfile 2>/dev/null)

.PHONY: all generate setup open nuke setup_tools setup_project check_brew install_mise install_devtools install_gems generate_project install_dependencies

# --- Common ---

generate: setup_project open

setup: setup_tools setup_project

open:
ifeq ($(WORKSPACE), 1)
	$(info Opening Workspace...)
	open *.xcworkspace
else ifeq ($(PROJECT), 1)
	$(info Opening Project...)
	open *.xcworkspace
else
	$(error No project found)
endif

nuke:
	# Remove all artifacts
	rm -rf ./vendor/
	rm -rf ./*.xc*
	rm -rf ./Projects/**/*.xcodeproj/
	rm -rf ./Projects/**/Derived/
	rm -rf ./Projects/**/Pods/
	rm -rf ./Tuist/Dependencies/
	rm -rf ./Pods/

# ---

setup_tools: check_brew install_mise install_devtools install_gems

setup_project: generate_project install_dependencies

check_brew:
ifeq ($(HOMEBREW),)
	$(error brew is not installed)
else
	$(info brew is installed)
endif

install_mise:
ifeq ($(MISE),)
	$(info mise is not installed, installing it now...)
	brew install mise
endif
	$(info mise is installed)

install_devtools:
	mise install -y

install_gems:
	bundle install

generate_project:
ifeq ($(TUIST), 1)
	$(info Generate Tuist Project)
	tuist generate -n
else ifeq ($(XCODEGEN), 1)
	$(info Generate XcodeGen Project)
	find *.xc* -type f -not -name 'Package.resolved' -delete && xcodegen
else
	$(info No project generation needed)
endif

install_dependencies:
ifneq ($(PODFILE),)
	pod install
endif