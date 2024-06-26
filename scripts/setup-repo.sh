#!/usr/bin/env bash
#
# Script to setup this repo, expects to be in conda environment.
#

repo="$(cd "$(dirname "$0")"; cd ..; pwd)"
cd "$repo"

echo
echo ">> setting up environment"
echo

source ~/.conda/etc/profile.d/conda.sh
conda create -n tgl python=3.7
conda activate tgl

echo
echo ">> installing python packages"
echo

pip install torch==1.12.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
pip install torch-scatter==2.1.0+pt112cu116 -f https://data.pyg.org/whl/torch-1.12.1+cu116.html
pip install dgl==1.0.1+cu116 -f https://data.dgl.ai/wheels/cu116/repo.html
pip install -r requirements.txt

echo
echo ">> compiling c++ extension"
echo

python setup.py build_ext --inplace

if [[ -d "DATA/wiki-talk" && ! -f "DATA/wiki-talk/ext_full.npz" ]]; then
  echo
  echo ">> preparing datasets"
  echo
  python gen_graph.py --data wiki-talk --add_reverse
fi

echo
echo ">> done!"
