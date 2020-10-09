BEFORE STARTING:
	1. Download this entire directory to your computer.
	2. Ensure Node.js is installed and executable through your command line interface of choice.

	NOTE: All dependencies are located within this directory, so there is no need to install any packages. :)
		- In fact, some of the dependencies have been modified, so reinstalling them may break the program.

TO SCRAPE APP DATA:
	1. Run 'scrape_data.js' using Node from the command line.
	2. The scraped data, organized by category, will be available in folder '\data_xxxxxxxxxxxxx' where x is the data's timestamp (UNIX milliseconds since 1/1/1970).

TO DOWNLOAD ICONS FROM DATA FILES:
	1. Install the os, json, and requests libraries to your Python environment.
	2. Run 'download_icon_from_dat.py' using Python from the command line.
	3. The image files will be in folders within the same directory as the data files, organized by category, and named according to appId and number of installs.
		- Example icon file generated, from an app with id:'com.android.app' and installs:2000 - "com.android.app_2000.ico"
	
	NOTE: This program iterates through all files ending in '.dat' in and below the working directory.
