#!/bin/bash
set -e

echo "=== Installing/Updating Flutter Stable ==="

# Remove existing flutter if exists (to force fresh install)
if [ -d "flutter" ]; then
  echo "Removing existing Flutter installation..."
  rm -rf flutter
fi

# Clone Flutter and checkout specific version
echo "Cloning Flutter and checking out version 3.35.7..."
git clone https://github.com/flutter/flutter.git
cd flutter
git checkout 3.35.7
cd ..

# Set PATH
export PATH="$PWD/flutter/bin:$PATH"

# Verify Flutter version and channel
echo "=== Flutter Version Info ==="
flutter --version
flutter doctor -v

# Validate required environment variables
echo "=== Validating Environment Variables ==="
if [ -z "${SUPABASE_URL}" ]; then
  echo "ERROR: SUPABASE_URL is not set"; exit 1
fi
if [ -z "${SUPABASE_ANON_KEY}" ]; then
  echo "ERROR: SUPABASE_ANON_KEY is not set"; exit 1
fi
if [ -z "${DEMO_EMAIL}" ]; then
  echo "ERROR: DEMO_EMAIL is not set"; exit 1
fi
if [ -z "${DEMO_PASSWORD}" ]; then
  echo "ERROR: DEMO_PASSWORD is not set"; exit 1
fi

# Generate Supabase config from environment variables
echo "=== Generating Supabase Config ==="
cat > lib/config/supabase_config.dart << EOF
class SupabaseConfig {
  static const String url = '${SUPABASE_URL}';
  static const String anonKey = '${SUPABASE_ANON_KEY}';
  static const String demoEmail = '${DEMO_EMAIL}';
  static const String demoPassword = '${DEMO_PASSWORD}';
}
EOF

# Build
echo "=== Building Flutter Web ==="
flutter build web --release

echo "=== Build Complete ==="

