#!/bin/bash

# Crear directorios necesarios
mkdir -p HacksForNails-Android/app/src/main/res/drawable-xxhdpi
mkdir -p HacksForNails-Android/app/src/main/res/drawable-xhdpi
mkdir -p HacksForNails-Android/app/src/main/res/drawable-hdpi
mkdir -p HacksForNails-Android/app/src/main/res/drawable-mdpi

# Copiar imágenes
cp "HacksForNails/Assets.xcassets/bg2.imageset/bg2.png" "HacksForNails-Android/app/src/main/res/drawable/bg2.png"
cp "HacksForNails/Assets.xcassets/logo black.imageset/logo black@1x.png" "HacksForNails-Android/app/src/main/res/drawable/logo_black.png"
cp "HacksForNails/Assets.xcassets/logo.imageset/logo@1x.png" "HacksForNails-Android/app/src/main/res/drawable/logo.png"
cp "HacksForNails/Assets.xcassets/placeholder.imageset/placeholder.svg" "HacksForNails-Android/app/src/main/res/drawable/placeholder.xml"
cp "HacksForNails/Assets.xcassets/profile_photo.imageset/profile_photo.png" "HacksForNails-Android/app/src/main/res/drawable/profile_photo.png"
cp "HacksForNails/Assets.xcassets/Google.imageset/pngwing.com-2.png" "HacksForNails-Android/app/src/main/res/drawable/google.png"
cp "HacksForNails/Assets.xcassets/nail_art.imageset/nail_art.jpg" "HacksForNails-Android/app/src/main/res/drawable/nail_art.png"
cp "HacksForNails/Assets.xcassets/pedicura.imageset/pedicura.jpg" "HacksForNails-Android/app/src/main/res/drawable/pedicura.png"
cp "HacksForNails/Assets.xcassets/cejas.imageset/cejas.jpg" "HacksForNails-Android/app/src/main/res/drawable/cejas.png"
cp "HacksForNails/Assets.xcassets/cejas2.imageset/cejas2.jpg" "HacksForNails-Android/app/src/main/res/drawable/cejas2.png" 