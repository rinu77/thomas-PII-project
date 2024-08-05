# data

The folders inside this folder should contain all data at various stages.

This data is being loaded/manipulated/changed/saved with code from the `code` folders.

The raw data is placed in the `raw-data` folder and not edit it. Ever!

The code produces a the cleaned data called `processeddata2.rds`, which is saved in the appropriate `data` sub-folder called `processed-data`.

Ideally, load the raw data into R and do all changes there with code, so everything is automatically reproducible and documented.

