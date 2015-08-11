<script type="text/javascript">
{literal}
$(function() {
        var icons = {
          header: "ui-icon-circle-arrow-e",
          activeHeader: "ui-icon-circle-arrow-s"
        };
        $("#accordion").accordion({
            icons: icons
        });
    });
{/literal}
</script>
<div id="page-content" class="content">
    <div id="left-bar">&nbsp;</div>
    <div id="main-content">
        <h1>Latest Website Updates</h1>
        <br>
        <h3>We’re listening to you. The ongoing changes and planned enhancements are driven by the comments and feedback you submit when completing the new catalog survey.  We want to continue to hear from you and we appreciate your feedback.</h3>
        <br>
        <div id="accordion">
        <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Current Release version 4.3.4</span></h2>
            <div>
                Release date 8/12/2015
                <ol class="decimal">
                    <li>The Age Group filter is now based on where an item is shelved in the library.  For example, if an item is shelved in the Children's department, it will appear in search results filtered for the Children Age Group.  Since different libraries may shelve the same title differently, the same title may appear in the search results for multiple age groups.</li>
                    <li>We have added a new filter for Fiction/Non Fiction.  This filter includes items that are shelved in locations identified as fiction or non-fiction.  Since most of the items shelved specifically as fiction or non-fiction are print books, this filter is effective primarily for print books.  Other types of material (i.e. music, video, magazines) are not usually shelved as fiction or non-fiction and are generally not included in this filter.</li>
                </ol>
            </div>
            
        <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 4.3.3</span></h2>
            <div>
                Release date 7/29/2015
                <ol class="decimal">
                    <li>When using the catalog inside a library location, any items which are currently available in the building will now display both their call number and their shelving location.  This will make it easier for users to locate their desired materials.</li>
                </ol>
            </div>
            
        <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 4.3.2</span></h2>
            <div>
                Release date 6/1/2015
                <ol class="decimal">
                    <li>Support for OverDrive's new Listen format is added to the catalog.  After a user checks out a book with OverDrive Listen, the View and Renew Items page will have a button labeled Listen to allow the user to listen to the book using streaming audio.</li>
                </ol>
            </div>
            
        <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 4.3.1</span></h2>
            <div>
                Release date 2/16/2015
                <ol class="decimal">
                    <li>Support for OverDrive's new streaming video format is added to the catalog.  After a user checks out and downloads a streaming video, the View and Renew Items page will have a button labeled Watch to allow the user watch the video online.</li>
                    <li>The loan expiration date for econtent items now appears for user that do not have any physical checked out items.</li>
                    <li>The Age Group and Literary Form filters now allow you to select multiple values.</li>
                </ol>
            </div>
 
        <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 4.3</span></h2>
            <div>
                Release date 1/5/2015
                <ol class="decimal">
                    <li>Users will now go directly to their Checked Out Items page when logging in to My Account.  Previously, users were directed to their Account Settings page upon login.  </li>
                    <li>The Checked Out Items list is now sorted by Due Date by default.  The previous default sort was by Title.  </li>
                    <li>The following changes were made to address bugs with the Title sort on the Checked Out Items page:</li>
                    <ol class="alpha">
                        <li>Leading articles were not being omitted from the Title sort for physical items resulting in inconsistent sort behavior.  Articles are now omitted to provide an accurate alphabetical sort by title.</li>
                        <li>A case sensitivity issue resulted in items being sorted differently depending on whether their titles contained upper or lower case letters.  Items are now sorted alphabetically by title, regardless of letter case.</li>
                    </ol>
                

                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 4.2</span></h2>
            <div>
                Release date 10/6/2014
                <ol class="decimal">
                    <li>Author Search now includes group names such as musical groups. <a class="link_blue" href="{$url}/Union/Search?basicType=Author&lookfor=beatles">Check it Out</a></li>
                    <li>My Account login times have been improved.</li>
                    <li>Counts of Checked Out and Requested items have been added to the right panel.</li>
                    <li>Shortcut links are now available for popular searches:  New DVDs, New Blu-Ray, and New eBooks.   These searches represent titles that were added to The New Catalog in the past month.</li>
                    <li>New "Added in the Last" filter narrows the search to items added to The New Catalog in the past week, month, or 2 months.</li>
                    <li>Previously, search results had buttons to access either physical items available at a local library, or eresources available online.   Now, if a record has both physical items and an eresources link, both the Access Online and Find in Library buttons will be available.</li>
                    <li>We have added the following fixes affecting some titles available through OverDrive</li>
                    <ol class="alpha">
                        <li>All author names are now in last name, first name format, so the author's name will appear in the Author filter in the correct alphabetical order.   You can still enter your search terms with the names in either order.</li>
                        <li>A sortable title field is now included for all records, so all titles that begin with words like "the" and "and" will be alphabetized correctly.</li>
                        <li>The published year is now int the same format for all titles, so sorting by date is now correct.</li>
                        <li>Some OverDrive titles in our collection were missing from The Catalog.</li>
                    </ol>
                

                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 4.1</span></h2>
            <div>
                Release date 8/13/2014
                <ol class="decimal">
                    <li>Added a popup help section, with documentation on searching, using filters and My Account functions.</li>
                    <li>Added site wide tool tips with links to new Help Section.</li>
                    <li>Improved the site wide language and user instructions. Based on user feedback, we have updated the right panel navigation to highlight MyAccount functionality, such as Renewing items.</li>
                    <li>Miscellaneous bug fixes:
                        <ol class="alpha">
                            <li>Fixed bug with eContent items that were not displaying the full title.</li>
                            <li>Restored location information to search results.</li>
                            <li>Fixed a bug concerning online resources links that were not very descriptive.</li>
                            <li>Fixed a bug with holdings information that was not getting updated correctly.</li>
                        </ol>
                    </li>
                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 4.0</span></h2>
            <div>
                Release date 5/30/2014
                <ol class="decimal">
                    <li>Improved the initial time for users to login to My Account.</li>
                    <li>Improved  search results for Author searches by limiting the search to primary Author information.</li>
                    <li>Added new Author/Artist/Contributor search which is a broader search to find composers, performers, directors, illustrators, etc.</li>
                    <li>Display Author facet  information  in alphabetical order to enable users to easily refine their search results.</li>
                    <li>Disabled the date sort option for Author searching  until user has selected a specific author from the author facet.</li>
                    <li>Improved help text for users when search returns 'no results'.</li>
                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 3.3</span></h2>
            <div>
                Release date 4/30/2014
                <ol class="decimal">
                    <li>Improve the  messaging for users by notifying them that they will be directed to Classic Catalog when paying fines.</li>
                    <li>Added a popup with instructions for users wanting to download their checked out OverDrive materials.</li>
                    <li>Modified  the name for user’s  Wish Lists to "My Lists".</li>
                    <li>Enabled users to make batch updates from the top and the bottom of "My Account" pages.</li> 
                    <li>Added a  confirmation box notifying the users that items have been  successfully added to "My Lists".</li>
                    <li>Added a call number label to Find In Library.</li>
                    <li>Made it more apparent to users how to create a new list while using "My Lists".</li> 
                    <li>Modified "Find In Library" so the default  display includes all items (available and unavailable) and also includes an option for the user option to hide unavailable items.</li>
                    <li>Make the user's preferred libraries more apparent in location dropdown lists.</li>
                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 3.0</span></h2>
            <div>
                Release date 9/10/2013
                <ol class="decimal">
                    <li>Improve search results for title searches when using a search phrase that exactly matches the title.</li>
                    <li>Automatically include alternate forms of the title as part of the search criteria when performing a title search.</li>
                    <li>Enable users to place title requests from the search results page.</li>
                    <li>Make it more apparent to users when logged into My Account that they have outstanding fines.</li>
                    <li>Enable users to select and save their preference for a full or brief display of information when viewing checked out items, requests, wishlists, and  the bookcart  while  logged into My Account. <span class="red">** This feature is currently still in development and will be included in an upcoming release. **</span></li>
                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 2.2</span></h2>
            <div>
                Release date 7/29/2013
                <ol class="decimal">
                    <li>Improve messaging and functionality when placing requests by users without preferred library locations.</li>
                    <li>Misc. bug fixes:
                        <ol class="alpha">
                            <li>Overdrive request that became available does not appear in Requested Items.</li>
                        </ol>
                    </li>
                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 2.1</span></h2>
            <div>
                Release date 7/15/2013
                <ol class="decimal">
                    <li>Enabled the ability to retain your library card number and PIN when logging into My Account.</li>
                    <li>Enable the ability to limit searching to "available only" materials - A checkbox under the search box supports this feature.</li>
                    <li>Misc. bug fixes:
                        <ol class="alpha">
                            <li>Pagination does not display correctly when all items are removed from the Bookcart.</li>
                            <li>Wishlists that exceed 5 pages do not display properly.</li>  
                            <li>Not all messages display indicating why an item cannot be renewed.</li>
                            <li>Provided capability to edits email addresses for notifications about e-materials for online materials from Overdrive. Previously, this was not working correctly.</li>
                        </ol>
                    </li>
                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 2.0</span></h2>
            <div>
                Release date 7/2/2013
                <ol class="decimal">
                    <li>Enable ability for users to retain filters between searches.<br />Provided ability to retain filters across multiple searches.  A checkbox under the search box supports this feature.</li>
                    <li>Improve searching from within the library.<br />Filters are now being displayed in left panel even if there is only a single search result;  therefore, searches can more easily be modified by adding or removing filters.</li>
                    <li>Misc. bug fixes:<br />
                        <ol class="alpha">
                            <li>While in My Account/Account Settings,  the city, state, and zipcode information is not  displaying.</li>
                            <li>The new library catalog is not displaying properly in browsers using  IE 10 Compatibility Mode.</li>
                            <li>Incorrect message being received when a user tries to place a duplicate request for title they already requested.</li>
                            <li>Incorrect message being received when a user tries to place a request for a title they already have checked out.</li>
                            <li>Incorrect message being received by a user when selecting ‘checkout’ for  an Overdrive title which they already have checked out.</li>
                            <li>The new catalog is not displaying the number of Overdrive available copies.</li>
                            <li>Enable out of state library users to pay fines.
                        </ol>
                    </li>
                </ol>
            </div>
            <h2 class="accordion-title">&nbsp;&nbsp;&nbsp;&nbsp;<span class="bold">Release version 1.1</span></h2>
            <div>
                Release date 6/10/2013
                <ol class="decimal">
                    <li>Provided instructions on My Account login for users who haven't set up a PIN.</li>
                    <li>Provided instructions for users to migrate wish lists from the old catalog to the new catalog.</li>
                    <li>Added 'Latest Website Updates page to communicate new features and updates to users.</li>
                    <li>Added 'First Time Using the Catalog? page to provide information about using the new catalog.</li>
                    <li>Added 'Donate to Your Library' link to the bottom of website pages.</li>
                    <li>Miscellaneous bug fixes.</li>
                </ol>
            </div>
        </div>
    </div>
    <div id="right-bar">
    {include file="MyResearch/menu.tpl"}
    {include file="Admin/menu.tpl"}
    </div>
</div>
