<?php
/**
 * Examen PHP
 * 
 * @description Script de inicio - Examen Implantacion de Aplicaciones Web
 * @package 	Examen.index
 * @author		Tomas Aparicio <tomas@rijndael-project.com>
 * @date 		19/11/2011  
 * @license		MIT License <http://www.opensource.org/licenses/mit-license.php>
 */

file_exists('examen.class.php') or die('No se puede cargar examen.class.php. Compruebe que el fichero existe.');
require ('examen.class.php');

/**
 * @class	Ejercicio
 * @extends Examen
 * @see 	Class Examen()
 */
class Ejercicio extends Examen
{
	/**
	 * @public
	 */
	public $titulo = 'Examen IAW - Ejercicio 1';
	public $subtitulo;
	public $contenido;
	public $errors;
	public $fecha = '22/11/2011';
	/**
	 * @private
	 */
	private $datos;
	
	/**
	 * @contructor
	 */
	public function __construct ()
	{
		error_reporting(E_ALL); 
		version_compare(PHP_VERSION, '5.0.0', '>=') or die ('La version de PHP debe ser >= 5.0.0');
		class_exists('Plantilla') or die ('Error: la clase Template() es necesaria.');
		
		$this->datos = $this->readDatos();
		switch ((int)$this->datos['pagina'])
		{
			case 2:
				($this->validar($this->datos)) ? $this->page2() : $this->defaultPage();
			break;	
			case 3:
				($this->validar($this->datos)) ? $this->page3() : $this->page2();
			break;	
			case 4:
				($this->validar($this->datos)) ? $this->page4() : $this->page3();
			break;	
			default:
				$this->defaultPage();
			break;	
		}
	}
	
	/**
	 * @description Primera pagina
	 * @private
	 */
	private function defaultPage ()
	{
		$this->setPagina(1);
		$this->subtitulo = 'Completa el siguiente formulario para generar la tabla y pulsa siguiente';
		$this->contenido = '<h3>Rellena el siguiente formulario para continuar</h3>	
		<form method="post" action="'.$_SERVER['PHP_SELF'].'">
			<label for="campos">N&ordm; de Campos: </label><input type="text" name="campos" /><br>
			<label for="columnas">N&ordm; de Columnas: </label><input type="text" name="columnas" />
			<br /><br /><hr />
			<input type="hidden" name="pagina" value="'. ($this->getPagina() + 1) .'" />
			<center>
			<input type="reset" value="Reiniciar formulario" /> &nbsp; <input type="submit" value="Continuar" />
			</center>
		</form>';
	}
	
	/**
	 * @description Segunda pagina
	 * @private
	 */
	private function page2 ()
	{
		$this->setPagina(2);
		$this->subtitulo = 'Generaci&oacute;n de la tabla din&aacute;mica';
		$this->contenido = '<h3>Resultado de la tabla creada</h3>' . "\n";
		
		if ($this->datos['campos'] > 10 || $this->datos['columnas'] > 10) {
			
			$this->addError('En numero de campos o columnas no puede ser mayor de 10.');
			$this->contenido = '<br><input type="reset" value="Volver atr&aacute;s" onclick="window.history.back()" />';
			
		} else {
			$this->contenido .= '<form method="post" action="'.$_SERVER['PHP_SELF'].'">' . "\n";
			$this->contenido .= '<table>' . "\n";
			for ($i=0; $i < $this->datos['campos']; $i++) 
			{
				$this->contenido .= '<tr>' . "\n";
				for ($x=0; $x < $this->datos['columnas']; $x++) {
					$this->contenido .= '<td><label for="'.$i.'-'.$x.'">Fila N&ordm;'.$i.' | Campo N&ordm; '.$x.' de  '.$this->datos['columnas'].'</label><input type="checkbox" name="'.$i.'-'.$x.'"/></td> ' . "\n";
				}
				$this->contenido .= '</tr>' . "\n";
			}
			$this->contenido .= '</table><br /><hr />' . "\n";
			$this->contenido .= '<input type="hidden" name="pagina" value="'. ($this->getPagina() + 1) .'" />' . "\n";
			$this->contenido .= '<center><input type="reset" value="Volver atr&aacute;s" onclick="window.history.back()" />' . "\n";
			$this->contenido .= '<input type="reset" value="Reiniciar formulario" /> <input type="submit" value="Continuar" /></center>' . "\n";
			$this->contenido .= '</form>'; 
		}
	}
	
	/**
	 * @description Tercera pagina
	 * @private
	 */
	private function page3 ()
	{
		$this->setPagina(3);
		print_r ($_POST);
	}
	
	/**
	 * @description Cuarta pagina
	 * @private
	 */
	private function page4 ()
	{
		$this->setPagina(4);
	}
	
	/**
	 * @description Devuelve los valores de $_REQUEST/$_POST
	 * @return {Array}
	 * @see	self::__constructor()
	 * @public
	 */
	public function getDatos ()
	{
		return $this->datos;	
	}

} 


$ejer = new Ejercicio();

$tpl = new Plantilla();
$tpl->set('titulo',$ejer->titulo . ' - Página: ' . $ejer->getPagina() ); 
$tpl->set('subtitulo',$ejer->subtitulo);
$tpl->set('contenido',$ejer->contenido);
$tpl->set('code',$ejer->contenido);
$tpl->set('request',$ejer->getDatos());
$tpl->set('errors',$ejer->getErrors());
$tpl->set('pie', $ejer->titulo . ' | Realizado el ' . $ejer->fecha );
$tpl->show();

?>