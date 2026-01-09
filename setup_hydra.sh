# -------------------------------
# 3. Persist Environment for User
# -------------------------------
HYDRA_ENV_LINE='export HYDRA_KEY=many_heads'
HYDRA_PATH_LINE='export PATH="$HOME/hydra_lair/bin:$PATH"'

# Add only if not already present
grep -qxF "$HYDRA_ENV_LINE" "$HOME/.bashrc" || echo "$HYDRA_ENV_LINE" >> "$HOME/.bashrc"
grep -qxF "$HYDRA_PATH_LINE" "$HOME/.bashrc" || echo "$HYDRA_PATH_LINE" >> "$HOME/.bashrc"

# Load immediately for current shell
export HYDRA_KEY=many_heads
export PATH="$HOME/hydra_lair/bin:$PATH"
