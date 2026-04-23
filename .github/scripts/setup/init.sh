#!/bin/sh

# Add small delays between operations to prevent PID conflicts
set -e

echo "Installing git..."
chmod +x .github/scripts/setup/install-git.sh && .github/scripts/setup/install-git.sh && chmod -x .github/scripts/setup/install-git.sh
sleep 1

echo "Configuring git..."
chmod +x .github/scripts/setup/configure-git.sh && .github/scripts/setup/configure-git.sh && chmod -x .github/scripts/setup/configure-git.sh
sleep 1

echo "Installing bash..."
chmod +x .github/scripts/setup/install-bash.sh && .github/scripts/setup/install-bash.sh && chmod -x .github/scripts/setup/install-bash.sh
sleep 1

echo "Installing yq..."
chmod +x .github/scripts/setup/install-yq.sh && .github/scripts/setup/install-yq.sh && chmod -x .github/scripts/setup/install-yq.sh
sleep 1

echo "Configuring files..."
chmod +x .github/scripts/setup/configure-files.sh && .github/scripts/setup/configure-files.sh && chmod -x .github/scripts/setup/configure-files.sh
sleep 1

echo "Uninstalling yq..."
chmod +x .github/scripts/setup/uninstall-yq.sh && .github/scripts/setup/uninstall-yq.sh && chmod -x .github/scripts/setup/uninstall-yq.sh
sleep 1

echo "Configuring project..."
chmod +x .github/scripts/setup/configure-project.sh && .github/scripts/setup/configure-project.sh && chmod -x .github/scripts/setup/configure-project.sh
sleep 1

echo "Configuring pre-commit..."
chmod +x .github/scripts/setup/configure-pre-commit.sh && .github/scripts/setup/configure-pre-commit.sh && chmod -x .github/scripts/setup/configure-pre-commit.sh

echo "Setup completed successfully"
