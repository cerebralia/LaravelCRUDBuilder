#!/usr/bin/env php
<?php
//
include  "CRUDBuilder/readStructure.php";
define('APP_PATH','app/');
define('RESOURCES_PATH','resources/');
define('CONTROLLER_PATH',APP_PATH.'Http/Controllers/');
define('VIEWS_PATH',RESOURCES_PATH.'views/');
define('ROUTES_PATH','routes/');

//Seccion de Variables
$jsonConfig=null;


$parameters=array();
foreach($argv as $arg){
  if (strpos($arg, "=")){
   $parameters[]=explode("=",$arg);
  }
    else{
     $parameters[]=$arg;
    }
}


cls();
logo();
$Comandos=array();
function parse($parameters){
  global $Comandos;
  foreach ($parameters as $param) {
    if (is_array($param) ){
      //$subCommand=explode("=",$param);
      $id=$param[0];
      $val=explode(",",$param[1]);
      $Comandos[$id]=$val;
        //print_r($id);
        //print_r($val);
    }
  else{
      $Comandos[$param];
      echo "\n Comando :".$param;
  }
  }
}

function cls()
{
    print("\033[2J\033[;H");
}

function Logo(){
echo "\n";
echo "\n██╗  ██╗██████╗  ██████╗ ███████╗ ██████╗ ██╗     ██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗███████╗";
echo "\n██║  ██║██╔══██╗██╔════╝ ██╔════╝██╔═══██╗██║     ██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝";
echo "\n███████║██████╔╝██║  ███╗███████╗██║   ██║██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║███████╗";
echo "\n██╔══██║██╔══██╗██║   ██║╚════██║██║   ██║██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║";
echo "\n██║  ██║██║  ██║╚██████╔╝███████║╚██████╔╝███████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║███████║";
echo "\n╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝";
echo "\n";
echo "\n";
echo "\n LARAVEL 7.0";
echo "\n   ____ ____  _   _ ____                                    _             ";
echo "\n  / ___|  _ \| | | |  _ \    __ _  ___ _ __   ___ _ __ __ _| |_ ___  _ __ ";
echo "\n | |   | |_) | | | | | | |  / _` |/ _ \ '_ \ / _ \ '__/ _` | __/ _ \| '__|";
echo "\n | |___|  _ <| |_| | |_| | | (_| |  __/ | | |  __/ | | (_| | || (_) | |   ";
echo "\n  \____|_| \_\\\\___/|____/   \__, |\___|_| |_|\___|_|  \__,_|\__\___/|_|   ";
echo "\n                            |___/                                         ";
echo "\n";
echo "\n ";

}

function loadJsonConfig($filename){
  /*
  echo "\nCargar archivo JSON con configuracion ? (s,N)";
  $loadjsonfile = stream_get_line(STDIN, 1024, PHP_EOL);
  if (strtoupper($loadjsonfile)=='S'){
    echo "\nTeclea la ubicación del archivo JSON unto con el nombre :";
    $dir=readline();
    echo "\n Leyendo Archivo JSON desde $dir ";
    if (file_exists($dir)){
      $jsonConfig=file_get_contents($dir);
       }
      else{
      echo "\nEl archivo no existe o no esta en la ubicacion";
      exit(1);
      }
  }
  */
    if (file_exists($dir)){
      $jsonConfig=file_get_contents($dir);
       }
      else{
        echo "\nEl archivo no existe o no esta en la ubicacion";
        exit(1);
      }

}

function GenRoutesWEB($ModelName){
  $code = "\n // RUTAS WEB DEL MODELO ".$ModelName;
  $code .= "\nRoute::get('/".$ModelName."','".ucfirst(str_replace("_","",$ModelName))."Controller@index');";
  $code .= "\nRoute::post('/".$ModelName."','".ucfirst(str_replace("_","",$ModelName))."Controller@store');";
  $code .= "\nRoute::get('/".ucfirst(str_replace("_","",$ModelName))."/create','".ucfirst(str_replace("_","",$ModelName))."Controller@create');";
  $code .= "\nRoute::put('/".ucfirst(str_replace("_","",$ModelName))."/edit/{id}','".ucfirst(str_replace("_","",$ModelName))."Controller@update');";
  $code .= "\nRoute::delete('/".ucfirst(str_replace("_","",$ModelName))."/delete/{id}','".ucfirst(str_replace("_","",$ModelName))."Controller@destroy');";
  file_put_contents(ROUTES_PATH."web.php", $code, FILE_APPEND | LOCK_EX);

}

function GenController($ControllerName,$fields){
 $code = "\n<?php";
 $code .= "\n";
 $code .="namespace App\Http\Controllers;\n";
 $code .="\n";
 $code .="\n use App\\".ucfirst(str_replace("_","",$ControllerName)).";";
 $code .="\n use Illuminate\Http\Request;";
 $code .="\n";
 $code .="\nclass ".ucfirst(str_replace("_","",$ControllerName))."Controller extends Controller";
 $code .="\n{";
 $code .="\n   /**";
 $code .="\n    * Display a listing of the resource.";
 $code .="\n    *";
 $code .="\n    * @return \Illuminate\Http\Response";
 $code .="\n    */\n";
 $code .="\n   public function index()";
 $code .="\n   {";
 $code .="\n    \$".ucfirst(str_replace("_","",$ControllerName))." = ".ucfirst(str_replace("_","",$ControllerName))."::paginate(10);";
 $code .="\n       return wiew('".str_replace("_","",$ControllerName).".index')->with(['".ucfirst(str_replace("_","",$ControllerName))."',\$".ucfirst(str_replace("_","",$ControllerName))."]);";
 $code .="\n   }";
 $code .="\n";
 $code .="\n   /**";
 $code .="\n    * Show the form for creating a new resource.";
 $code .="\n    *\n";
 $code .="\n    * @return \Illuminate\Http\Response";
 $code .="\n    */";
 $code .="\n   public function create()";
 $code .="\n   {";
 foreach($fields as $fld){
   if ($fld->FormType=='Relation'){
      $code .="\n    \$".ucfirst(str_replace("_","",$fld-FieldName))."S = ".ucfirst(str_replace("_","",$$fld->FieldName))."::all()"; 
   } 
 } 
 $code .="\n     return view('".str_replace("_","",$ControllerName).".create');";
 $code .="\n   }";
 $code .="\n";
 $code .="\n   /**";
 $code .="\n    * Store a newly created resource in storage.";
 $code .="\n    *\n";
 $code .="\n    * @param  \Illuminate\Http\Request  \$request";
 $code .="\n    * @return \Illuminate\Http\Response";
 $code .="\n    */";
 $code .="\n   public function store(Request \$request)";
 $code .="\n   {";
 $code .="\n    \$".ucfirst(str_replace("_","",$ControllerName))."::create(\$request->all());";
 $code .="\n   }";
 $code .="\n";
 $code .="\n   /**";
 $code .="\n    * Display the specified resource.";
 $code .="\n    *";
 $code .="\n    * @param  \App\ ".str_replace("_","",$ControllerName)."";
 $code .="\n    * @return \Illuminate\Http\Response";
 $code .="\n    */";
 $code .="\n   public function show(\$id)";
 $code .="\n   {";
 $code .="\n     \$".$ControllerName." = ".ucfirst(str_replace("_","",$ControllerName))."::find(id);";
 $code .="\n      return $".$ControllerName.";";
 $code .="\n   }";
 $code .="\n";
 $code .="\n   /**";
 $code .="\n    * Show the form for editing the specified resource.";
 $code .="\n    *";
 $code .="\n    * @param  \App\ ".str_replace("_","",$ControllerName);
 $code .="\n    * @return \Illuminate\Http\Response";
 $code .="\n    */";
 $code .="\n   public function edit(\$id)";
 $code .="\n   {";
 foreach($fields as $fld){
   if ($fld->FormType=='Relation'){
      $code .="\n    \$".ucfirst(str_replace("_","",$fld-FieldName))."S = ".ucfirst(str_replace("_","",$$fld->FieldName))."::all()"; 
   } 
 } 
 $code .="\n     \$".$ControllerName." = ".ucfirst(str_replace("_","",$ControllerName))."::find(id);";
 $code .="\n      return view('".$ControllerName.".edit')->with(['".$ControllerName."'=>$.".$ControllerName."]);";
 $code .="\n   }";
 $code .="\n";
 $code .="\n   /*";
 $code .="\n    * Update the specified resource in storage";
 $code .="\n    *";
 $code .="\n    * @param  \Illuminate\Http\Request  \$request";
 $code .="\n    * @param  \App\ ".str_replace("_","",$ControllerName);
 $code .="\n    * @return \Illuminate\Http\Response";
 $code .="\n    */\n";
 $code .="\n   public function update(Request \$request, \$id)";
 $code .="\n   {";
 $code .="\n     \$".ucfirst(str_replace("_","",$ControllerName))."::update(\$request->all());";
 $code .="\n   }";
 $code .="\n";
 $code .="\n   /**";
 $code .="\n    * Remove the specified resource from storage.";
 $code .="\n    *\n";
 $code .="\n    * @param  \App\ ".str_replace("_","",$ControllerName);
 $code .="\n    * @return \Illuminate\Http\Response\n";
 $code .="\n    */";
 $code .="\n   public function destroy(\$id)";
 $code .="\n   {";
 $code .="\n      \$".$ControllerName." = ".ucfirst(str_replace("_","",$ControllerName))."::find(id);";
 $code .="\n       \$".$ControllerName."->delete();";
 $code .="\n       return view('".str_replace("_","",$ControllerName).".index');";
 $code .="\n   }";
 $code .="\n}";
 $code .="  \n";
 return $code;
}

function genModel($ModelName,$fields)
{
    $code ="\n<?php";
    $code .="\n";
    $code .="\nnamespace App;";
    $code .="\n";
    $code .="\nuse Illuminate\Database\Eloquent\Model;";
    $code .="\n";
    $code .="\nclass " . ucfirst(str_replace("_","",$ModelName)) . " extends Model";
    $code .="\n{";
    $code .="\n    protected \$table='".$ModelName."';";
    foreach($fields as $fld){
    if ($fld->FormType=='Relation'){
      $code .= "\n public function REL_".$fld->TableRel."(){";      
      $code .= "\n    return hasOne('\\App\\".ucfirst(str_replace("_","",$fld->TableRel))."','".$fld->FieldRel."','id')"; 
      $code .="\n }\n";
      } 
    }    

    $code .="\n}";
    $code .="\n}";
    return $code;
}

function GenViewIndex($ModelName,$fields){
    $code  ="\n <?php";
    $code .="\n @extends('layouts.admin')";
    $code .="\n @section('contenido')\n";
    $code .="\n <table class=\"table table-bordered table-striped table-sm\">";
    $code .="\n        <thead>";
    $code .="\n        <tr>";
    $code .="\n            <th><i class=\"fas fa-toolbox\"></i></th>";
    foreach ($fields as $fld) {
        $code .= "\n            <th>" . $fld->FieldName . "</th>";
    }
    $code .="\n        </tr>";
    $code .="\n      </thead>";
    $code .="\n        <tbody>";
    $code .="\n    @foreach(\$".ucfirst(str_replace("_","",$ModelName))." as \$row)";
    $code .="\n            <tr>";
    $code .="\n                <td>";
    $code .="\n                    <a href=\"/encuesta/edit/{{\$row->id}}\" title=\"Editar ".str_replace("_","",$ModelName)."\" class=\"btn btn-xs btn-outline-primary\"><i class=\"fas fa-edit\"></i></a>";
    $code .="\n                    <a href=\"#\" class=\"btn btn-xs btn-outline-danger\" title=\"Borrar ".$ModelName."\" onclick=\"delete".str_replace("_","",$ModelName)."({{\$row->id}})\"><i class=\"fas fa-trash-alt\"></i></a>";
    $code .="\n                </td>";
    foreach ($fields as $fld) {
        $code .="\n                <td>{{\$row->".$fld->FieldName."}}</td>";
    }
    $code .="\n           </tr>";
    $code .="\n    @endforeach";
    $code .="\n        </tbody>";
    $code .="\n    </table>";
    $code .="\n    <script>";
    $code .="\nfunction delete".ucfirst(str_replace("_","",$ModelName))."(id){";
    $code .="\n            Swal.fire({";
    $code .="\n                title: 'Seguro de borrar encuesta?',";
    $code .="\n                text: 'No podrá revertir eso!',";
    $code .="\n                icon: 'warning',";
    $code .="\n                showCancelButton: true,";
    $code .="\n                confirmButtonColor: '#3085d6',";
    $code .="\n                cancelButtonColor: '#d33',";
    $code .="\n                confirmButtonText: 'Si, borrarla!',";
    $code .="\n                cancelButtonText: 'Cancelar'";
    $code .="\n            }).then((result) => {";
    $code .="\n                if (result.value) {";
    $code .="\n                    \$.post('/".str_replace("_","",$ModelName)."/delete/'+id,{\"_token\": \$('meta[name=\"csrf_token\"]').attr('content'),\"_method\":\"delete\"},function(){";
    $code .="\n                        Swal.fire(";
    $code .="\n                            'Borrado!',";
    $code .="\n                            'Encuesta borrada.',";
    $code .="\n                            'success'";
    $code .="\n                        )";
    $code .="\n                    })";
    $code .="\n                }";
    $code .="\n            })";
    $code .="\n        }";
    $code .="\n    </script>";
    $code .="\n    @endsection";
    $code .="\n}";
    return $code;
}

function GenViewEdit($ModelName,$fields){
$code  = "\n<?php";
$code .="\n@extends('layout.admin')";
$code .="\n@section('contenido')";
$code .="\n<div class=\"row\">";
$code .="\n<div class=\"col-md-12 margin-tb\">";
$code .="\n<div class=\"pull-left\">";
$code .="\n<h2>Editar ".$ModelName."</h2>";
$code .="\n</div>";
$code .="\n<div class=\"pull-right\">";
$code .="\n<a class=\"btn btn-primary\" href=\"{{ route('".$ModelName.".index') }}\"> Regresar</a>";
$code .="\n</div>";
$code .="\n</div>";
$code .="\n</div>";
$code .="\n@if (\$errors->any())";
$code .="\n<div class=\"alert alert-danger\">";
$code .="\n<strong>Whoops!</strong> Hay error en loa entrada<br><br>";
$code .="\n<ul>";
$code .="\n    @foreach (\$errors->all() as \$error)";
$code .="\n<li>\{\{ \$error \}\}</li>";
$code .="\n    @endforeach";
$code .="\n</ul>";
$code .="\n</div>";
$code .="\n@endif";
$code .="\n<form action=\"{{ route('".$ModelName.".update',\$".ucfirst(str_replace("_","",$ModelName))."->id) }}\" method=\"POST\">";
$code .="\n@csrf";
$code .="\n@method('PUT')";
$code .="\n<div class=\"row\">";
foreach($fields as $fld) {
    //if ($fld->FormType="Text")
    {
        $code .= "\n<div class=\"form-group\">";
        $code .= "\n<label for=\"".$fld->FieldName."\" class=\"col-sm-4 control-label\">" . $fld->FieldName . "</label>";
        $code .= "\n<div class=\"col-sm-2\">";
        $code .= "\n<input type=\"text\" name=\"blog_title\" value=\"{{ \$" . ucfirst(str_replace("_","",$ModelName)) . "->" . $fld->FieldName . " }}\" class=\"form-control\" placeholder=\"Name\">";
        $code .= "\n</div>";
        $code .="\n</div>";
    }
}

$code .="\n<button type=\"submit\" class=\"btn btn-primary\">Submit</button>";
$code .="\n</div>";
$code .="\n</div>";
$code .="\n</form>";
$code .="\n@endsection";
return  $code;
}


function GenViewCreate($ModelName,$fields){
$code  = "\n<?php";
$code .="\n@extends('layout.admin')";
$code .="\n@section('contenido')";
$code .="\n<div class=\"row\">";
$code .="\n<div class=\"col-md-12 margin-tb\">";
$code .="\n<div class=\"pull-left\">";
$code .="\n<h2>Editar ".$ModelName."</h2>";
$code .="\n</div>";
$code .="\n<div class=\"pull-right\">";
$code .="\n<a class=\"btn btn-primary\" href=\"{{ route('".$ModelName.".index') }}\"> Regresar</a>";
$code .="\n</div>";
$code .="\n</div>";
$code .="\n</div>";
$code .="\n@if (\$errors->any())";
$code .="\n<div class=\"alert alert-danger\">";
$code .="\n<strong>Whoops!</strong> Hay error en loa entrada<br><br>";
$code .="\n<ul>";
$code .="\n    @foreach (\$errors->all() as \$error)";
$code .="\n<li>\{\{ \$error \}\}</li>";
$code .="\n    @endforeach";
$code .="\n</ul>";
$code .="\n</div>";
$code .="\n@endif";
$code .="\n<form action=\"{{ route('".$ModelName.".store',\$".ucfirst(str_replace("_","",$ModelName))."->id) }}\" method=\"POST\">";
$code .="\n@csrf";
$code .="\n";
$code .="\n<div class=\"row\">";
foreach($fields as $fld) {
    //if ($fld->FormType="Text")
    {
        $code .= "\n<div class=\"form-group\">";
        $code .= "\n<label for=\"".$fld->FieldName."\" class=\"col-sm-4 control-label\">" . $fld->FieldName . "</label>";
        $code .= "\n<div class=\"col-sm-2\">";
        $code .= "\n<input type=\"text\" name=\"blog_title\" value=\"{{ \$" . ucfirst(str_replace("_","",$ModelName)) . "->" . $fld->FieldName . " }}\" class=\"form-control\" placeholder=\"Name\">";
        $code .= "\n</div>";
        $code .="\n</div>";
    }
}

$code .="\n<button type=\"submit\" class=\"btn btn-primary\">Submit</button>";
$code .="\n</div>";
$code .="\n</div>";
$code .="\n</form>";
$code .="\n@endsection";
return  $code;
}

function sign(){
echo "\n---------------------------------------------------------------------";
echo "\n┌─┐┌─┐┬ ┬┬  ┌─┐ ┬ ┬┌─┐┬─┐┌┐┌┌─┐┌┐┌┌┬┐┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┬┬   ┌─┐┌─┐┌┬┐";
echo "\n└─┐├─┤│ ││  │ │ ├─┤├┤ ├┬┘│││├─┤│││ ││├┤ ┌─┘│└┘│ ┬│││├─┤││   │  │ ││││";
echo "\n└─┘┴ ┴└─┘┴─┘└─┘o┴ ┴└─┘┴└─┘└┘┴ ┴┘└┘─┴┘└─┘└─┘└──└─┘┴ ┴┴ ┴┴┴─┘o└─┘└─┘┴ ┴";
echo "\n---------------------------------------------------------------------";
echo "\n";
picture();
}

function picture(){
echo "\n                                @@@@&&@&@&&&%*";
echo "\n                            %@@@&&@@@@&@@@@@@@@@&";
echo "\n                          &@@@&&@@@@@@@@@@@@@@@@@@@&";
echo "\n                        &@&@&@@@@@@@@@@@@@@@@@@@@@@@@#";
echo "\n                      *@@&@&&&&%%#####%%#%#%%%&&&&@@@@&";
echo "\n                     ,&@&@&&##(((((((((########%%%&&&@@&";
echo "\n                     /@&%%###((################%%%%&@@@@%  ";
echo "\n                    .&&&%%####((((/((((((((###%%%%%%&@@@&.";
echo "\n                     &&&%&##&&@&@&&&&#((#&&&%%#%%&&&%%@@% ";
echo "\n                     /&&&((%#O&%&&%###(#%&&/#@#&O%%%%%@(";
echo "\n                     *&&#(###############%&%%#%%%%%%%%%&%@";
echo "\n                    ,((%#(#(((((((((((((##%%########%%%&%&";
echo "\n                     (/%#(((((((((##(((/(%##&#(######%%#@";
echo "\n                      ((#(((((((##((###%%&&%#######%#%%%#";
echo "\n                      (((((((((%%%&%%%##&@@&&%####%%%%%";
echo "\n                       .((((((((%&&#(**/**/#@@&%###%%%%%";
echo "\n                        ((((###%%((((((####%%%%%##%%%%%";
echo "\n                         (##(#####(((%&@&&###%%%%%%%%%";
echo "\n                          /####%%%#%#%@@%&%%&&&%%%%%#";
echo "\n                          ../(##&&%&&&&&@&&@&&%%&%%(/";
echo "\n                  ,,,...,... ../###%&&&@&&&&&&%%///**,";
echo "\n          .,,,,......,.... .. ...../###%%%%(/****,**,*////*.";
echo "\n.,.........,,.......... .. .. .. *%%%%%#,.,**,**,,**/**********,";
echo "\n.....,,..... ...,... ..,.. .. ..*%&#%%(%%(%%%*,,.,**,/*,,,,,,,,,,,,,,,,,";
echo "\n............... . .... ..... */*%%&%%%#%%#%&&&&/,,,,*,,.,.,,.,,,,,,,,,,,,,*,*";
echo "\n . .....,... .... .. .....,......%&&%%%%%%&&&%,.,,,,.,,.,,,,.,,,,,,,,,.,,,,.*,**";
echo "\n.. .... .... ....... . .. .....,,.%&&%%%%%%&%,,,,,,,.,,.,.,,.,,,,.,.,,.,,,,.,.**";
echo "\n.  . .. .... . .. ....... ........,%&%%%%%(&..........,.,.,,.,.,,.,.,,.,..,,,.,,";
echo "\n. .. .. . .. . ..... . .. ........./&%%(%%%/......,.....,.,,.,.,,.,.,,.,..,*,.,.";
echo "\n                        █▀ ▄▀█ █░█ █░░ █▀█ █░█ █▀▄ ▀█                            ";
echo "\n                        ▄█ █▀█ █▄█ █▄▄ █▄█ █▀█ █▄▀ █▄                            ";
echo "\n";
}

function help(){
    echo "\n Builder for Laravel 7.0 by Saulo Hernandez O.";
    echo "\n ------------------------------------------------";
    echo "\n Command :  php builder |parameter #1 parameter #2 parameter #3|";
    echo "\n Paramaters : ";
    echo "\n        GenStructure=file.json  -> genera el archivo JSON de la estructura de la BD, este comando se ejecuta solo, ";
    echo "\n         no se puede ejecutar junto con otros comandos";
    echo "\n        configfile=file.json file with the structure en database";
    echo "\n        tables=| All | table 1,table 2,...,table n|  Tables what you want generate";
    echo "\n        make=|controller|,|model|,|view|,route| generate Controllers, Models, View and/or routes of tables\n";
}


function ENV_Parser($fileContent){
   $Content = explode("\n",$fileContent);
   $ENV=array();
   foreach($Content as $con){
     $ENV[substr($con,0,strpos($con,"="))]=substr($con,strpos($con,"=")+1); 
   }
   return $ENV;
}

//$Comandos["gen"]=explode(",","Models,Controller,Views");
//print_r($parameters);
unset($parameters[0]);
parse($parameters);
//print_r($Comandos);
if (count($Comandos)==0){
  help();
  sign();
  exit(0);
}
elseif(isset($Comandos["configfile"][0])){
  echo "\n ".$Comandos["configfile"][0];
   $jsonConfig=json_decode(file_get_contents($Comandos["configfile"][0],FILE_USE_INCLUDE_PATH));
}
else{
    
  if ($Comandos['GenStructure']!="" || $Comandos['genStructure']!="" || $Comandos['genstructure']!=""){
    $dbconf = ENV_Parser(file_get_contents(".env"));
    //print_r($Comandos);
    $db     = new readStructure();
    $db->setDb($dbconf["DB_DATABASE"]);
    $db->setSrv($dbconf["DB_HOST"]);
    $db->setUsr($dbconf["DB_USERNAME"]);
    $db->setPass($dbconf["DB_PASSWORD"]);
    echo "\n ** Generador de la Estructura de la BD JSON **";
    echo "\n Generando estructura automaticamente de la Base de datos ".$dbconf["DB_DATABASE"]." en ".$dbconf["DB_HOST"];
    sleep(2);
    $jsonConfig = $db->readStructure();
    //file_put_contents($Comandos["GenStructure"][0],json_encode($jsonConfig));
    $myfile = fopen($Comandos["GenStructure"][0],"w");
    fwrite($myfile, $jsonConfig);
    fclose($myfile);
    echo "\n Estructura de la BD generada satisfactoriamente en archivo ".$Comandos["GenStructure"][0];
    sign();
    exit(0);
  }

     $dbconf = ENV_Parser(file_get_contents(".env"));
    echo "\n No se encontro archivo de configuracion de la estructura de la base de datos....";
    $db     = new readStructure();
    $db->setDb($dbconf["DB_DATABASE"]);
    $db->setSrv($dbconf["DB_HOST"]);
    $db->setUsr($dbconf["DB_USERNAME"]);
    $db->setPass($dbconf["DB_PASSWORD"]);
    echo "\n Generando estructura automaticamente de la Base de datos ".$dbconf["DB_DATABASE"]." en ".$dbconf["DB_HOST"];
    echo "\n Leyendo informacion de el archico .env ....";
    $jsonConfig = json_decode($db->readStructure());
    //print_r($jsonConfig);
}

  echo "\n Comenzando el proceso de Generación de codigo.....";
   sleep(3);
   foreach($jsonConfig->Tables as $tbl){
    sleep(2);
    foreach ($Comandos["make"] as $mk) {
      if (in_array($tbl->TableName,$Comandos["tables"]) and strtoupper($Comandos["tables"][0])!='ALL'){
        if (strtoupper($mk)=='CONTROLLER'){
           echo "\n Generando ".ucfirst($mk)." de la Tabla ".$tbl->TableName;
           $data = GenController($tbl->TableName,$tbl->fields);
           $myfile = fopen("app/Http/Controllers/".ucfirst(str_replace("_","",$tbl->TableName)).'Controller.php', "w") or die("Unable to open file!");
          fwrite($myfile, $data);
          fclose($myfile);
        }
        if (strtoupper($mk)=='MODEL'){
           echo "\n Generando ".ucfirst($mk)." de la Tabla ".$tbl->TableName;
           $data = GenModel($tbl->TableName,$tbl->fields);
           $myfile = fopen("app/".ucfirst(str_replace("_","",$tbl->TableName)).'.php', "w") or die("Unable to open file!");
          fwrite($myfile, $data);
          fclose($myfile);
        }
       if (strtoupper($mk)=='VIEW'){
                echo "\n Generando ".ROUTEst($mk)." de la Tabla ".$tbl->TableName;
                if (!file_exists('resources/views/'.str_replace("_","",$tbl->TableName))){
                 mkdir('resources/views/'.str_replace("_","",$tbl->TableName));
               }
                $data = GenViewIndex($tbl->TableName,$tbl->fields);
                //INDEX
                $myfile = fopen('resources/views/'.str_replace("_","",$tbl->TableName).'/index.blade.php', "w") or die("Unable to open file!");
                fwrite($myfile, $data);
                fclose($myfile);
                //EDIT
                $data = GenViewCreate($tbl->TableName,$tbl->fields);
                $myfile = fopen('resources/views/'.str_replace("_","",$tbl->TableName).'/edit.blade.php', "w") or die("Unable to open file!");
                fwrite($myfile, $data);
                fclose($myfile);
                //CREATE
                $data = GenViewIndex($tbl->TableName,$tbl->fields);
                $myfile = fopen('resources/views/'.str_replace("_","",$tbl->TableName).'/create.blade.php', "w") or die("Unable to open file!");
                fwrite($myfile, $data);
                fclose($myfile);            }
        if (strtoupper($mk)=='ROUTE'){
          GenRoutesWEB($tbl->TableName);
          echo "\n Agregando Routas del Modelo ".$tbl->TableName;
      }
    }
  else{
        if (strtoupper($mk)=='CONTROLLER'){
           echo "\n Generando ".ucfirst($mk)." de la Tabla ".$tbl->TableName;
           $data = GenController($tbl->TableName,$tbl->fields);
           $myfile = fopen("app/Http/Controllers/".ucfirst(str_replace("_","",$tbl->TableName)).'Controller.php', "w") or die("Unable to open file!");
          fwrite($myfile, $data);
          fclose($myfile);
        }
        if (strtoupper($mk)=='MODEL'){
           echo "\n Generando ".ucfirst($mk)." de la Tabla ".$tbl->TableName;
           $data = GenModel($tbl->TableName,$tbl->fields);
           $myfile = fopen("app/".ucfirst(str_replace("_","",$tbl->TableName)).'.php', "w") or die("Unable to open file!");
          fwrite($myfile, $data);
          fclose($myfile);
        }
       if (strtoupper($mk)=='VIEW'){
                echo "\n Generando ".ucfirst($mk)." de la Tabla ".$tbl->TableName;
                if (!file_exists('resources/views/'.str_replace("_","",$tbl->TableName))){
                 mkdir('resources/views/'.str_replace("_","",$tbl->TableName));
               }
                //index
                $data = GenViewIndex($tbl->TableName,$tbl->fields);
                $myfile = fopen('resources/views/'.str_replace("_","",$tbl->TableName).'/index.blade.php', "w") or die("Unable to open file!");
                fwrite($myfile, $data);
                fclose($myfile);
                //EDIT
                $data = GenViewEdit($tbl->TableName,$tbl->fields);
                $myfile = fopen('resources/views/'.str_replace("_","",$tbl->TableName).'/edit.blade.php', "w") or die("Unable to open file!");
                fwrite($myfile, $data);
                fclose($myfile);
                //CREATE
                $data = GenViewCreate($tbl->TableName,$tbl->fields);
                $myfile = fopen('resources/views/'.str_replace("_","",$tbl->TableName).'/create.blade.php', "w") or die("Unable to open file!");
                fwrite($myfile, $data);
                fclose($myfile);
            }
        if (strtoupper($mk)=='ROUTE'){
          GenRoutesWEB($tbl->TableName);
          echo "\n Agregando Routas del Modelo ".$tbl->TableName;
      }            

  }
  
    }
  
}

sign();