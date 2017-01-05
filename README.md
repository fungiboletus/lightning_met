# lightning_met

Very simple Ruby script to fetch lightning data from [api.met.no](https://api.met.no/)

# Docker usage

`docker run --restart=always -v /met_lightning_data:/data -e OUTPUT_FOLDER=/data -d yellowiscool/met_lightning`