<?php
/**
 * Implantacion de Aplicaciones Web - Examen PHP
 * 
 * @description Examen classes
 * @package 	examen.class.php
 * @author		Tomas Aparicio <tomas@rijndael-project.com>
 * @version		19/11/2011 revision 16
 * @license		MIT Licensed <http://www.opensource.org/licenses/mit-license.php>
 */


/** 
 * @class Examen
 * @abstract
 */
abstract class Examen
{
	/**
	 * @private
	 */
	// instancia singleton
	private static $instancia;
	private $pagina = 1;
	private $errors = array();
	/**
	 * @protected
	 */
	protected $validate = true;
		
	/**
	 * @description	Implementacion de ejemplo de metodo singleton (no usada)
	 * @return	{Object}
	 * @public
	 */
	public static function singleton () 
	{
		if (!isset(self::$instancia)) {
			echo 'Creando nueva instancia.';
			$nombreClase = __CLASS__;
			self::$instancia = new $nombreClase;
		}
		return self::$instancia;
	}	
	
	/**
	 * @description	Normaliza los valores string de un Array recursivamente 
	 * @param	{Array} Array a normalizar
	 * @return	{Array}
	 * @protected
	 */
	protected function normalizeArray ($arr) 
	{
		if (!empty($arr) && is_array($arr))
		{
			foreach ($arr as $k => $v) {
				if (is_array($v)) {
					$arr[$k] = $this->normalizeArray($v);
				} else {
					$v = stripslashes(strip_tags(htmlspecialchars_decode($v))); // strtolower()
					if (get_magic_quotes_gpc()) $v = stripslashes($v);					 
					if (is_int($v)) $v = (int)$v;
					// redefinimos en el array
					$arr[$k] = $v;
				}
			}
			return $arr;
		} 
		return false;	
	}
	
	/**
	 * @description	Recorre y gestiona los datos recibidos via POST
	 * @return	{Array} Nuevos valores POST validados
	 * @protected
	 */
	protected function readDatos ()
	{
		if (count($_POST) > 0)
		{
			$post = array();
			foreach ($_POST as $key => $value) {
				$key = strip_tags($key);
				$value = trim(strip_tags($value));
				//if ($key != 'pagina') 
				$post[$key] = $value;
			}
			return $post;
		} else {
			return false;
		}		
	}
	
	/**
	 * @description	Comprueba si todos los valores no estan vacios
	 * @param		{Array} Datos a validar
	 * @see			self::validate
	 * @protected
	 */
	protected function validar ($datos)
	{
		if ($this->validate) {
			$validate = true;
			foreach ($datos as $i => $v)
			{
				if (empty($v)) {
					$this->addError('El campo "'.$i.'" no puede estar vacio. Introduzca un valor.');
					$validate = false;
				}
			}
			return $validate; 
		}
	}
	
	/**
	 * @description	Define un nuevo numero de pagina actual
	 * @param		{Integer} Numero pagina
	 * @see			self::getPagina()
	 * @public
	 */
	protected function setPagina ($page)
	{
		if (!empty($page)) 
		{
			$this->pagina = (int)$page;
		} else {
			$this->addError('La pagina no es valida.');
		}
	}
	
	/**
	 * @description	Devuelve el numero de pagina actual
	 * @return		{Integer} Numero pagina
	 * @see			self::setPagina()
	 * @public
	 */
	public function getPagina ()
	{
		return $this->pagina;
	}
		
	/**
	 * @description	Almacenar un nuevo error en self::errors
	 * @return		{Integer} Numero pagina
	 * @see			self::getErrors()
	 * @protected
	 */
	protected function addError($text)
	{
		if (!empty($text)) 
		{
			$this->errors[] = $text;
		}
	}
	
	/**
	 * @description	Devuelve el conjunto de errores si existen en self::errors
	 * @return		{String} Cojunto de errores separados por <br />. Opcional
	 * @see			self::addError()
	 * @public
	 */
	public function getErrors($delimiter='<br />')
	{
		if (!empty($this->errors)) {
			return implode($delimiter,$this->errors);
		}
	}	
	
	private function debugTrace ($var,$level=1)
	{
		$result = var_export( $var, true );
		$trace = debug_backtrace();
		$file = $trace[$level]['file'];
		$line = $trace[$level]['line'];
		$object = $trace[$level]['object'];
		if (is_object($object)) $object = get_class($object);
		$value = "Llamada: linea $line de $object \n(en $file)";
		return "\n<pre>Dump: $value\n$result</pre>";
	}
	
}

/** 
 * @class Plantilla
 */
class Plantilla
{
	/**
	 * @protected
	 */
	protected $data = array();
	/**
	 * @private
	 */
	private $template = 'examen.tpl';
	private $autor = 'Tomás Aparicio';
	private $licencia = 'Licencia MIT';
	private $licenurl = 'http://www.opensource.org/licenses/mit-license.php';
	private $srcfile = 'examen-source.zip';

	/**
	 * @constructor
	 */
	public function __construct ()
	{
		file_exists($this->template) or die ('Error iniciando la clase Template(): compruebe que el fichero "'. $this->template .'" existe en el directorio actual!');
		header ('Content-type: text/html; charset=UTF-8'); // forzamos UTF-8 
		header ('X-Powered-By: Examen PHP IAW por ' . $this->autor ); // HTTP response header personalizado :)
	}
		
	/**
	 * @description Parsea y reemplaza el fichero template
	 * @param  {string}  Nodo a reemplazar en la plantilla @see @doc
	 * @return {string}  Plantilla reemplazada
	 * @exception
	 * @private
	 * @doc @param $index - Valores posibles:
	 * - {string}   titulo    	Titulo de la pagina (<head> y <body>)
	 * - {string}   subtitulo  	Subtitulo en <body>
	 * - {string}   contenido   Bloque de contenido principal 
	 * - {string}  	code   		Bloque de codigo a mostrar  @see selft::toCode()             
	 * - {string}  	request		Bloque de request @see self::printR()
	 * - {string}  	pie      	Pie de la pagina
	 */
	public function set ($index,$value)
	{
		try {
			if (!empty($index) && !empty($value))
			{
				if (array_key_exists($index,$this->data)) {
					$this->data[$index]	.= $value;
				} else {
					$this->data	= array_merge($this->data, array($index => $value));
				}
			}
		} catch (Exception $e) {
			die ('Error en Template::set(): ' . $e);	
		}
	}

	/**
	 * @description Parsea y reemplaza el fichero template
	 * @return {string}  Plantilla
	 * @private
	 */
	private function parse()
	{
		if (!is_readable($this->template))
		{
			die('Error in Template::parse() - "' . $this->template . '" no se puede leer. Compruebe que el fichero existe.');
		}
		$tpl = file_get_contents($this->template);

		foreach ($this->data as $var => $content)
		{
			$var = trim(strtolower($var));
			switch ($var) 
			{
				case 'subtitulo': 
					$content = '<h2>' . $content . '</h2>';
				break;
				case 'errors': 
					$content = '<div class="errors">ERRORES ENCONTRADOS: <br />' . $content . '</div>';
				break;
				case 'code': 
					$content = $this->toCode($content);
				break;
				case 'request': 
					$content = $this->printR($content);
				break;
				case 'pie': 
					$content = '<b>' . $content . ' <br /> '. $this->autor . ' (CC) ' . date('Y') ;
					$content .= ' | <a href="' .$this->srcfile. '">Código fuente</a> bajo <a href="' .$this->licenurl. '">'.$this->licencia.'</a></b>';
				break;
			}
			$tpl = preg_replace('#([{]'.$var.'[}])#', $content, $tpl);
		}
		// eliminamos el resto no reemplazado
		$tpl = preg_replace('#([{](.*)[}])#', '', $tpl);
		return $tpl;
	}
	
	/**
	 * @description Hace un htmlentities() a un string HTML para visualizarlo codificado
	 * @param 	{String} HTML codigo a visualizar. Requerido
	 * @return {string} HTML resultante
	 * @private
	 */
	private function toCode ($code)
	{
		if (!empty($code))
		{
			return '<h3>C&oacute;digo HTML generado:</h3><pre><code>' . htmlentities($code) . '</code></pre>';	
		}		
	}
	
	/**
	 * @description Hace un print_r() de un array. Empleado para mostrar $_REQUEST,$_POST,$_GET,$_FILES
	 * @param 	{Array}	Array a visualizar. Requerido
	 * @return 	{string} HTML
	 * @private
	 */
	private function printR ($array)
	{
		if (!empty($array) && is_array($array))
		{
			return '<h3>Datos recibidos vía HTTP POST/GET method:</h3><pre><code>' . htmlentities(print_r($array,true)) . '</code></pre>';	
		}		
	}

	/**
	 * @description Hace un echo() de la plantilla a generada
	 * @param {string} Template file
	 * @public
	 */
	public function show()
	{
		echo $this->parse();
	}

}

?>