# Ventless
Ventless Trap Survey Online Data Portal

The following are brief instructions to creating the online ventless portal. Written as of 4/11/2022. 

1. In order to update raw data for the new year, open Preparation of data.Rmd in RStudio. Click “Run All” to query the most recent data from MARVIN and to export data into several csv files. Make sure you updated the export locations so the files can be found once exported. Upload the updated .csv files into Ventless/CSV files, replacing the old versions.

2. Open Timeline.xlsx in Excel and manually update the table to reflect changes that may have occurred in the VTS framework. Save the table as a picture in Ventless/Images – Table1.png.

3. Make sure you have a picture of the most recent VTS stratified-means by stat-area figure, and that it's in Ventless/Images – Picture2.jpg

4. Open App.R in RStudio (this is the equivalent of ui.R and server.r combined into one R file).

5. Click “Run App”; it may take a couple minutes to boot, but if the app is successful it should launch. Check through the tabs and attempt to login (login info can be found in the code; user = DMR1, password = lobster21), making sure everything works as expected. Close when ready.

6. When ready to make public, click “Publish”. The link is currently set to https://medmr.shinyapps.io/medmr_ventless/
