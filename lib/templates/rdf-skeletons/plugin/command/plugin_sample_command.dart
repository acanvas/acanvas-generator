part of @package@;

@retain
class @plugin@SampleCommand extends Abstract@plugin@Command {

	@override dynamic execute([AcSignal event=null])
	 {
		super.execute(event);
		
		@plugin@SampleVO vo = event.data as @plugin@SampleVO;
		_@pluginLowerCase@Model.sample = vo.message;
		
		dispatchCompleteEvent();
		return null;
	}
}

