<?php
 /*
     An overlayed bar graph, uggly no?
     Recieves chart_id,tab_id from $_GET.
     The values are stored in $_SESSION.
 */
 
 session_start();
 
 // Standard inclusions   
 include("../../../general_classes/pChart/pData.class");
 include("../../../general_classes/pChart/pChart.class");
 include("../../../general_classes/pChart/pCache.class");

 // Dataset definition 
 $DataSet = new pData;
 $vnum = count($_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['values']);
 $k = 0;
 $maxVal = 0;
 $AbsciseLabelSerie = $my_series = Array();
 foreach($_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['values'] as $id=>$value)	{
 	 $my_series[] = 's'.$id;
 	 for($i=0;$i<$vnum;$i++)	{
 	 	 if ($i==$k) $DataSet->AddPoint($value['value'],'s'.$id);
 	 	 else $DataSet->AddPoint(0,'s'.$id);
 	 }
 	 if ($value['value']>$maxVal) $maxVal = $value['value'];
 	 $DataSet->AddPoint('','abscis');
 	 $k++;
 }
 foreach($my_series as $serie) $DataSet->AddSerie($serie);
 $DataSet->SetAbsciseLabelSerie('abscis');
 foreach($_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['values'] as $id=>$value)	{
 	 $DataSet->SetSerieName($value['name'],'s'.$id);
 }
 // Cache definition   
 //$Cache = new pCache("../../../cache/statistics/");  
 //$Cache->GetFromCache("Graph".$_SESSION['game_id'],$DataSet->GetData());  

 // Initialise the graph
 $Test = new pChart(300,180);
 $i = 0;
 foreach($_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['values'] as $id=>$value)	{
 	 $mR = hexdec(substr($value['color'],1,2));
 	 $mG = hexdec(substr($value['color'],3,2));
 	 $mB = hexdec(substr($value['color'],5,2));
 	 $Test->setColorPalette($i,$mR,$mG,$mB);
 	 $i++;
 }
 $Test->setFontProperties("../../../general_classes/pChart/Fonts/verdana.ttf",6);
 $Test->setGraphArea(40,30,200,150);
 $Test->drawFilledRoundedRectangle(7,7,293,176,5,40,40,40);
 $Test->drawRoundedRectangle(5,5,295,178,5,235,212,143);
 $Test->drawGraphArea(0,0,0,TRUE);
 if ($maxVal==0) $maxVal = 1;
 $Test->setFixedScale(0,$maxVal+ceil($maxVal/10));
 $Test->drawScale($DataSet->GetData(),$DataSet->GetDataDescription(),SCALE_START0,255,255,255,TRUE,0,2,TRUE);
 $Test->drawGrid(4,TRUE,80,80,80,15);

 // Draw the 0 line
 $Test->setFontProperties("../../../general_classes/pChart/Fonts/verdana.ttf",7);
 $Test->drawTreshold(0,143,55,72,TRUE,TRUE);

 // Draw the bar graph
 $Test->drawOverlayBarGraph($DataSet->GetData(),$DataSet->GetDataDescription(),100);
 
 $data = $series = Array();
 foreach($_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['values'] as $id=>$value)	{
 	 $data[] = array('Name'=>'','s'.$id=>$value['value']);
 	 $series[] = 's'.$id;
 }

 $Test->setFontProperties("../../../general_classes/pChart/Fonts/verdana.ttf",10);
 $i = 0;

 // Finish the graph
 $Test->setFontProperties("../../../general_classes/pChart/Fonts/verdana.ttf",8);
 $DataSet->RemoveSerie('abscis');
 $Test->drawLegend(210,30,$DataSet->GetDataDescription(),250,250,250,-1,-1,-1,0,0,0);
 foreach($_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['values'] as $id=>$value)	{
 	 $Test->setColorPalette($i,250,250,250);
 	 $i++;
 }
  //$Test->drawFilledRectangle(40,10,200,24,0,0,0,false,100);
  //$Test->drawFilledRectangle(40,10,200,24,255,255,255,false,100);
 $Test->writeValues($data,$DataSet->GetDataDescription(),$series);
 $Test->setFontProperties("../../../general_classes/pChart/Fonts/verdana.ttf",8);
 $Test->drawTitle(20,22,$_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['name'],250,250,250,230);
 // Render the graph  
 //$Cache->WriteToCache("Graph".$_SESSION['game_id'],$DataSet->GetData(),$Test);  
 $Test->Stroke();
?>