<?php
// source: C:\xampp\htdocs\lekaren\app\presenters/templates/Homepage/default.latte

use Latte\Runtime as LR;

class Template0a5ce5662d extends Latte\Runtime\Template
{
	public $blocks = [
		'content' => 'blockContent',
	];

	public $blockTypes = [
		'content' => 'html',
	];


	function main()
	{
		extract($this->params);
		if ($this->getParentName()) return get_defined_vars();
		$this->renderBlock('content', get_defined_vars());
		return get_defined_vars();
	}


	function prepare()
	{
		extract($this->params);
		if (isset($this->params['med'])) trigger_error('Variable $med overwritten in foreach on line 2');
		Nette\Bridges\ApplicationLatte\UIRuntime::initialize($this, $this->parentName, $this->blocks);
		
	}


	function blockContent($_args)
	{
		extract($_args);
		$iterations = 0;
		foreach ($medicine as $med) {
?>
    <div class="post">
        <h2><?php echo LR\Filters::escapeHtmlText($med->id_sukl) /* line 4 */ ?></h2>

        <div><?php echo LR\Filters::escapeHtmlText($med->nazov) /* line 6 */ ?></div>
    </div>
<?php
			$iterations++;
		}
		
	}

}
