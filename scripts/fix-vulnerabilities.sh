#!/bin/bash

# Fix npm vulnerabilities
echo "🔧 Fixing npm audit vulnerabilities..."

# Update packages to fix vulnerabilities
npm audit fix

echo "✅ Vulnerabilities fixed"