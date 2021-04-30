# Manipulating and formatting data

Assemble and compile sourced and collected data, wrangling data sets and rendering them FAIR. Additional data supplementing initial data is generated using the standardised collection tools from re-designed experiments. Additional and initial data is then assembles and collated, prepared to inputs for models. FAIR process will also be included to facilitate the process to data managers and use cases. The purpose of this tools is to lead to standardisation of data into formats suitable for use and re-use.

Examples:
## Format data:
Data obtained from the ``source_data`` module using rgee can be prepared into the necessary format to run WOFOST using the folowing steps:
### Prepare Solar Net Radiation
``srad.col <- format2tbl(url = "https://storage.googleapis.com/iita_transform_bucket/points_srad__2021_04_14_10_42_31.geojson", attribute = "srad_J/m2")``
### Prepare Precipitation
``prec.col <- format2tbl(url = "https://storage.googleapis.com/iita_transform_bucket/points_prec__2021_04_14_10_42_35.geojson", attribute = "prec_mm")``
### Collate the two:
``Reduce(dmerge,list(srad.col,prec.col))``

...