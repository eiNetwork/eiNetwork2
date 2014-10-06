Combined VuFind enhancement branch for developing VuFind for multiple librares with the same code branch. 

Directory structure: 
conf       - contains configuration information for each server at each library.  
             Library specific customizations should not be checked in to Git. 
             Default subfolder conains configuration showing all options that can be copied for 
             setup of new libraries. Configuration files in the base folder can be overridden by 
             adding a copy to the local library configuration folder. 
covers     - contains cached covers for each library.  Data should not be checked in to git. 
             each library specific folder should have large, medium, small, and original folders within it. 
econtent   - contains eContent files that are served wthin VuFind for each library. 
           - Data should not be checked into git.
           - each library should have subfolders called: 
             - library - which will store the full epubs, pdfs, mp3, ext for display. 
             - fulltext - stores full text versions extracted from epubs or pdfs for loading into the index
httpd-conf - configuration files for loading the sites into apache for each server at each library.  
           - Should  not be checked into public version control. 
logs       - contains debug log files for each library. Will not be checked into version control
           - should not be checked in to git
marc       - contains marc files for each library base on the daily export.  
           - Should not be checked into git. 
solr-data  - contains solr index data for each library.  Will not be checked into version control. 
           - default contains files to help setup a new instance.  Should be copied to new instance directory
startup    - contains startup scripts to start vufind customized by library domain.
vufind     - contains all vufind code (website, cron, and load tester).  Checked in to version control.
  
Changes 10/6/2014

The following lines need added to NGC production config file.

Underneath -> [Site]

mymillennium   = https://iiisy1.einetwork.net/iii/wspatroninfo/
mymillennium_user = xxxxx
mymillennium_password = xxxxx

Underneath -> [Caching]

mymill_items                 = 60


/import/reindexer.exe
/site/vufindplus.einetwork.net/translation_maps/System_map.properties
/site/vufindplus.einetwork.net/translation_maps/Location_map.properties
/site/vufindplus.einetwork.net/translation_maps/Format_map.properties
/site/vufindplus.einetwork.net/translation_maps/Format_category_map.properties
