if [[ $(uname -o) != "Android" ]]; then
  exit 0
fi

read -p "the directory path to update shebangs, ok?[y/N]" ok

if [[ $ok != "y" ]]; then exit 0; fi

f1() {
  find $SH_FOOT/ -name "*.sh" | while read -r file; do
    if head -n 1 "$file" | grep -qE '^#!.*(/bin/bash|/bin/sh)'; then
      sed -i '1s|^#!.*|#!/data/data/com.termux/files/usr/bin/bash|' "$file"
      echo "Updated shebang in: $file"
    fi
  done
}

f2() {
  find . -name "*.sh" -exec termux-fix-shebang {} \;
  find tools/ -exec termux-fix-shebang {} \;
}

#f1
f2
