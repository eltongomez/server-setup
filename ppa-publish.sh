#!/bin/bash
# PPA Publication Script for server-setup
# Execute em um servidor Linux com GPG e dput configurados

set -e

PROJECT_DIR="/path/to/server-setup"
PPA_URL="ppa:eltongomez/server-setup"
KEY_ID="${DEBSIGN_KEYID:-}"

if [ -z "$KEY_ID" ]; then
    echo "❌ Erro: DEBSIGN_KEYID não está definido"
    echo "Configure com: export DEBSIGN_KEYID='your-key-id'"
    exit 1
fi

echo "🔐 PPA Publication Setup"
echo "========================"
echo "Project: $PROJECT_DIR"
echo "PPA: $PPA_URL"
echo "Key ID: $KEY_ID"
echo ""

# Step 1: Build source package
echo "📦 Step 1: Building source package..."
cd "$PROJECT_DIR"
if dpkg-buildpackage -S -sa -k"$KEY_ID" 2>&1 | tee /tmp/build.log; then
    echo "✅ Build successful"
else
    echo "❌ Build failed. Check /tmp/build.log"
    exit 1
fi

# Step 2: Check generated files
echo ""
echo "📋 Step 2: Checking generated files..."
cd ..
if [ -f "server-setup_1.0.0-1_source.changes" ]; then
    echo "✅ Found: server-setup_1.0.0-1_source.changes"
    ls -lh server-setup_1.0.0-1*
else
    echo "❌ Error: Missing .changes file"
    exit 1
fi

# Step 3: Sign the package
echo ""
echo "✍️ Step 3: Signing package..."
if debsign -k"$KEY_ID" server-setup_1.0.0-1_source.changes; then
    echo "✅ Package signed"
else
    echo "❌ Signing failed"
    exit 1
fi

# Step 4: Upload to PPA
echo ""
echo "📤 Step 4: Uploading to PPA..."
if dput "$PPA_URL" server-setup_1.0.0-1_source.changes; then
    echo "✅ Upload successful!"
    echo ""
    echo "🎉 Your package is now in the queue for PPA!"
    echo "You can monitor it at: https://launchpad.net/~eltongomez/+builds"
else
    echo "❌ Upload failed"
    exit 1
fi

echo ""
echo "✨ All steps completed successfully!"
