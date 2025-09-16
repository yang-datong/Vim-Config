#!/bin/bash

set -e

if [ $(uname) == "Linux" ]; then
  wget https://github.com/bergercookie/asm-lsp/releases/download/v0.10.0/asm-lsp-x86_64-unknown-linux-gnu.tar.gz -O asm_lsp.tar.gz
elif [ $(uname) == "Darwin" ]; then
  if [ $(arch) == "arm64" ]; then
    wget https://github.com/bergercookie/asm-lsp/releases/download/v0.10.0/asm-lsp-aarch64-apple-darwin.tar.gz -O asm_lsp.tar.gz
  else
    wget https://github.com/bergercookie/asm-lsp/releases/download/v0.10.0/asm-lsp-x86_64-apple-darwin.tar.gz -O asm_lsp.tar.gz
  fi
else
  echo -e "\033[31mWindows???\033[0m"
  exit
fi

tar -zxvf asm_lsp.tar.gz

mv asm-lsp ~/.local/bin/asm-lsp

cat <<EOF >$HOME/.config/asm-lsp/asm-lsp.toml
[default_config]
version = "0.10.0"
assembler = "gas"
instruction_set = "arm64"

[default_config.opts]
diagnostics = true
default_diagnostics = true
EOF
