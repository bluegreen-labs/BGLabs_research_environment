# BlueGreen Labs research environment

Setup script for the BlueGreen Labs research environment. The script assumes you are running either Ubuntu 22.04 (in a workstation setting) or Pop OS! 22.04 on (hybrid NVIDIA based) laptops. The script is best run right after a clean install to ensure that it will run smoothly without any conflicts. All output is surpressed and failed installs are currently not logged.

To run the script use in a terminal:

```bash
sudo bash bglabs_system_setup.sh
```

## Installed components

- NVIDIA drivers and CUDA/CUDNN GPU acceleration for machine learning (if hardware is available)
- geospatial libraries GDAL
- GIS software such as QGIS
- R and R studio (plus compiler dependencies)
- the Zotero reference manager

## Notes

The installation of R packages is covered in a separate script.

https://github.com/bluegreen-labs/BGLabs_R_environment

This script can be used safely on existing systems.


## Python and CUDA

Both workstation 1 and 2 run the default Ubuntu python versions. For reproducibility it is advised to work with virtual environments and install conda.

In your home directory [download miniconda for Linux](https://docs.conda.io/en/latest/miniconda.html#linux-installers), and check the downloaded script using checksums.

```
# download the install script
wget https://.../Miniconda3-latest-Linux-x86_64.sh

# run checksums
sha256sum Miniconda3-latest-Linux-x86_64.sh

# if checksums agree run the installer
bash Miniconda3-latest-Linux-x86_64.sh
```
### Creating an environment

To recreate an environment ready for machine learning using pytorch use the [environment.yml](https://github.com//bluegreen-labs/BGLabs_research_environment/blob/main/python/environment.yml) file provided.

You can then call the following command to configure an environment called `mlenv`.

```
conda env create -f environment_ubuntu.yml
```

To activate this environment call:

```
# run on terminal
conda activate mlenv
```

Use the CUDA 12 environment file, [environment_cuda12.yml](https://github.com/bluegreen-labs/BGLabs_research_environment/blob/main/python/environment_cuda12.yml) when using the latest CUDA release (on Pop OS!).

### Install torch manually in any environment

To create a new environment in conda use:

```
conda create --name myenv
```

To install pytorch in conda in your new enviornment run:

```
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
```

### Checking if pytorch runs on the GPU

Once you have activated your session (myenv) your python terminal should allow you to check if CUDA is running on python. Start python by calling `python`, you can than test for the presence of accelerated GPU deep learning capabilities with:

```
import torch
torch.cuda.is_available()
```
The last command should return `True`!!
