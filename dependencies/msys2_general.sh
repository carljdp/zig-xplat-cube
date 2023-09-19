#!/bin/bash

# Check if running in MINGW64
if [[ ! "$MSYSTEM" == "MINGW64" ]]; then
  echo "Please run this script in MINGW64 terminal."
  exit 1
fi

echo "Checking Packages.." \
; echo " |> Sync/upgrade existing" \
; pacman -Syu --noconfirm \
; echo " |> Install missing" \
; pacman -S --noconfirm --needed \
    git \
; echo "Done."

# echo "Removing packages.." \
# ; pacman -R --noconfirm git \
# ; pacman -Rns --noconfirm $(pacman -Qdtq)

# echo "Removing packages.." \
# ; pacman -R --noconfirm base-devel \
# ; pacman -R --noconfirm cmake \
# ; pacman -R --noconfirm make \
# ; pacman -R --noconfirm git \
# ; pacman -Rns --noconfirm $(pacman -Qdtq)
