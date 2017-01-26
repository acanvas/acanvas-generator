part of @package@;



	 @retain
class @plugin@PluginInitCommand extends Abstract@plugin@Command {

		@override dynamic execute([RdSignal event=null])
		 {
			super.execute(event);
			
			_@pluginLowerCase@Model.sample = "Initialized.";
			
			dispatchCompleteEvent();
			return null;
		}
	}

