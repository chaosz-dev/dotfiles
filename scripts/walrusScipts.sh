# walrusGen <debug/release> <architecture>
walrusGen() {

  MODE=$1

  if [ -z $1 ]
  then
    MODE=debug
  fi

  ARCH=$2
  if [ -z $2 ]
  then
    ARCH=x64
  fi

  cmake -H. -Bout/$ARCH -DWALRUS_ARCH=$ARCH -DWALRUS_HOST=linux -DWALRUS_MODE=$MODE -DWALRUS_OUTPUT=shell -GNinja
}

# walrusBuild <directory>
walrusBuild() {
  DIR=$1

  if [ -z $1 ]
  then
    DIR=out/x64
  fi

  ninja -C $DIR
}
