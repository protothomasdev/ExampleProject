export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/mise/shims:$PATH"

mise reshim -C $SRCROOT
swiftlint --config ../../.swiftlint.yml
swiftformat --lint --lenient --config ../../.swiftformat .