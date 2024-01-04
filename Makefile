HOMEBREW := $(shell command -v brew 2>/dev/null)
MISE := $(shell command -v mise 2>/dev/null)
MISE_RUBY_PLUGIN := $(shell mise plugin-list | grep ruby)
MISE_TUIST_PLUGIN := $(shell mise plugin-list | grep tuist)
MISE_SWIFTLINT_PLUGIN := $(shell mise plugin-list | grep swiftlint)
MISE_SWIFTFORMAT_PLUGIN := $(shell mise plugin-list | grep swiftformat)
MISE_VALE_PLUGIN := $(shell mise plugin-list | grep vale)

# ---

generate: setup open

setup: setup_tools setup_project

setup_tools: check_brew install_mise install_ruby_plugin install_tuist_plugin install_swiftlint_plugin install_swiftformat_plugin install_vale_plugin install_dependencies

setup_project: setup_tuist # Add installation of CocoaPods if required

# ---

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

install_ruby_plugin:
ifeq ($(MISE_RUBY_PLUGIN),)
	$(info mise ruby plugin is not installed, installing it now...)
	mise plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
endif
	$(info mise ruby plugin is installed)

install_tuist_plugin:
ifeq ($(MISE_TUIST_PLUGIN),)
	$(info mise tuist plugin is not installed, installing it now...)
	mise plugin add tuist https://github.com/cprecioso/asdf-tuist.git
endif
	$(info mise tuist plugin is installed)

install_swiftlint_plugin:
ifeq ($(MISE_SWIFTLINT_PLUGIN),)
	$(info mise swiftlint plugin is not installed, installing it now...)
	mise plugin add swiftlint https://github.com/klundberg/asdf-swiftlint.git
endif
	$(info mise swiftlint plugin is installed)

install_swiftformat_plugin:
ifeq ($(MISE_SWIFTFORMAT_PLUGIN),)
	$(info mise swiftformat plugin is not installed, installing it now...)
	mise plugin add swiftformat https://github.com/younke/asdf-swiftformat.git
endif
	$(info mise swiftformat plugin is installed)

install_vale_plugin:
ifeq ($(MISE_VALE_PLUGIN),)
	$(info mise vale plugin is not installed, installing it now...)
	mise plugin add vale https://github.com/pdemagny/asdf-vale.git
endif
	$(info mise vale plugin is installed)

install_dependencies:
	mise install
	bundle install

tuist:
	mise exec tuist generate -n

open:
	open *.xcworkspace

nuke:
	# Remove all artifacts
	rm -rf ./vendor/
	rm -rf ./*.xcworkspace/
	rm -rf ./Projects/**/*.xcodeproj/
	rm -rf ./Projects/**/Derived
	rm -rf ./Tuist/Dependencies/