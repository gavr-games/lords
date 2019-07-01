<?php
class cImage {
  var $fileorig = "";
  var $filenew = "";
  var $width = 0;
  var $height = 0;
  var $type = 0;
  var $attr = 0;
  var $fileext = "";
  
  function __construct($fileorig) {
    if (file_exists($fileorig)){
	$this->fileorig = $fileorig;
	list($this->width, $this->height, $this->type, $this->attr) = getimagesize($fileorig); //$attr is actually not necessary
	switch($this->type){
	  case IMAGETYPE_JPEG:
		  $this->fileext = 'jpg'; break;
	  case IMAGETYPE_PNG:
		  $this->fileext = 'png'; break;
	  case IMAGETYPE_GIF:
		  $this->fileext = 'gif'; break;
	  default:
		  $this->type = 0;
	}
    }
  }
  
  function resize($NEW_FILENAME,$NEW_WIDTH,$NEW_HEIGHT){
    if($this->type){
	switch($this->type){
				case IMAGETYPE_JPEG:
					$img = imagecreatefromjpeg($this->fileorig);
					$img = $this->ChangeImageSizeWithAlpha($img, $this->width, $this->height, $NEW_WIDTH, $NEW_HEIGHT);
					$success = imagejpeg($img, $NEW_FILENAME.".".$this->fileext, 90); //90-compression quality (100 best)
					break;
				case IMAGETYPE_PNG:
					$img = imagecreatefrompng($this->fileorig); 
					$img = $this->ChangeImageSizeWithAlpha($img, $this->width, $this->height, $NEW_WIDTH, $NEW_HEIGHT);
					$success = imagepng($img, $NEW_FILENAME.".".$this->fileext);break;
				case IMAGETYPE_GIF:
					$img = imagecreatefromgif($this->fileorig); 
					$img = $this->ChangeImageSizeWithAlpha($img, $this->width, $this->height, $NEW_WIDTH, $NEW_HEIGHT);
					$success = imagegif($img, $NEW_FILENAME.".".$this->fileext);break;
	}
	if($success){
	  $this->filenew = $NEW_FILENAME.".".$this->fileext;
	  return true;
	} else return false;
    }
  }
  
  function ChangeImageSizeWithAlpha($oImg, $oWidth, $oHeight, $nWidth, $nHeight)
  {
	  $nImg = imagecreatetruecolor($nWidth, $nHeight);
	  imagealphablending($nImg, false);
	  imagesavealpha($nImg, true);
	  imagealphablending($oImg, true); //These 3 lines are to keep transpatency, otherwise there will be black background
	  imagecopyresampled($nImg, $oImg, 0, 0, 0, 0, $nWidth, $nHeight, $oWidth, $oHeight);
	  return $nImg;
  }
}
