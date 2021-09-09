if [ $CONFIGURATION = "Analyze" ]; then
  if which swiftgen >/dev/null; then
    if [ -f Resources/Assets.swift ]; then
        chmod +w Resources/Assets.swift
    fi
    if [ -f Resources/Strings.swift ]; then
        chmod +w Resources/Strings.swift
    fi
    swiftgen
    if [ -f Resources/Assets.swift ]; then
        chmod -w Resources/Assets.swift
    fi
    if [ -f Resources/Strings.swift ]; then
        chmod -w Resources/Strings.swift
    fi
  else
    echo "warning: Swiftgen not installed, download from https://github.com/SwiftGen/SwiftGen"
    exit 1
  fi
fi
