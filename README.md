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
