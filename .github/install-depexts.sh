#!/usr/bin/env bash
set -euo pipefail

# This script installs system dependencies (depexts) listed by `dune show depexts`.
# It is intended to be called from the setup-dune composite action.

echo "[install-depexts] Starting."

: "${RUNNER_OS:?RUNNER_OS must be set}"

DEPEXT_TEMPFILE="$(mktemp)"
if dune show depexts >"$DEPEXT_TEMPFILE" 2>&1; then
  DEPEXT_LIST="$(cat "$DEPEXT_TEMPFILE")"
else
  cat "$DEPEXT_TEMPFILE"
  echo "[install-depexts] dune show depexts failed"
  rm -f "$DEPEXT_TEMPFILE"
  exit 1
fi
rm -f "$DEPEXT_TEMPFILE"

echo "[install-depexts] DEPEXT_LIST='$(printf '%s' "$DEPEXT_LIST" | sed ':a;N;$!ba;s/\n/\\n/g')'"

if [ -z "$DEPEXT_LIST" ]; then
  echo "[install-depexts] No depexts to install."
  exit 0
fi

if [ "${RUNNER_OS}" = "Linux" ]; then
  echo "[install-depexts] Installing depexts with apt-get:"
  echo "$DEPEXT_LIST"
  sudo apt-get update
  xargs -r sudo apt-get install -y <<< "$DEPEXT_LIST"
elif [ "${RUNNER_OS}" = "macOS" ]; then
  echo "[install-depexts] Installing depexts with brew:"
  echo "$DEPEXT_LIST"
  brew update
  xargs -r brew install <<< "$DEPEXT_LIST"
else
  echo "[install-depexts] Depext installation is not supported on this OS: ${RUNNER_OS}"
  exit 1
fi
