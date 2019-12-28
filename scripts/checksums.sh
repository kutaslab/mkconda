# checksum the locally generated conda tarball created by the make file

tarball=conda/.env/mkconda_build/conda-bld/linux-64/mkconda-0.0.4-0.tar.bz2
md5tbz="077bf0ab586e7d58d5f6d8d76eda6092"

md5str=`md5sum ${tarball}`
[[ $md5str =~ ([0-9a-z]+) ]]  # strip md5

if [[ ${BASH_REMATCH[1]} != ${md5tbz} ]]; then
    echo "ERROR: MD5 $tarball is not $md5tbz"
    echo "Perhaps make mkconda was run and the md5 changed"
else
    echo "MD5 $tarball: $md5tbz ... OK"
fi


# conda activate conda/.env/mkconda_env2
# conda list --explicit > $mkconda_env_pkg_vers
# conda list intf("%s", $1)}'sum - | awk '{pri
