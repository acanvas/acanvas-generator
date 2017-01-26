part of @package@;

class @command@ extends AbstractCommand{
		
    //----------------------------------------------------------------------------

	@override void execute([RdSignal event=null])
	 {
		super.execute(event);

		//HAVE FUN
		
		dispatchCompleteEvent();
		
		// In case of Errors:
		// dispatchErrorEvent();

	}
}

