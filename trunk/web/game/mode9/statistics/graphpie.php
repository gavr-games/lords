<?php
 /*
     A smooth flat pie graph
     Recieves chart_id,tab_id from $_GET.
     The values are stored in $_SESSION.
 */

 session_start();
 
 // Standard inclusions   
 include("../../../general_classes/pChart/pData.class");
 include("../../../general_classes/pChart/pChart.class");

 // Dataset definition 
 $DataSet = new pData;
 foreach($_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['values'] as $id=>$value)	{
 	 $values[] = $value['value'];
 	 $names[]  = $value['name'];
 }
 $DataSet->AddPoint($values,"Values");
 $DataSet->AddPoint($names,"Names");
 $DataSet->AddAllSeries();
 $DataSet->SetAbsciseLabelSerie("Names");

 // Initialise the graph
 $Test = new pChart(300,200);
 $i = 0;
 foreach($_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['values'] as $id=>$value)	{
 	 $R = hexdec(substr($value['color'],1,2));
 	 $G = hexdec(substr($value['color'],3,2));
 	 $B = hexdec(substr($value['color'],5,2));
 	 $Test->setColorPalette($i,$R,$G,$B);
 	 $i++;
 }
 //$Test->loadColorPalette("Sample/softtones.txt");
 $Test->drawFilledRoundedRectangle(7,7,293,193,5,40,40,40);
 $Test->drawRoundedRectangle(5,5,295,195,5,0,0,0);

 // This will draw a shadow under the pie chart
 $Test->drawFilledCircle(122,102,70,200,200,200);

 // Draw the pie chart
 $Test->setFontProperties("../../../general_classes/pChart/Fonts/verdana.ttf",8);
 $Test->AntialiasQuality = 0;
 $Test->drawBasicPieGraph($DataSet->GetData(),$DataSet->GetDataDescription(),120,100,70,PIE_PERCENTAGE,255,255,218);
 $Test->drawPieLegend(210,15,$DataSet->GetData(),$DataSet->GetDataDescription(),250,250,250);
 $Test->drawTitle(200,183,$_SESSION['tabs'][$_GET['tab_id']]['charts'][$_GET['chart_id']]['name'],250,250,250,230);
 
 $Test->Stroke();
?>