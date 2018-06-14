part of @package@;

	 class @plugin@ModelInjector implements IObjectPostProcessor {
		 IObjectFactory _applicationContext;
	 @plugin@ModelInjector(IObjectFactory applicationContext) {
			_applicationContext = applicationContext;
		}

		 dynamic postProcessAfterInitialization(dynamic object,String objectName)
		 {
			if (object is I@plugin@ModelAware) {
				object.@pluginLowerCase@Model = _applicationContext.getObject(@plugin@Constants.MODEL_@pluginUpperCase@);
			}
			
			return object;
		} 
		 dynamic postProcessBeforeInitialization(dynamic object,String objectName)
		 {
		   return object;
		}
	}

