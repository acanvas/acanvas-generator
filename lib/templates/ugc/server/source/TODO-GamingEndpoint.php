<?php
class GamingEndpoint extends CRUDEndpoint {

	/* ########################################################
	
		Return how many times the user has max played today
	
	######################################################## */
	
	/** 
	 * @param string $uid
	 * @return boolean 
	 */
	public function checkPermissionToPlay( $uid) {
		
		$result = mysql_query ("SELECT COUNT( score ) AS loginstoday FROM rockdotdemo_user_games WHERE uid='$uid' AND DATE(timestamp) = CURDATE()");
		$row = mysql_fetch_assoc ( $result );
		$rowObj = $this->_asObj($row);
		
		//set max value in accounts.properties
		$max = 1; 
		$is = $rowObj->loginstoday;
		
		if($is < $max){
			return true;
		}
		else{
			return false;	
		}
	}
	
	/* ########################################################
	
		Return if the user has max played today in given locale
	
	######################################################## */
	
	/** 
	 * @param object $gameObj
	 * @return boolean 
	 */
	public function checkPermissionToPlayLocale( $gameObj) {
		
		$uid = $gameObj->uid;
		$locale = $gameObj->locale;
		
		$result = mysql_query ("SELECT COUNT( score ) AS loginstoday FROM rockdotdemo_user_games WHERE uid='$uid' AND DATE(timestamp) = CURDATE() AND control = '$locale'");
		$row = mysql_fetch_assoc ( $result );
		$rowObj = $this->_asObj($row);
		
		//set max value in accounts.properties
		$max = 1;  
		$is = $rowObj->loginstoday;
		
		if($is < $max){
			return true;
		}
		else{
			return false;	
		}
	}
	
	/* ########################################################
	
		Adds a new Gameresult, returns readPermissionToPlay($uid)
	
	######################################################## */
	
	/** 
	 * @param object $gameObj
	 * @return boolean 
	 */
	public function saveGame( $gameObj) {
		
		$result = $this->create($gameObj, "rockdotdemo_user_games");
		return true;
	}
	
	
	
	/* ########################################################
	
		Set Score of a Game's level, calculate and save scored sum of all levels combined
		returns rank and score
	
	######################################################## */
	
	/** 
	 * @param object $gameObj
	 * @return object 
	 */
	public function setScore( $gameObj) {
		
		$uid = $gameObj->uid;
		
		$result = $this->update($gameObj, "rockdotdemo_user_games", "WHERE uid='$uid' AND level=$gameObj->level");
		if($result == 0){
			$result = $this->create($gameObj, "rockdotdemo_user_games");
		}
		
		$result = mysql_query ("SELECT SUM( score ) AS sum_score FROM rockdotdemo_user_games WHERE uid='$uid' ");
		$row = mysql_fetch_assoc ( $result );
		
		$asObj = $this->_getRank( $uid );
		$rowObj = $this->_asObj($row);
		$asObj->score = $rowObj->sum_score;	
				
		mysql_query ( "UPDATE rockdotdemo_users_extended SET score=$asObj->score WHERE uid='$uid'" );
		
		return $asObj;
	}
	
	/* ########################################################
	
		Highscore
	
	######################################################## */
	
	
	/** 
	 * @param string $uid
	 * @param array $friends
	 * @return object 
	 */
	public function getHighscore( $uid, $friends ) {
	 	
		if(!empty($uid)){
			//user's rank and score
			$ret = $this->_getRank($uid);
			$result = mysql_query ( "SELECT score FROM rockdotdemo_users_extended WHERE uid='$uid'"  );
			$row = mysql_fetch_assoc ( $result );
			$ret->score = $this->_asObj($row)->score;
		}
		
		$ret->topTen = array();
		$result = mysql_query ( "SELECT * FROM rockdotdemo_users_extended ORDER BY score, scoredate ASC DESC LIMIT 10" );
		while ( $row = mysql_fetch_assoc ( $result ) ) {
			array_push ( $ret->topTen,  $this->_asObj($row));
		}
		
		if(!empty($friends)){
			$strFriends = "\"" . implode("\",\"", $friends) . "\"";
			$ret->topFiveFriends = array();
			$result = mysql_query ( "SELECT * FROM rockdotdemo_users_extended WHERE uid IN ($strFriends) ORDER BY score DESC, scoredate ASC LIMIT 5" );
			while ( $row = mysql_fetch_assoc ( $result ) ) {
				array_push ( $ret->topFiveFriends,  $this->_asObj($row));
			}
		}
		
		return $ret;
	}
	
	
	private function _getRank($score){
		$score = mysql_real_escape_string($score);
		$str = "SELECT COUNT( * ) + 1 AS rank FROM rockdotdemo_users_extended WHERE score>$score";
		$result = mysql_query ($str);
		$row = mysql_fetch_assoc ( $result );
		return $this->_asObj($row);
	}
	
}