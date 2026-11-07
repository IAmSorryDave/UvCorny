#!/bin/sh

echo "Installing git..."
chmod +x .scripts/setup/install-git.sh && .scripts/setup/install-git.sh && chmod -x .scripts/setup/install-git.sh
sleep 1

echo "Configuring git..."
chmod +x .scripts/setup/configure-git.sh && .scripts/setup/configure-git.sh && chmod -x .scripts/setup/configure-git.sh
sleep 1

echo "Installing bash..."
chmod +x .scripts/setup/install-bash.sh && .scripts/setup/install-bash.sh && chmod -x .scripts/setup/install-bash.sh
sleep 1

echo "Installing yq..."
chmod +x .scripts/setup/install-yq.sh && .scripts/setup/install-yq.sh && chmod -x .scripts/setup/install-yq.sh
sleep 1

echo "Installing docker compose..."
chmod +x .scripts/setup/install-compose.sh && .scripts/setup/install-compose.sh && chmod -x .scripts/setup/install-compose.sh
sleep 1

echo "Configuring files..."
chmod +x .scripts/setup/configure-files.sh && .scripts/setup/configure-files.sh && chmod -x .scripts/setup/configure-files.sh
sleep 1

echo "Uninstalling yq..."
chmod +x .scripts/setup/uninstall-yq.sh && .scripts/setup/uninstall-yq.sh && chmod -x .scripts/setup/uninstall-yq.sh
sleep 1

echo "Configuring project..."
chmod +x .scripts/setup/configure-project.sh && .scripts/setup/configure-project.sh && chmod -x .scripts/setup/configure-project.sh
sleep 1

echo "Configuring pre-commit..."
chmod +x .scripts/setup/configure-pre-commit.sh && .scripts/setup/configure-pre-commit.sh && chmod -x .scripts/setup/configure-pre-commit.sh

echo "Configuring watchexec..."
chmod +x .scripts/setup/install-watchexec.sh && .scripts/setup/install-watchexec.sh && chmod -x .scripts/setup/install-watchexec.sh

echo "Configuring npm..."
chmod +x .scripts/setup/install-npm.sh && .scripts/setup/install-npm.sh && chmod -x .scripts/setup/install-npm.sh

echo "Configuring Copilot cli..."
chmod +x .scripts/setup/install-copilot-cli.sh && .scripts/setup/install-copilot-cli.sh && chmod -x .scripts/setup/install-copilot-cli.sh

echo "Setup completed successfully"
