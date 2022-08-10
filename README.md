# BlueGreen Labs research environment

Setup script for the BlueGreen Labs research environment. The script assumes you are running either Ubuntu 20.04 (in a workstation setting) or Pop OS! 22.04 on (hybrid NVIDIA based) laptops. The script is best run right after a clean install to ensure that it will run smoothly without any conflicts. All output is surpressed and failed installs are currently not logged.

## Installed comnponents

- NVIDIA drivers and CUDA/CUDNN GPU acceleration for machine learning (if hardware is available)
- geospatial libraries GDAL
- GIS software such as QGIS
- R and R studio (plus compiler dependencies)
- the Zotero reference manager

## Notes

The installation of R packages is covered in a separate script.

https://github.com/bluegreen-labs/BGLabs_R_environment

This script can be used safely on existing systems.
