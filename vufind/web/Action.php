<?php
/**
 *
 * Copyright (C) Villanova University 2007.
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
require_once 'PEAR.php';

// Abstract Base Class for Actions
class Action extends PEAR{

	protected $catalog;

	function __construct(){

		// until we add a class/schema for this, we will use the action.php to populate the notification center.
		global $interface;
		global $configArray;
		global $user;

		$notifications = array();
		$notifications['messages'] = null;
		$notifications['count'] = 0;
		$notifications['state'] = 0;

		$this->catalog = new CatalogConnection($configArray['Catalog']['driver']);

		if ($user){
			$patron = $this->catalog->patronLogin($user->cat_username, $user->cat_password);
			$profile = $this->catalog->getMyProfile($patron);

			if ($profile['fines'] != '$0.00'){
				$notifications['messages'][] = 'You have ' . $profile['fines'] . ' in overdue fines. <input type="button" class="pay-fine-button" onclick="window.open(\'http://catalog.einetwork.net/patroninfo\')" value="Pay Fine" title="Pay overdue fine on-line" />';
			}

			if ($profile['expireclose'] == 1){
				$notifications['messages'][] = 'Your library card is due to expire within the next 30 days. Please visit your local library to renew your card to ensure access to all online services.';
			} elseif ($profile['expireclose'] == -1){
				$notifications['messages'][] = 'Your library card is expired. Please visit your local library to renew your card to ensure access to all online service.';
			}

			$notifications['count'] = count($notifications['messages']);
			$notifications['state'] = isset($_SESSION['notification_popupstate']) ? $_SESSION['notification_popupstate'] : 0;

			$interface->assign('notifications', $notifications);
		}

	}

    function launch()
    {
    }
        
}

?>
