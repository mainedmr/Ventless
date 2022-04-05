# Ventless
Ventless Trap Survey Online Data Portal

The following are brief instructions to using the online ventless portal. Written as of 2/1/2022. 

1. In order to update raw data for the new year, open Preparation of data.Rmd in RStudio. Click “Run All” to query the most recent data from MARVIN and to export data into several csv files. Upload the necessary .csv files here.

2. Open Timeline.xlsx in Excel and manually update table to reflect changes that may have occurred in the VTS framework. Save the table as a picture – Table1.png.

3. Make sure you have a picture of the most recent VTS stratified-means by stat area figure – Picture2.jpg

4. Open App.R in RStudio.

5. Click “Run App”; it may take a couple minutes to boot, but if the app is successful it should launch. Check through the tabs and attempt to login (login info can be found in the code; user = DMR1, password = lobster21), making sure everything works as expected. Close when ready.

6. When ready to make public, click “Publish”. The link is currently set to https://medmr.shinyapps.io/medmr_ventless/
