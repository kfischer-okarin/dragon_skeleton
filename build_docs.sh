rm -rf build docs
git clone git@github.com:kfischer-okarin/dragon_skeleton.git build
cd build
rdoc -V lib
../$DRAGONRUBY_PATH/dragonruby . --eval app/generate_easing_images.rb
cp -R doc/ ../docs
cd ..
git add docs
git commit --amend --no-edit
git push -f origin docs
