#!/bin/sh

echo "Installing git..."
chmod +x .scripts/sh/setup/install-git.sh && .scripts/sh/setup/install-git.sh && chmod -x .scripts/sh/setup/install-git.sh
sleep 1

echo "Configuring git..."
chmod +x .scripts/sh/setup/configure-git.sh && .scripts/sh/setup/configure-git.sh && chmod -x .scripts/sh/setup/configure-git.sh
sleep 1

echo "Installing bash..."
chmod +x .scripts/sh/setup/install-bash.sh && .scripts/sh/setup/install-bash.sh && chmod -x .scripts/sh/setup/install-bash.sh
sleep 1

echo "Installing yq..."
chmod +x .scripts/sh/setup/install-yq.sh && .scripts/sh/setup/install-yq.sh && chmod -x .scripts/sh/setup/install-yq.sh
sleep 1

echo "Installing docker compose..."
chmod +x .scripts/sh/setup/install-compose.sh && .scripts/sh/setup/install-compose.sh && chmod -x .scripts/sh/setup/install-compose.sh
sleep 1

echo "Configuring files..."
chmod +x .scripts/sh/setup/configure-files.sh && .scripts/sh/setup/configure-files.sh && chmod -x .scripts/sh/setup/configure-files.sh
sleep 1

echo "Uninstalling yq..."
chmod +x .scripts/sh/setup/uninstall-yq.sh && .scripts/sh/setup/uninstall-yq.sh && chmod -x .scripts/sh/setup/uninstall-yq.sh
sleep 1

echo "Configuring project..."
chmod +x .scripts/sh/setup/configure-project.sh && .scripts/sh/setup/configure-project.sh && chmod -x .scripts/sh/setup/configure-project.sh
sleep 1

echo "Configuring logs..."
chmod +x .scripts/sh/setup/configure-logs.sh && .scripts/sh/setup/configure-logs.sh && chmod -x .scripts/sh/setup/configure-logs.sh
sleep 1

echo "Configuring pre-commit..."
chmod +x .scripts/sh/setup/configure-pre-commit.sh && .scripts/sh/setup/configure-pre-commit.sh && chmod -x .scripts/sh/setup/configure-pre-commit.sh

echo "Configuring watchexec..."
chmod +x .scripts/sh/setup/install-watchexec.sh && .scripts/sh/setup/install-watchexec.sh && chmod -x .scripts/sh/setup/install-watchexec.sh

echo "Configuring npm..."
chmod +x .scripts/sh/setup/install-npm.sh && .scripts/sh/setup/install-npm.sh && chmod -x .scripts/sh/setup/install-npm.sh

echo "Configuring Copilot cli..."
chmod +x .scripts/sh/setup/install-copilot-cli.sh && .scripts/sh/setup/install-copilot-cli.sh && chmod -x .scripts/sh/setup/install-copilot-cli.sh

echo "Setup completed successfully"
