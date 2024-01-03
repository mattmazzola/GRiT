git config --global safe.directory '*'
git config --global core.editor "code --wait"
git config --global pager.branch false

# Set AZCOPY concurrency to auto
echo "export AZCOPY_CONCURRENCY_VALUE=AUTO" >> ~/.zshrc
echo "export AZCOPY_CONCURRENCY_VALUE=AUTO" >> ~/.bashrc

# Add dotnet to PATH
echo 'export PATH="$PATH:$HOME/.dotnet"' >> ~/.zshrc
echo 'export PATH="$PATH:$HOME/.dotnet"' >> ~/.bashrc

# Activate conda by default
echo "source /home/vscode/miniconda3/bin/activate" >> ~/.zshrc
echo "source /home/vscode/miniconda3/bin/activate" >> ~/.bashrc

# Use grit environment by default
echo "conda activate grit" >> ~/.zshrc
echo "conda activate grit" >> ~/.bashrc

# Activate conda on current shell
source /home/vscode/miniconda3/bin/activate

# Create and activate grit environment
conda create -n grit python=3.8 -y
conda activate grit

echo "Installing CUDA..."
conda install -y -c nvidia cuda-nvcc=11.3

echo "Installing detectron2..."
# git clone https://github.com/facebookresearch/detectron2.git
# cd detectron2
# git checkout cc87e7ec
# pip install -e .
# cd ..

# https://github.com/facebookresearch/detectron2/releases
python -m pip install detectron2==0.6 -f \
  https://dl.fbaipublicfiles.com/detectron2/wheels/cu113/torch1.10/index.html

mkdir -p models
cd models

if [ ! -f grit_b_densecap_objectdet.pth ]; then
  echo "Downloading pretrained model..."
  wget https://datarelease.blob.core.windows.net/grit/models/grit_b_densecap_objectdet.pth
else
  echo "Skipping download, pretrained model already exists."
fi

cd ..

echo "Installing requirements..."
pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html
pip install -r requirements.txt

echo "postCreateCommand.sh completed!"
