#!/bin/bash

# Check if running in MSYS2
if [[ ! "$MSYSTEM" == "MSYS" ]]; then
  echo "Please run this script in MSYS2 terminal."
  exit 1
fi

echo "Checking Packages" \
; echo " |> Sync/upgrade existing" \
; pacman -Syu --noconfirm \
; echo " |> Install missing" \
; pacman -S --needed --noconfirm \
    mingw-w64-x86_64-toolchain \
    mingw-w64-x86_64-make \
    mingw-w64-x86_64-cmake \
    mingw-w64-x86_64-glfw \
; echo "Done."

# echo "Removing toolchain.." \
# ; pacman -R --noconfirm mingw-w64-x86_64-toolchain \
# ; pacman -R --noconfirm mingw-w64-x86_64-glfw \
# ; pacman -Rns --noconfirm $(pacman -Qdtq)
