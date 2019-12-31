# Creates a working mkconda environment ~10 - 30 min and makes an explicit snapshot 
#
# 1. conda create and activate a minimal environment populated with
#    conda build tools
# 
# 2. use the build_env to conda build a mkconda package binary tarball
#    according to meta.yaml
#
# 3. use the build_env to conda create a test_env environment with (just) the
#    mkconda (meta)package installed
#    

CROOT="/tmp/mkconda"   # build root folder


# regex patterns
# use to fetch VAL for KEY : VAL pair ... legal filename chars only
VAL_REGEX="[[:space:]]*:[[:space:]]*([a-zA-Z0-9\-\_\/]+)"

ver_regex="version[[:space:]]*:[[:space:]]*[\"'][[:space:]]*([^[[:space:]]+)[[:space:]]*[\"']"
actenv_regex="active environment$VAL_REGEX"  # conda info
base_regex="base environment${VAL_REGEX}"  # conda info
 
# ------------------------------------------------------------
# 1. Set up and activate a minimal conda build environment
# ------------------------------------------------------------

# look up current mkconda meta.yaml version 
meta_yaml=$(cat conda/meta.yaml)
[[ $meta_yaml =~ $ver_regex ]]
ver=${BASH_REMATCH[1]:-"not found"}

echo "meta.yaml mkconda version: ${ver}"
if [[ $ver = "not found" ]]; then
    exit -1
fi

# do we have conda?
conda_info=$(conda info)
# echo $conda_info

# is there an activate env?
#actenv_regex="(active environment)" #[[:space:]]*:[[:space:]]*([^[[:space:]]]+)"
[[ $conda_info =~ $actenv_regex ]]
act_env=${BASH_REMATCH[1]}
echo "act_env: ${act_env}"

if [[ $act_env = "None" ]]; then
    echo "active conda env ${act_env} ... OK"
else 
    echo "conda deactivate all conda envs before running create.sh"
    exit -2
fi

[[ $conda_info =~ $base_regex ]]
base_path=${BASH_REMATCH[1]}
conda_sh=${base_path}/etc/profile.d/conda.sh
echo "base_path: $base_path"
echo "running: $conda_sh ..."

source "${base_path}/etc/profile.d/conda.sh" && conda activate
hash -r

# create and activate the empty env
conda create -p ${CROOT}/build_env -y 
conda activate ${CROOT}/build_env

build_info=$(conda info)
buildenv_regex="active environment$VAL_REGEX"
[[ $build_info =~ $buildenv_regex ]]
build_env=${BASH_REMATCH[1]}

if [[ $build_env = ${CROOT}/build_env ]]; then
    echo "build env: ${build_env} ... OK"
else
    echo "ERROR failed to activate build_env, got this one: ${build_env}"
    conda info
    exit -3
fi

# install the conda build tools
conda install conda-build conda-verify -y

# ok, ready to build in this env, report
conda info

echo "mkconda build_env OK"

# ------------------------------------------------------------
# 2. Build the binary mkconda package tarball ... slow this is
#    what times out on TravisCI
# ------------------------------------------------------------
conda build --croot ${CROOT}/conda-bld purge
rm  ${CROOT}/conda-bld/linux-64/*tar.bz2
rm -r ${CROOT}/conda-bld/linux-64/.cache


echo "building $(conda build conda --output --croot ${CROOT}/conda-bld) from meta.yaml ... this takes a long while"
conda build conda --croot ${CROOT}/conda-bld -c kutaslab -c defaults -c conda-forge
# if [[ $(conda build conda --croot ${CROOT}/conda-bld -c kutaslab -c defaults -c conda-forge) ]]; then
#     echo "OK"
# else
#     echo "failed"
#     exit -4
# fi

# ------------------------------------------------------------
# 3. create and activate a test_env environment with the binary
#    mkconda package installed and snapshot the recipe
# ------------------------------------------------------------
echo "creating run_env with mkconda-${ver} package installed"
local_channel=file://${CROOT}/conda-bld
# this works
# conda create -p ${CROOT}/run_env mkconda=${ver} -c ${local_channel} -c kutaslab -c defaults -c conda-forge -y
conda create -p ${CROOT}/run_env mkconda=${ver} -c ${local_channel} -c defaults -c kutaslab -c conda-forge -y

# if [[ $(conda create -p ${CROOT}/run_env mkconda=${ver} -c ${local_channel} -c kutaslab -c defaults -c conda-forge -y) ]]; then
#     echo "OK"
# else
#     echo "failed"
#     exit -5
# fi

conda deactivate
conda activate ${CROOT}/run_env

run_info=$(conda info)
[[ $run_info =~ $actenv_regex ]]
act_env=${BASH_REMATCH[1]}

if [[ ${act_env} = ${CROOT}/run_env ]]; then
    echo "run env: ${act_env} ... OK"
else
    echo "ERROR failed to activate run_env, got this one: ${act_env}"
    conda info
    exit -6
fi

# snapshot the environment recipe
echo "# mkconda ${ver} $(date)" > conda/mkconda_env_recipe.txt
conda list --explicit >> conda/mkconda_env_recipe.txt

# copy pkg binary files over to local dir and update the repo
git rm -f --ignore-unmatch conda/conda-bld/linux-64/mkconda*.tar.bz2  # purge previous
mkdir -p conda/conda-bld/linux-64
cp -r ${CROOT}/conda-bld/linux-64/*.* conda/conda-bld/linux-64
git add conda/conda-bld/linux-64/mkconda*.tar.bz2  # replace with new





