<?php
/**
 *
 * Copyright (C) Andrew Nagy 2009
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

require_once 'Action.php';
require_once 'services/MyResearch/lib/User.php';
require_once 'services/MyResearch/lib/Search.php';
require_once 'Drivers/marmot_inc/Prospector.php';

require_once 'sys/SolrStats.php';
require_once 'sys/Pager.php';

class Results extends Action {

	private $solrStats = false;
	private $query;

	function launch() {
		global $interface;
		global $configArray;
		global $timer;
		global $user;
		if(isset($_REQUEST['useLocation'])){
			$_SESSION['useLocation'] = $_REQUEST['useLocation'];
		}
		$searchSource = isset($_REQUEST['searchSource']) ? $_REQUEST['searchSource'] : 'local';
		// Include Search Engine Class
		require_once 'sys/' . $configArray['Index']['engine'] . '.php';
		$timer->logTime('Include search engine');

		//Check to see if the year has been set and if so, convert to a filter and resend.
		$dateFilters = array('publishDate');
		foreach ($dateFilters as $dateFilter){
			if (isset($_REQUEST[$dateFilter . 'yearfrom']) || isset($_REQUEST[$dateFilter . 'yearto'])){
				$queryParams = $_GET;
				$yearFrom = preg_match('/^\d{2,4}$/', $_REQUEST[$dateFilter . 'yearfrom']) ? $_REQUEST[$dateFilter . 'yearfrom'] : '*';
				$yearTo = preg_match('/^\d{2,4}$/', $_REQUEST[$dateFilter . 'yearto']) ? $_REQUEST[$dateFilter . 'yearto'] : '*';
				if (strlen($yearFrom) == 2){
					$yearFrom = '19' . $yearFrom;
				}else if (strlen($yearFrom) == 3){
					$yearFrom = '0' . $yearFrom;
				}
				if (strlen($yearTo) == 2){
					$yearTo = '19' . $yearTo;
				}else if (strlen($yearFrom) == 3){
					$yearTo = '0' . $yearTo;
				}
				if ($yearTo != '*' && $yearFrom != '*' && $yearTo < $yearFrom){
					$tmpYear = $yearTo;
					$yearTo = $yearFrom;
					$yearFrom = $tmpYear;
				}
				unset($queryParams['module']);
				unset($queryParams['action']);
				unset($queryParams[$dateFilter . 'yearfrom']);
				unset($queryParams[$dateFilter . 'yearto']);
				if (!isset($queryParams['sort'])){
					$queryParams['sort'] = 'relevance';
				}
				$queryParamStrings = array();
				foreach($queryParams as $paramName => $queryValue){
					if (is_array($queryValue)){
						foreach ($queryValue as $arrayValue){
							if (strlen($arrayValue) > 0){
								$queryParamStrings[] = $paramName . '[]=' . $arrayValue;
							}
						}
					}else{
						if (strlen($queryValue)){
							$queryParamStrings[] = $paramName . '=' . $queryValue;
						}
					}
				}
				if ($yearFrom != '*' || $yearTo != '*'){
					$queryParamStrings[] = "&filter[]=$dateFilter:[$yearFrom+TO+$yearTo]";
				}
				$queryParamString = join('&', $queryParamStrings);
				header("Location: {$configArray['Site']['path']}/Search/Results?$queryParamString");
				exit;
			}
		}
		
		
		$rangeFilters = array('lexile_score', 'accelerated_reader_reading_level', 'accelerated_reader_point_value');
		foreach ($rangeFilters as $filter){
			if (isset($_REQUEST[$filter . 'from']) || isset($_REQUEST[$filter . 'to'])){
				$queryParams = $_GET;
				$from = preg_match('/^\d*(\.\d*)?$/', $_REQUEST[$filter . 'from']) ? $_REQUEST[$filter . 'from'] : '*';
				$to = preg_match('/^\d*(\.\d*)?$/', $_REQUEST[$filter . 'to']) ? $_REQUEST[$filter . 'to'] : '*';
				
				if ($to != '*' && $from != '*' && $to < $from){
					$tmpFilter = $to;
					$to = $from;
					$from = $tmpFilter;
				}
				unset($queryParams['module']);
				unset($queryParams['action']);
				unset($queryParams[$filter . 'from']);
				unset($queryParams[$filter . 'to']);
				$queryParamStrings = array();
				foreach($queryParams as $paramName => $queryValue){
					if (is_array($queryValue)){
						foreach ($queryValue as $arrayValue){
							if (strlen($arrayValue) > 0){
								$queryParamStrings[] = $paramName . '[]=' . $arrayValue;
							}
						}
					}else{
						if (strlen($queryValue)){
							$queryParamStrings[] = $paramName . '=' . $queryValue;
						}
					}
				}
				if ($yearFrom != '*' || $yearTo != '*'){
					$queryParamStrings[] = "&filter[]=$filter:[$from+TO+$to]";
				}
				$queryParamString = join('&', $queryParamStrings);
				header("Location: {$configArray['Site']['path']}/Search/Results?$queryParamString");
				exit;
			}
		}

		// Initialise from the current search globals
		$searchObject = SearchObjectFactory::initSearchObject();
		$searchObject->init($searchSource);
		$timer->logTime("Init Search Object");

		// Build RSS Feed for Results (if requested)
		if ($searchObject->getView() == 'rss') {
			// Throw the XML to screen
			echo $searchObject->buildRSS();
			// And we're done
			exit();
		}else if ($searchObject->getView() == 'excel'){
			// Throw the Excel spreadsheet to screen for download
			echo $searchObject->buildExcel();
			// And we're done
			exit();
		}

		// TODO : Investigate this... do we still need
		// If user wants to print record show directly print-dialog box
		if (isset($_GET['print'])) {
			$interface->assign('print', true);
		}

		// Set Interface Variables
		// Those we can construct BEFORE the search is executed
		$interface->setPageTitle('Search Results');
		$interface->assign('sortList',   $searchObject->getSortList());
		$interface->assign('rssLink',    $searchObject->getRSSUrl());
		$interface->assign('excelLink',  $searchObject->getExcelUrl());

		$timer->logTime('Setup Search');
		
		// Process Search
		$result = $searchObject->processSearch(true, true);
		if (PEAR::isError($result)) {
			PEAR::raiseError($result->getMessage());
		}
		$timer->logTime('Process Search');

		// Some more variables
		//   Those we can construct AFTER the search is executed, but we need
		//   no matter whether there were any results
		$interface->assign('qtime',               round($searchObject->getQuerySpeed(), 2));
		$interface->assign('spellingSuggestions', $searchObject->getSpellingSuggestions());
		$interface->assign('lookfor',             $searchObject->displayQuery());
		$interface->assign('searchType',          $searchObject->getSearchType());
		// Will assign null for an advanced search
		$interface->assign('searchIndex',         $searchObject->getSearchIndex());
		// We'll need recommendations no matter how many results we found:
		$interface->assign('topRecommendations',
		$searchObject->getRecommendationsTemplates('top'));
		$interface->assign('sideRecommendations',
		$searchObject->getRecommendationsTemplates('side'));

		// 'Finish' the search... complete timers and log search history.
		$searchObject->close();
		$interface->assign('time', round($searchObject->getTotalSpeed(), 2));
		// Show the save/unsave code on screen
		// The ID won't exist until after the search has been put in the search history
		//    so this needs to occur after the close() on the searchObject
		$interface->assign('showSaved',   true);
		$interface->assign('savedSearch', $searchObject->isSavedSearch());
		$interface->assign('searchId',    $searchObject->getSearchId());
		$currentPage = isset($_REQUEST['page']) ? $_REQUEST['page'] : 1;
		$interface->assign('page', $currentPage);

		//Enable and disable functionality based on library settings
		//This must be done before we process each result
		global $library;
		global $locationSingleton;
		$location = $locationSingleton->getActiveLocation();
		if (isset($library) && $location != null){
			$interface->assign('showFavorites', $library->showFavorites);
			$interface->assign('showHoldButton', (($location->showHoldButton == 1) && ($library->showHoldButton == 1)) ? 1 : 0);
		}else if ($location != null){
			$interface->assign('showFavorites', 1);
			$interface->assign('showHoldButton', $location->showHoldButton);
		}else if (isset($library)){
			$interface->assign('showFavorites', $library->showFavorites);
			$interface->assign('showHoldButton', $library->showHoldButton);
		}else{
			$interface->assign('showFavorites', 1);
			$interface->assign('showHoldButton', 1);
		}
		$interface->assign('page_body_style', 'sidebar_left');

		$enableProspectorIntegration = isset($configArray['Content']['Prospector']) ? $configArray['Content']['Prospector'] : false;
		$showRatings = 1;
		if (isset($library)){
			$enableProspectorIntegration = ($library->enablePospectorIntegration == 1);
			$showRatings = $library->showRatings;
		}
		$interface->assign('showRatings', $showRatings);

		$numProspectorTitlesToLoad = 0;
		if ($searchObject->getResultTotal() < 1) {
			
			//Var for the IDCLREADER TEMPLATE
			$interface->assign('ButtonBack',true);
			$interface->assign('ButtonHome',true);
			$interface->assign('MobileTitle','No Results Found');
			
			// No record found
			if ($_REQUEST['basicType'] == 'Author'){
				$new_basic_type = urlencode('Author/Artist/Contributor');
				$interface->assign('author',true);
				$filterlink = null;
				if (isset($_REQUEST['filter'])){
					$filterlink = '&filter[]=' . implode('&amp;filter[]=', array_map('urlencode', $_REQUEST['filter']));
				}
				$interface->assign('contrib_search_link', '/' . $_REQUEST['module'] . '/' . $_REQUEST['action'] . '?basicType=' . $new_basic_type . '&lookfor=' . $_REQUEST['lookfor'] . '&searchSource=' . $_REQUEST['searchSource'] . '&type=' . $new_basic_type . $filterlink);
			}

			$interface->setTemplate('list-none.tpl');
			$interface->assign('recordCount', 0);

			// Was the empty result set due to an error?
			$error = $searchObject->getIndexError();
			if ($error !== false) {
				// If it's a parse error or the user specified an invalid field, we
				// should display an appropriate message:
				if (stristr($error, 'org.apache.lucene.queryParser.ParseException') ||
				preg_match('/^undefined field/', $error)) {
					$interface->assign('parseError', true);

					// Unexpected error -- let's treat this as a fatal condition.
				} else {
					PEAR::raiseError(new PEAR_Error('Unable to process query<br />' .
                        'Solr Returned: ' . $error));
				}
			}

			$numProspectorTitlesToLoad = 10;
			$timer->logTime('no hits processing');

		} else if (($searchObject->getResultTotal() == 1) && ($searchObject->getSearchIndex() == "ISN")){
			//Redirect to the home page for the record
			$recordSet = $searchObject->getResultRecordSet();
			$record = reset($recordSet);
			if ($record['recordtype'] == 'list'){
				$listId = substr($record['id'], 4);
				header("Location: " . $interface->getUrl() . "/MyResearch/MyList/{$listId}");
			}elseif ($record['recordtype'] == 'econtentRecord'){
				$shortId = str_replace('econtentRecord', '', $record['id']);
				header("Location: " . $interface->getUrl() . "/EcontentRecord/$shortId/Home?clear=1");
			}else{
				header("Location: " . $interface->getUrl() . "/Record/{$record['id']}/Home?clear=1");
			}
			
		} else {
			$timer->logTime('save search');
			
			if(isset($_REQUEST["iscart"])){
				$interface->assign('IsCart',true);
			}else{
				$interface->assign('IsCart',false);
			}
			// If the "jumpto" parameter is set, jump to the specified result index:
			$this->processJumpto($result);

			// Assign interface variables
			$summary = $searchObject->getResultSummary();
			$interface->assign('recordCount', $summary['resultTotal']);
			$interface->assign('recordStart', $summary['startRecord']);
			$interface->assign('recordEnd',   $summary['endRecord']);

			$facetSet = $searchObject->getFacetList();

			$interface->assign('facetSet',       $facetSet);
			if(isset($facetSet['format'])){
				//$facetSet['format']['list'] = $this->sortFromMap('format_category_map.properties', $facetSet['format']['list'], 'All Books');
				$x = $facetSet['format'];
				//build a tree array
				$x = $this->sortFromMap('format_category_map.properties', $x, 'All Items');
				//count number of items in array (categories and entries)
				$j = 0;
				$this->countTree($x, & $j);
				//deconstruct into 2 dimensional array to load into view
				$i = 0;
				$flat = array();
				$this->flatten_array($x, $flat, $i, $j, 0, 0);


				// @MD TODO Need to fix tree flatten_array.
				$n = 0;
				foreach($flat as $key => $value){

					if ($n > 27){
						$flat[$n+2] = $value;
					}

					$n++;

				}

				$flat[29] = array('display'=>'Next', 'value'=>ceil(29 / 30), 'parent'=> -1);
				$flat[30] = array('display'=>'Previous', 'value'=>(ceil(30 / 30)+1), 'parent'=> -1);

				//divide into columns
				$temp = array();
				for($i = 0; $i < ceil($j/9); $i++){
					$temp[] = array_slice($flat, ($i*10), 10, 1);
				}
				$interface->assign('tree', $temp);
				$tree_html = $interface->fetch('Search/facet_popup.tpl');
				$interface->assign('tree_html', $tree_html);
			}
			//Check to see if a format category is already set
			$categorySelected = false;
			
			if (isset($facetSet['top'])){
				foreach ($facetSet['top'] as $title=>$cluster){
					if ($cluster['label'] == 'Category'){
						foreach ($cluster['list'] as $thisFacet){
							if ($thisFacet['isApplied']){
								$categorySelected = true;
							}
						}
					}
				}
			}
			$interface->assign('categorySelected', $categorySelected);
			$timer->logTime('load selected category');

			// Big one - our results
			$recordSet = $searchObject->getResultRecordHTML();
			$interface->assign('recordSet', $recordSet);
			$timer->logTime('load result records');
			/*echo "<pre style=\"border: 1px solid #000; height: {$height}; overflow: auto; margin: 0.5em;\">";
			var_dump($result);
			echo "</pre>\n";*/
			// Setup Display
			$interface->assign('sitepath', $configArray['Site']['path']);
			if(isset($_REQUEST["iscart"])) //szheng: modified
			{
				$interface->assign('subpage', 'ei_tpl/Cart/list-list.tpl');
				$interface->setTemplate('../ei_tpl/Cart/list.tpl');
			} else {

				$author_filter = false;

				if (!empty($_REQUEST['filter'])){
					foreach($_REQUEST['filter'] as $key=>$value){
						if (strpos($value, "authorStr:") === false){
							$author_filter = false;
						} else {
							$author_filter = true;
						}
					}
				}

				if (($_REQUEST['basicType'] == 'Author' || $_REQUEST['basicType'] == 'Author/Artist/Contributor') && $author_filter == false){
					$sort = isset($_REQUEST['sort']) ? $_REQUEST['sort'] : null;
					if (strpos($sort, "year") === false){
						
					} else {
						$type = $_REQUEST['type'];
						$filterlink = null;
						if (isset($_REQUEST['filter'])){
							$filterlink = '&filter[]=' . implode('&amp;filter[]=', array_map('urlencode', $_REQUEST['filter']));
						}
						header('Location: /' . $_REQUEST['module'] . '/' . $_REQUEST['action'] . '?lookfor=' . $_REQUEST['lookfor'] . '&basicType=' . $type . $filterlink);
						//echo "redirect would happen here";
					}
					$interface->assign('author_sort_message', true);
				}

				$interface->assign('subpage', 'Search/list-list.tpl');
				$interface->setTemplate('list.tpl');
			}
			
			
			//Var for the IDCLREADER TEMPLATE
			$interface->assign('ButtonBack',true);
			$interface->assign('ButtonHome',true);
			$interface->assign('MobileTitle','Search Results');
			

			// Process Paging
			$link = $searchObject->renderLinkPageTemplate();
			$options = array('totalItems' => $summary['resultTotal'],
                             'fileName'   => $link,
                             'perPage'    => $summary['perPage']);
			$pager = new VuFindPager($options);
			$interface->assign('pageLinks', $pager->getLinks());
			if ($pager->isLastPage()){
				$numProspectorTitlesToLoad = $summary['perPage'] - $pager->getNumRecordsOnPage();
				if ($numProspectorTitlesToLoad < 5){
					$numProspectorTitlesToLoad = 5;
				}
			}
			$timer->logTime('finish hits processing');
		}
		
		if ($numProspectorTitlesToLoad > 0 && $enableProspectorIntegration){
			$interface->assign('prospectorNumTitlesToLoad', $numProspectorTitlesToLoad);
			$interface->assign('prospectorSavedSearchId', $searchObject->getSearchId());
		}else{
			$interface->assign('prospectorNumTitlesToLoad', 0);
		}
		
		//Determine whether or not materials request functionality should be enabled
		$interface->assign('enableMaterialsRequest', MaterialsRequest::enableMaterialsRequest());

		if ($configArray['Statistics']['enabled'] && isset( $_GET['lookfor'])) {
			require_once('Drivers/marmot_inc/SearchStat.php');
			$searchStat = new SearchStat();
			$searchStat->saveSearch( strip_tags($_GET['lookfor']),  strip_tags(isset($_GET['type']) ? $_GET['type'] : $_GET['basicType']), $searchObject->getResultTotal());
		}
		
		$_SESSION['lastSearchId'] = $searchObject->getSearchId();
		if($searchObject->getResultTotal() != 1){
			// Save the ID of this search to the session so we can return to it easily:
			
			// Save the URL of this search to the session so we can return to it easily:
			$_SESSION['lastSearchURL'] = $searchObject->renderSearchUrl();
		}

		// Done, display the page
		$interface->assign('pageType',"search");
		if($searchObject->getSearchType()=="advanced"){
			$interface->assign("lookfor","");
			$_SESSION['lastSearchURL'] = "";
			$_SESSION['lastSearchId'] = "";
		}
		$interface->display('layout.tpl');
	} // End launch()

	/**
	 * Process the "jumpto" parameter.
	 *
	 * @access  private
	 * @param   array       $result         Solr result returned by SearchObject
	 */
	private function processJumpto($result)
	{
		if (isset($_REQUEST['jumpto']) && is_numeric($_REQUEST['jumpto'])) {
			$i = intval($_REQUEST['jumpto'] - 1);
			if (isset($result['response']['docs'][$i])) {
				$record = RecordDriverFactory::initRecordDriver($result['response']['docs'][$i]);
				$jumpUrl = '../Record/' . urlencode($record->getUniqueID());
				header('Location: ' . $jumpUrl);
				die();
			}
		}
	}
	private function to_tree($array, $orig){
		$flat = array();
		$tree = array();
		foreach ($array as $child => $parent) {
			if (!isset($flat[$child])) {
				$flat[$child] = array();
			}
			if (!empty($parent)) {
				$temp = preg_replace('/_/', ' ', $child);
				//echo "$temp<br/>";
				if(isset($orig['list'][$temp])) $flat[$child] = $orig['list'][$temp];
				$flat[$parent][$child] =& $flat[$child];
			} else {
				$tree[$child] =& $flat[$child];
			}
		}
		return $tree;	
	}
	private function sortFromMap($map, array $array, $parent){
		global $configArray;
		$map = $configArray['Site']['translationMapsPath']."/".$map;
		if(!file_exists($map)){
			return;
		}
		$lines = parse_ini_file($map);
		$lines[$parent] = NULL;
		return $this->to_tree($lines, $array);	
	}
	private function countTree($array, $j){
		foreach($array as $key => $value){
			if(is_array($value) && (!empty($value))){
				$j++;
				$this->countTree($value, & $j);
      		}	
  		}
	}
	private function flatten_array(&$arr, &$dst, &$i, $j, $parent, $indent) {
		if(!isset($dst) || !is_array($dst)) {
			$dst = array();
		}
		if(!is_array($arr)) {
			$dst[] = $arr;
		}elseif(isset($arr['value'])){
			$arr['id'] = $i;
			$arr['indent'] = $indent;
			$arr['parent'] = $parent;
			$dst[] = $arr;
		}else {
			foreach($arr as $key=>&$subject) {
				if(!empty($subject)){
					if(!isset($arr[$key]['value'])){
						$count = 0;
						foreach($subject as $s){
							if(is_array($s)){
								$count += count($s);
							}	
						}
						if($count > 0){
							$i++;
							$dst[] = array('display'=>$key, 'id'=>$i, 'parent'=>$parent, 'indent'=>$indent);
							$this->flatten_array($subject, $dst, $i, $j, $i, $indent+1);
						}
					}else{
						$i++;
						$this->flatten_array($subject, $dst, $i, $j, $parent, $indent);
					}
					
				}
			}
		}

	}
}